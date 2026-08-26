#!/usr/bin/env python3
"""Extract a transaction from a single pasted message (SMS/receipt) into the
same Row/CSV shape used by tz_statement_to_csv.py, so it can go through the
same Securo CSV import path.

Handles three message shapes seen from Tanzanian providers:
  - M-Pesa (Vodacom) confirmation SMS: "<ref> Confirmed. Tsh<amount>
    paid to/sent to <payee> ... Tsh<balance>."
  - Selcom Pay QR merchant receipt: line-per-field, no running balance.
  - TCB bank SMS alert (Swahili): "Zimetolewa Kutoka" (debited) /
    "Zimewekwa"/"Imewekwa" (credited).

Messages are separated by a blank line. A single M-Pesa SMS produces two
CSV rows when it quotes a fee: one for the principal transaction and one
for the fee/levy, mirroring how TCB's own statement itemizes fees — this
keeps fee tracking visible instead of silently folding it into the
principal amount.

Usage:
    python3 tz_message_to_csv.py messages.txt -o out.csv
    echo "<message>" | python3 tz_message_to_csv.py - -o out.csv
"""
from __future__ import annotations

import argparse
import re
import sys

from tz_statement_to_csv import Row, write_csv

_MONTHS = {}  # not needed; all dates here are numeric or "DD-Mon-YYYY"

_MON_ABBR = {
    "jan": "01", "feb": "02", "mar": "03", "apr": "04", "may": "05", "jun": "06",
    "jul": "07", "aug": "08", "sep": "09", "oct": "10", "nov": "11", "dec": "12",
}


def _normalize_date(day: str, month: str, year: str) -> str:
    day = day.zfill(2)
    if month.isdigit():
        month = month.zfill(2)
    else:
        month = _MON_ABBR[month[:3].lower()]
    if len(year) == 2:
        year = "20" + year
    return f"{day}/{month}/{year}"


def _normalize_amount(s: str) -> str:
    return s.replace(",", "").strip()


# ---------------------------------------------------------------------------
# M-Pesa confirmation SMS
# ---------------------------------------------------------------------------
_MPESA_SMS_RE = re.compile(
    r"^(?P<ref>[A-Z0-9]{8,12})\s+Confirmed\.\s+Tsh(?P<amount>[\d,]+\.\d{2})\s+"
    r"(?P<verb>paid to|sent to|received from)\s+(?P<payee>.+?)"
    r"(?:\s+for account\s+(?P<account>\d+))?"
    r"\s+on\s+(?P<day>\d{1,2})/(?P<month>\d{1,2})/(?P<year>\d{2,4})"
    r"\s+at\s+(?P<time>\d{1,2}:\d{2}\s*[ap]m)"
    r"(?P<fee_block>.*?)"
    r"(?:New M-Pesa balance is|Balance is)\s+Tsh(?P<balance>[\d,]+\.\d{2})",
    re.IGNORECASE | re.DOTALL,
)
_MPESA_FEE_SIMPLE_RE = re.compile(r"charged\s+Tsh(?P<fee>[\d,]+\.\d{2})", re.IGNORECASE)
_MPESA_FEE_BREAKDOWN_RE = re.compile(
    r"Total fee\s+Tsh(?P<total>[\d,]+\.\d{2})\s+"
    r"\(M-Pesa fee\s+Tsh(?P<mpesa_fee>[\d,]+\.\d{2})\s+\+\s+Government Levy\s+Tsh(?P<levy>[\d,]+\.\d{2})\)",
    re.IGNORECASE,
)


