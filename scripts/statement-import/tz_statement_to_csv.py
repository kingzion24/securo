#!/usr/bin/env python3
"""Convert Tanzanian statement PDFs (M-Pesa/Vodacom, TCB Bank) into a CSV
that Securo's importer can read directly.

Securo's CSV importer (backend/app/services/import_service.py) supports
explicit column mapping and split inflow/outflow columns, so the output
here is deliberately shaped to match that: date, description, inflow,
outflow, balance. `balance` is not imported (it's not a mappable field) —
it's kept purely so you can eyeball the running balance against the
statement while reviewing the CSV before import.

Usage:
    python3 tz_statement_to_csv.py --format mpesa statement.pdf -o mpesa.csv
    python3 tz_statement_to_csv.py --format tcb statement.pdf -o tcb.csv
    python3 tz_statement_to_csv.py statement.pdf -o out.csv   # auto-detect

Requires `pdftotext` (poppler-utils) on PATH for .pdf input. Plain .txt
input (already-extracted text) is also accepted, mainly for testing.

Then in Securo: Accounts -> Import -> CSV, and map columns:
  - Date column: date        (date format: DD/MM/YYYY)
  - Description column: description
  - Inflow column: inflow
  - Outflow column: outflow
"""
from __future__ import annotations

import argparse
import csv
import re
import subprocess
import sys
from dataclasses import dataclass


@dataclass
class Row:
    date: str  # DD/MM/YYYY
    description: str
    inflow: str  # "" or positive amount
    outflow: str  # "" or positive amount
    balance: str


def extract_text(path: str) -> str:
    if path.endswith(".txt"):
        with open(path, encoding="utf-8") as f:
            return f.read()
    result = subprocess.run(
        ["pdftotext", "-layout", path, "-"],
        capture_output=True, text=True, check=True,
    )
    return result.stdout


def detect_format(text: str) -> str:
    head = text[:3000].lower()
    if "vodacom" in head or "m-pesa" in head:
        return "mpesa"
    if "tcb bank" in head or "deposit account statement" in head:
        return "tcb"
    raise ValueError("Could not auto-detect statement format; pass --format mpesa|tcb")


# ---------------------------------------------------------------------------
# M-Pesa (Vodacom Tanzania)
# ---------------------------------------------------------------------------
# Rows start with a DD-MM-YYYY date. Everything up to the next date-start
# line (or EOF) belongs to that row. Fields in between: From/To identifiers
# (phone/till/paybill numbers, no thousands separator), then Amount and
# Balance (always comma-grouped or a bare 1-5 digit number), then a
# free-text Description that determines direction.
_MPESA_ROW_START = re.compile(r"^(\d{2}-\d{2}-\d{4})\s+(.*)$")
_MONEY_TOKEN = re.compile(r"^\d{1,3}(?:,\d{3})*$|^\d{1,5}$")

# Prefixes that mean money left the account.
_MPESA_DEBIT_PREFIXES = (
    "pay bill", "merchant payment", "customer transfer to",
    "overdraft repayment", "withdraw", "cash out", "airtime purchase",
)
# Prefixes that mean money arrived.
_MPESA_CREDIT_PREFIXES = (
    "customer transfer from", "business payment from", "salary payment from",
    "deposit", "cash in", "reversal", "funds received",
)


def classify_mpesa_direction(description: str) -> str:
    desc = description.strip().lower()
    for prefix in _MPESA_CREDIT_PREFIXES:
        if prefix in desc:
            return "credit"
    for prefix in _MPESA_DEBIT_PREFIXES:
        if prefix in desc:
            return "debit"
    # Fallback heuristic: "to <someone>" reads as outgoing, "from <someone>"
    # as incoming. Flagged rows (direction "unknown") still land in the CSV
    # so they're easy to spot and fix by hand before importing.
    if " to " in desc or desc.startswith("pay"):
        return "debit"
    if " from " in desc:
        return "credit"
    return "unknown"


def parse_mpesa(text: str) -> list[Row]:
    lines = [ln.rstrip() for ln in text.splitlines()]
    blocks: list[str] = []
    current: list[str] = []
    for line in lines:
        if _MPESA_ROW_START.match(line):
            if current:
                blocks.append(" ".join(current))
            current = [line]
        elif current:
            current.append(line.strip())
    if current:
        blocks.append(" ".join(current))

    rows: list[Row] = []
    for block in blocks:
        m = _MPESA_ROW_START.match(block)
        if not m:
            continue
        date, rest = m.group(1), m.group(2)
        tokens = rest.split()

        # Find the (amount, balance) pair: two consecutive money-shaped
        # tokens. Skip past From/To identifiers first.
        pair_idx = None
        for i in range(len(tokens) - 1):
            if _MONEY_TOKEN.match(tokens[i]) and _MONEY_TOKEN.match(tokens[i + 1]):
                pair_idx = i
                break
        if pair_idx is None:
            continue  # unparseable row; skipped rather than guessed

        amount_str, balance_str = tokens[pair_idx], tokens[pair_idx + 1]
        description = " ".join(tokens[pair_idx + 2:]).strip()
        # Collapse "Description continued -\n NAME" wrapping artifacts.
        description = re.sub(r"\s+-\s+", " - ", description)
        description = re.sub(r"\s{2,}", " ", description)

        direction = classify_mpesa_direction(description)
        amount = amount_str.replace(",", "")
        dd, mm, yyyy = date.split("-")
        iso_date = f"{dd}/{mm}/{yyyy}"

        if direction == "credit":
            inflow, outflow = amount, ""
        elif direction == "debit":
            inflow, outflow = "", amount
        else:
            inflow, outflow = "", f"UNKNOWN:{amount}"

        rows.append(Row(iso_date, description, inflow, outflow, balance_str.replace(",", "")))
    return rows


