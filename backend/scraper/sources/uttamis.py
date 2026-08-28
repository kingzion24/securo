"""UTT AMIS — Unit Trust of Tanzania. Two pages, both verified reachable
and server-rendered before writing this:
  - /fund-performance   NAV / sale / repurchase prices for all six funds
                         (Umoja, Wekeza Maisha, Watoto, Jikimu, Liquid, Bond)
  - /news_and_events    dividend and investment-channel announcements

This is the highest-value source for the Bond Fund holding tracked in
Securo's own Assets feature — the user explicitly asked for this coverage.

Known limitation as of 2026-08-27: the NAV table on /fund-performance is
an empty shell in the server HTML — the actual per-fund rows are loaded
client-side via a DataTables AJAX POST to a `navs` endpoint that redirects
unauthenticated requests to /admin/login (confirmed by inspection). That
endpoint is not public; we don't attempt to authenticate to it. Only the
static news/announcements page is genuinely scrapable without a login.
"""
from __future__ import annotations

import logging

import httpx

from scraper.extract import extract_tables_as_text, find_headline_links
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)

BASE_URL = "https://www.uttamis.co.tz"
PERFORMANCE_URL = f"{BASE_URL}/fund-performance"
NEWS_URL = f"{BASE_URL}/news_and_events"


async def scrape(client: httpx.AsyncClient) -> SourceResult:
    parts: list[str] = []
    item_count = 0
    errors: list[str] = []

    try:
        resp = await client.get(PERFORMANCE_URL)
        resp.raise_for_status()
        table_text = extract_tables_as_text(resp.text)
        # A header-only table (one line, no pipe-delimited data row below
        # it) means the AJAX-loaded rows didn't come through — see module
        # docstring. Including just the header would make the digest look
        # like it has NAV data when it doesn't; better to say so plainly.
        if table_text and "\n" in table_text:
            parts.append(f"# UTT AMIS — fund performance (NAV, sale price, repurchase price)\nSource: {PERFORMANCE_URL}\n\n{table_text}")
            item_count += 1
        else:
            parts.append(
                f"# UTT AMIS — fund performance\nSource: {PERFORMANCE_URL}\n\n"
                "Live NAV/sale/repurchase price table is not available here — it "
                "loads via an authenticated endpoint on UTT AMIS's site that this "
                "scraper cannot reach. For current fund prices, check the site "
                "directly or Securo's own Assets page (which tracks purchase "
                "history and lets you enter the latest NAV manually)."
            )
            errors.append("fund-performance: NAV table requires login, not captured")
    except Exception as exc:  # noqa: BLE001
        logger.warning("uttamis: failed to fetch %s: %s", PERFORMANCE_URL, exc)
        errors.append(f"fund-performance: {exc}")

    try:
        resp = await client.get(NEWS_URL)
        resp.raise_for_status()
        links = find_headline_links(resp.text, NEWS_URL, min_text_len=15, limit=15)
        if links:
            lines = "\n".join(f"- {l.text} — {l.url}" for l in links)
            parts.append(f"# UTT AMIS — news & announcements\nSource: {NEWS_URL}\n\n{lines}")
            item_count += len(links)
        else:
            errors.append("news_and_events: no items found")
    except Exception as exc:  # noqa: BLE001
        logger.warning("uttamis: failed to fetch %s: %s", NEWS_URL, exc)
        errors.append(f"news_and_events: {exc}")

    if not parts:
        return SourceResult("uttamis", "UTT AMIS", "", ok=False, error="; ".join(errors))

    return SourceResult(
        "uttamis",
        "UTT AMIS — fund performance & news",
        "\n\n".join(parts),
        item_count=item_count,
        ok=True,
        error="; ".join(errors) or None,
    )