def parse_mpesa_sms(text: str) -> list[Row]:
    m = _MPESA_SMS_RE.search(text)
    if not m:
        return []
    amount = _normalize_amount(m["amount"])
    date = _normalize_date(m["day"], m["month"], m["year"])
    balance = _normalize_amount(m["balance"])
    payee = m["payee"].strip()
    if m["account"]:
        payee = f"{payee} ({m['account']})"
    verb = m["verb"].lower()

    rows = [Row(
        date=date,
        description=f"M-Pesa: {verb} {payee} [{m['ref']}]",
        inflow=amount if verb == "received from" else "",
        outflow="" if verb == "received from" else amount,
        balance=balance,
    )]

    fee_block = m["fee_block"] or ""
    breakdown = _MPESA_FEE_BREAKDOWN_RE.search(fee_block)
    simple = _MPESA_FEE_SIMPLE_RE.search(fee_block)
    if breakdown:
        total_fee = float(_normalize_amount(breakdown["total"]))
        if total_fee > 0:
            rows.append(Row(
                date=date,
                description=f"M-Pesa fee + government levy [{m['ref']}]",
                inflow="", outflow=_normalize_amount(breakdown["total"]),
                balance=balance,
            ))
    elif simple:
        fee = float(_normalize_amount(simple["fee"]))
        if fee > 0:
            rows.append(Row(
                date=date,
                description=f"M-Pesa fee [{m['ref']}]",
                inflow="", outflow=_normalize_amount(simple["fee"]),
                balance=balance,
            ))
    return rows


# ---------------------------------------------------------------------------
# Selcom Pay QR merchant receipt (no running balance)
# ---------------------------------------------------------------------------
_SELCOM_HEADER_RE = re.compile(r"^Selcom Pay\s*$", re.IGNORECASE | re.MULTILINE)
_SELCOM_AMOUNT_RE = re.compile(r"TZS\s+([\d,]+\.\d{2})")
_SELCOM_TRANSID_RE = re.compile(r"TransID\s+(\S+)")
_SELCOM_DATETIME_RE = re.compile(
    r"(\d{1,2})/(\d{1,2})/(\d{4})\s+(\d{1,2}:\d{2}:\d{2}\s*[AP]M)", re.IGNORECASE
)


def parse_selcom_receipt(text: str) -> list[Row]:
    if not _SELCOM_HEADER_RE.search(text):
        return []
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    merchant = lines[1] if len(lines) > 1 else "Selcom merchant"
    amount_m = _SELCOM_AMOUNT_RE.search(text)
    transid_m = _SELCOM_TRANSID_RE.search(text)
    dt_m = _SELCOM_DATETIME_RE.search(text)
    if not amount_m:
        return []
    amount = _normalize_amount(amount_m.group(1))
    date = "01/01/1970"
    if dt_m:
        day, month, year, _time = dt_m.groups()
        date = _normalize_date(day, month, year)
    ref = f" [{transid_m.group(1)}]" if transid_m else ""
    return [Row(
        date=date,
        description=f"Selcom Pay: {merchant}{ref}",
        inflow="", outflow=amount,
        balance="",  # receipts don't carry a running balance
    )]


# ---------------------------------------------------------------------------
# TCB bank SMS alert (Swahili)
# ---------------------------------------------------------------------------
_TCB_SMS_AMOUNT_RE = re.compile(r"TZS\s+([\d,]+(?:\.\d{2})?)")
_TCB_SMS_ACCOUNT_RE = re.compile(r"A(?:kaunti)?/?C\.?\s*(?:No\.?)?:?\s*([\dX*]{4,})")
# "Tar:" and "Tarehe:" are the same word (short and full form); both appear
# across the different TCB alert templates.
_TCB_SMS_DATE_RE = re.compile(r"Tar(?:ehe)?:\s*(\d{1,2})-([A-Za-z]{3})-(\d{4})")
_TCB_DEBIT_KEYWORDS = ("zimetolewa", "umetoa", "zimetumwa")
_TCB_CREDIT_KEYWORDS = ("zimewekwa", "imewekwa", "umepokea", "yamepokelewa", "imepokea")


