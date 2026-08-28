"""Dar es Salaam Stock Exchange — official site.

Known issue as of 2026-08-27: dse.co.tz serves an EXPIRED TLS certificate
(confirmed independently, not a bug in this scraper). We deliberately do
NOT disable certificate verification to work around that — this module
will simply report a failed fetch until DSE renews their cert, at which
point it starts working again with no code changes needed.

Generic homepage scan (headlines + tables) rather than named subpaths,
since the cert issue blocked confirming DSE's actual news/report URLs.
"""
from __future__ import annotations

import logging

import httpx

from scraper.extract import extract_tables_as_text, find_headline_links
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)

BASE_URL = "https://www.dse.co.tz"


async def scrape(client: httpx.AsyncClient) -> SourceResult:
    try:
        resp = await client.get(BASE_URL)
        resp.raise_for_status()
    except Exception as exc:  # noqa: BLE001
        logger.warning("dse: failed to fetch %s: %s", BASE_URL, exc)
        return SourceResult("dse", "Dar es Salaam Stock Exchange", "", ok=False, error=str(exc))

    links = find_headline_links(resp.text, BASE_URL, min_text_len=15, limit=15)
    tables = extract_tables_as_text(resp.text)
    if not links and not tables:
        return SourceResult("dse", "Dar es Salaam Stock Exchange", "", ok=False, error="no headlines or tables found")

    parts = [f"# Dar es Salaam Stock Exchange (official)\nSource: {BASE_URL}\n"]
    if tables:
        parts.append(f"## Market data / tables\n{tables}")
    if links:
        parts.append("## Headlines / announcements\n" + "\n".join(f"- {l.text} — {l.url}" for l in links))

    return SourceResult("dse", "DSE — official site digest", "\n\n".join(parts), item_count=len(links))