# ---------------------------------------------------------------------------
# TCB Bank PLC
# ---------------------------------------------------------------------------
_TCB_ROW_START = re.compile(r"^(\d{2}/\d{2}/\d{4})\s+(\d{2}/\d{2}/\d{4})\s*(.*)$")
_TCB_TRAILING_AMOUNTS = re.compile(
    r"([\d,]+\.\d{2})\s+([\d,]+\.\d{2})\s+([\d,]+\.\d{2})\s*$"
)
_TCB_STOP_MARKER = "STATEMENT SUMMARY"


def parse_tcb(text: str) -> list[Row]:
    if _TCB_STOP_MARKER in text:
        text = text.split(_TCB_STOP_MARKER)[0]

    lines = [ln.rstrip() for ln in text.splitlines()]
    blocks: list[str] = []
    current: list[str] = []
    for line in lines:
        if _TCB_ROW_START.match(line):
            if current:
                blocks.append(" ".join(current))
            current = [line]
        elif current:
            stripped = line.strip()
            # Skip repeated page headers.
            if stripped.startswith("Tran Date") or not stripped:
                continue
            current.append(stripped)
    if current:
        blocks.append(" ".join(current))

    rows: list[Row] = []
    for block in blocks:
        m = _TCB_ROW_START.match(block)
        if not m:
            continue
        tran_date, _value_date, rest = m.groups()

        amt_match = _TCB_TRAILING_AMOUNTS.search(rest)
        if not amt_match:
            continue  # unparseable row; skipped rather than guessed

        debit, credit, balance = amt_match.groups()
        description = rest[: amt_match.start()].strip()
        description = re.sub(r"\s{2,}", " ", description)

        debit_val = debit.replace(",", "")
        credit_val = credit.replace(",", "")

        rows.append(Row(
            date=tran_date,
            description=description,
            inflow=credit_val if float(credit_val) > 0 else "",
            outflow=debit_val if float(debit_val) > 0 else "",
            balance=balance.replace(",", ""),
        ))
    return rows


# ---------------------------------------------------------------------------
def write_csv(rows: list[Row], out_path: str) -> None:
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["date", "description", "inflow", "outflow", "balance"])
        for r in rows:
            writer.writerow([r.date, r.description, r.inflow, r.outflow, r.balance])


def _signed_amount(row: Row) -> float | None:
    if row.inflow and not row.inflow.startswith("UNKNOWN"):
        return float(row.inflow)
    if row.outflow and not row.outflow.startswith("UNKNOWN"):
        return -float(row.outflow)
    return None


def validate_against_balance(rows: list[Row], newest_first: bool) -> list[int]:
    """Return indices where amount sign disagrees with the balance delta.

    `newest_first` must match the statement's actual row order: M-Pesa
    statements list the most recent transaction first, TCB lists oldest
    first. Getting this backwards makes every row look wrong.

    Note: this is only a precise check when every balance-affecting line
    (including fees/levies) is its own row, as TCB does. M-Pesa statements
    here don't itemize the transaction fee/government levy as a separate
    line, so a real fee still shows up as an unexplained gap even though
    the parse is correct — treat M-Pesa mismatches as informational, not
    as proof of a parsing error.
    """
    flagged = []
    for i in range(len(rows) - 1):
        a, b = rows[i], rows[i + 1]
        newer, older = (a, b) if newest_first else (b, a)
        try:
            newer_bal = float(newer.balance)
            older_bal = float(older.balance)
        except ValueError:
            continue
        delta = round(newer_bal - older_bal, 2)
        amount = _signed_amount(newer)
        if amount is None:
            flagged.append(i)
            continue
        if abs(delta - amount) > 0.01:
            flagged.append(i)
    return flagged


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", help="Path to the statement .pdf (or .txt for testing)")
    ap.add_argument("-o", "--output", required=True, help="Output CSV path")
    ap.add_argument("--format", choices=["mpesa", "tcb"], help="Skip auto-detection")
    args = ap.parse_args()

    text = extract_text(args.input)
    fmt = args.format or detect_format(text)
    rows = parse_mpesa(text) if fmt == "mpesa" else parse_tcb(text)

    if not rows:
        print("No transactions parsed — the layout may differ from what this script expects.", file=sys.stderr)
        sys.exit(1)

    write_csv(rows, args.output)
    flagged = validate_against_balance(rows, newest_first=(fmt == "mpesa"))

    print(f"Format: {fmt}")
    print(f"Parsed {len(rows)} transactions -> {args.output}")
    if flagged:
        print(f"WARNING: {len(flagged)} row(s) have a balance mismatch or unresolved direction — review before importing:")
        for i in flagged[:20]:
            r = rows[i]
            print(f"  line {i+1}: {r.date}  {r.description[:60]!r}  in={r.inflow!r} out={r.outflow!r} bal={r.balance}")
        if len(flagged) > 20:
            print(f"  ... and {len(flagged) - 20} more")
    else:
        print("All rows passed the balance sanity check.")


if __name__ == "__main__":
    main()