def parse_tcb_sms(text: str) -> list[Row]:
    lower = text.lower()
    is_debit = any(k in lower for k in _TCB_DEBIT_KEYWORDS)
    is_credit = any(k in lower for k in _TCB_CREDIT_KEYWORDS)
    if not is_debit and not is_credit:
        return []
    amount_m = _TCB_SMS_AMOUNT_RE.search(text)
    account_m = _TCB_SMS_ACCOUNT_RE.search(text)
    date_m = _TCB_SMS_DATE_RE.search(text)
    if not amount_m:
        return []
    amount = _normalize_amount(amount_m.group(1))
    date = ""  # flagged as missing below rather than guessed
    if date_m:
        day, mon, year = date_m.groups()
        date = _normalize_date(day, mon, year)
    account = f" ({account_m.group(1)})" if account_m else ""

    # Description: two known templates.
    # 1. "...Tar(ehe): <date>, <description>, Piga ... ikiwa huutambui..."
    #    (debit/credit alert). Anchored on "Tar(ehe):" rather than a bare
    #    comma, since the amount itself (e.g. "100,000") contains commas
    #    that would otherwise be matched first.
    # 2. "...Maelezo: <description>" (used by both the "Imepokea Ingizo"
    #    credit alert and the "Kumbukumbu namba" TIPS transfer detail,
    #    neither of which has the "Piga" boilerplate).
    desc_m = re.search(r"Tar(?:ehe)?:\s*\d{1,2}-[A-Za-z]{3}-\d{4},\s*(.+?),\s*Piga", text, re.IGNORECASE | re.DOTALL)
    if desc_m:
        desc = desc_m.group(1).strip()
    else:
        maelezo_m = re.search(r"Maelezo:\s*(.*)$", text, re.IGNORECASE | re.DOTALL)
        desc = maelezo_m.group(1).strip() if maelezo_m and maelezo_m.group(1).strip() else "TCB alert"

    return [Row(
        date=date or "UNKNOWN",
        description=f"TCB{account}: {desc}",
        inflow="" if is_debit else amount,
        outflow=amount if is_debit else "",
        balance="",  # alert SMS doesn't include a running balance
    )]


# ---------------------------------------------------------------------------
# TCB "Kumbukumbu namba" TIPS transfer detail — a second notification some
# outgoing transfers get alongside (not instead of) the plain "Zimetolewa"
# debit alert above, carrying the destination account and TIPS reference
# but, notably, no date of its own.
# ---------------------------------------------------------------------------
_TCB_KUMBUKUMBU_RE = re.compile(
    r"Kumbukumbu namba:\s*(?P<ref>\S+),\s*TZS\s+(?P<amount>[\d,]+(?:\.\d{2})?)\s*/=\s*"
    r"kutoka\s+Akaunti:\s*(?P<from_acct>\S+)\s+zimetumwa\s+kwenda,\s*"
    r"Akaunti:\s*(?P<to_acct>\S+)\s*-\s*(?P<to_label>[^,]+),\s*"
    r"kwa njia ya:\s*(?P<method>\S+)\s*\((?P<method_ref>[^)]+)\)"
    r"(?:\s*Maelezo:\s*(?P<desc>.*))?$",
    re.IGNORECASE | re.DOTALL,
)


def parse_tcb_kumbukumbu(text: str) -> list[Row]:
    m = _TCB_KUMBUKUMBU_RE.search(text)
    if not m:
        return []
    amount = _normalize_amount(m["amount"])
    desc = (m["desc"] or "").strip()
    label = f"TCB: sent to {m['to_label'].strip()} via {m['method']} {m['method_ref']} [{m['ref']}]"
    if desc:
        label += f" — {desc}"
    return [Row(
        date="UNKNOWN",  # this message template carries no date field
        description=label,
        inflow="", outflow=amount,
        balance="",
    )]


# ---------------------------------------------------------------------------
# Selcom Swahili SMS (transfer confirmation and card payment confirmation).
#
# Transfers arrive as TWO messages sharing the same leading ref, sent
# moments apart: an immediate "Imethibitishwa" notice with no fee/balance,
# followed by an "Imepokelewa" settlement notice with the fee breakdown and
# running balance. Only the settlement version carries usable data, so the
# bare one is dropped whenever a fuller one with the same ref is present in
# the same batch. The same ref-based dedup also catches accidental
# copy-paste duplicates of an identical message.
# ---------------------------------------------------------------------------
_SELCOM_SW_REF_RE = re.compile(r"^([0-9]{3,4}P[0-9A-Z]{3,8})\s+(?:Imethibitishwa|Imepokelewa)\b", re.IGNORECASE)

_SELCOM_TRANSFER_RE = re.compile(
    r"^(?P<ref>[0-9]{3,4}P[0-9A-Z]{3,8})\s+(?:Imethibitishwa|Imepokelewa)\.\s+"
    r"Umetuma\s+TZS\s+(?P<amount>[\d,]+\.\d{2})\s+kwa\s+(?P<payee>.+?)"
    r"(?:\s+-\s+(?P<service>[^(]+?))?\s*\((?P<phone>\d+)\)\s+tarehe\s+"
    r"(?P<date>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})\s+(?P<time>\d{2}:\d{2}:\d{2})\.\s*"
    r"(?P<tail>.*)$",
    re.IGNORECASE | re.DOTALL,
)
_SELCOM_TRANSFER_SETTLED_RE = re.compile(
    r"Ada Jumla\s+TZS\s+(?P<fee>[\d,]+\.\d{2})\s*"
    r"\(Ada\s+(?P<ada>[\d,.]+),\s*VAT\s+(?P<vat>[\d,.]+),\s*Ex Duty\s+(?P<exduty>[\d,.]+)\)\.\s*"
    r"Salio jipya ni\s+TZS\s+(?P<balance>[\d,]+\.\d{2})",
    re.IGNORECASE,
)

_SELCOM_CARD_RE = re.compile(
    r"^(?P<ref>[0-9]{3,4}P[0-9A-Z]{3,8})\s+Imethibitishwa\.\s+"
    r"Umelipa\s+TZS\s+(?P<amount>[\d,]+\.\d{2})\s+kwa\s+(?P<merchant>.+?)\s+"
    r"kwa kutumia kadi yako inayoishia\s+(?P<last4>\d+)\s+tarehe\s+"
    r"(?P<date>\d{4})-(?P<month>\d{2})-(?P<day>\d{2})\s+(?P<time>\d{2}:\d{2}:\d{2})\.\s*"
    r"Salio jipya ni\s+TZS\s+(?P<balance>[\d,]+\.\d{2})",
    re.IGNORECASE | re.DOTALL,
)


def parse_selcom_sw(text: str) -> tuple[str, bool, list[Row]] | None:
    """Return (ref, has_settlement_data, rows) for a Selcom Swahili SMS, or None."""
    m = _SELCOM_CARD_RE.search(text)
    if m:
        date = f"{m['day']}/{m['month']}/{m['date']}"
        amount = _normalize_amount(m["amount"])
        row = Row(
            date=date,
            description=f"Selcom card payment: {m['merchant'].strip()} (card *{m['last4']}) [{m['ref']}]",
            inflow="", outflow=amount,
            balance=_normalize_amount(m["balance"]),
        )
        return (m["ref"], True, [row])

    m = _SELCOM_TRANSFER_RE.search(text)
    if m:
        date = f"{m['day']}/{m['month']}/{m['date']}"
        amount = _normalize_amount(m["amount"])
        payee = m["payee"].strip()
        if m["service"]:
            payee = f"{payee} - {m['service'].strip()}"
        settled = _SELCOM_TRANSFER_SETTLED_RE.search(m["tail"] or "")
        if not settled:
            # Bare pre-settlement notice: no fee/balance yet. Still returned
            # (has_data=False) so it's only used if no settled version of
            # the same ref shows up elsewhere in the batch.
            row = Row(
                date=date,
                description=f"Selcom transfer: {payee} [{m['ref']}]",
                inflow="", outflow=amount,
                balance="",
            )
            return (m["ref"], False, [row])

        balance = _normalize_amount(settled["balance"])
        rows = [Row(
            date=date,
            description=f"Selcom transfer: {payee} [{m['ref']}]",
            inflow="", outflow=amount,
            balance=balance,
        )]
        fee = float(_normalize_amount(settled["fee"]))
        if fee > 0:
            rows.append(Row(
                date=date,
                description=f"Selcom fee (Ada/VAT/Ex Duty) [{m['ref']}]",
                inflow="", outflow=_normalize_amount(settled["fee"]),
                balance=balance,
            ))
        return (m["ref"], True, rows)

    return None


# ---------------------------------------------------------------------------
_PARSERS = [parse_mpesa_sms, parse_selcom_receipt, parse_tcb_kumbukumbu, parse_tcb_sms]

# Markers that indicate a new message is starting, used to split apart
# multiple SMS pasted back-to-back with no blank line between them. No
# leading \b: real-world pastes often glue one message's trailing support
# number straight into the next message's ref with no separator at all
# (e.g. "...0800 784 8880821P44QH Imepokelewa..."), and \b can't fire
# between two digits. Dropping it still finds the right start position —
# the digit-run-then-P-then-status-word shape is distinctive enough on
# its own — it just also allows matching mid-digit-run.
_MSG_START_RE = re.compile(
    r"(?=[0-9]{3,4}P[0-9A-Z]{3,8}\s+(?:Imethibitishwa|Imepokelewa)\b)"
    r"|(?=[A-Z0-9]{8,12}\s+Confirmed\b)"
)


def split_concatenated_messages(block: str) -> list[str]:
    raw_positions = [m.start() for m in _MSG_START_RE.finditer(block)]
    # The variable-length {3,4} digit run means a single true ref can also
    # satisfy the pattern starting one character late (e.g. both "0821P44QH"
    # and the substring "821P44QH" match independently), producing spurious
    # candidates 1-2 characters after the real one. Collapse any cluster of
    # candidates closer together than a real message ever is down to its
    # leftmost (= most complete) position.
    positions: list[int] = []
    for pos in raw_positions:
        if not positions or pos - positions[-1] > 20:
            positions.append(pos)
    if len(positions) <= 1:
        return [block]
    segments = []
    for i, pos in enumerate(positions):
        end = positions[i + 1] if i + 1 < len(positions) else len(block)
        segment = block[pos:end].strip()
        if segment:
            segments.append(segment)
    return segments


def parse_message(text: str) -> list[Row]:
    for parser in _PARSERS:
        rows = parser(text)
        if rows:
            return rows
    return []


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input", help="Path to a text file with one or more messages separated by blank lines, or '-' for stdin")
    ap.add_argument("-o", "--output", required=True, help="Output CSV path")
    args = ap.parse_args()

    raw = sys.stdin.read() if args.input == "-" else open(args.input, encoding="utf-8").read()
    coarse_blocks = [b.strip() for b in re.split(r"\n\s*\n", raw) if b.strip()]
    blocks: list[str] = []
    for b in coarse_blocks:
        blocks.extend(split_concatenated_messages(b))

    # Selcom SW messages are deduped by ref before being added to all_rows;
    # everything else is added immediately.
    selcom_by_ref: dict[str, tuple[bool, list[Row]]] = {}
    exact_seen: set[str] = set()
    all_rows: list[Row] = []
    unparsed = 0
    duplicates = 0

    for block in blocks:
        if block in exact_seen:
            duplicates += 1
            continue
        exact_seen.add(block)

        selcom = parse_selcom_sw(block)
        if selcom:
            ref, has_data, rows = selcom
            existing = selcom_by_ref.get(ref)
            if existing is None or (has_data and not existing[0]):
                selcom_by_ref[ref] = (has_data, rows)
            continue

        rows = parse_message(block)
        if rows:
            all_rows.extend(rows)
        else:
            unparsed += 1
            print(f"Could not parse message: {block[:80]!r}...", file=sys.stderr)

    for _has_data, rows in selcom_by_ref.values():
        all_rows.extend(rows)

    if not all_rows:
        print("No messages parsed.", file=sys.stderr)
        sys.exit(1)

    write_csv(all_rows, args.output)
    print(f"Parsed {len(all_rows)} row(s) from {len(blocks)} message(s) -> {args.output}")
    if duplicates:
        print(f"Skipped {duplicates} exact-duplicate message(s).")
    if unparsed:
        print(f"{unparsed} message(s) did not match any known format.")


if __name__ == "__main__":
    main()
