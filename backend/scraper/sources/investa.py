"""Investa — CMSA-regulated investment platform.

Known limitation as of 2026-08-27: investa.co.tz is a client-rendered JS
app — the server response is mostly empty markup with data filled in by
JavaScript after load (confirmed by inspection before writing this). A
plain HTTP fetch (no browser engine) can only see the static shell, so
this will usually yield little or nothing. Left in place (rather than
dropped) since it fails soft and will start finding content on its own if
the site ever ships server-rendered pages.
"""
from __future__ import annotations

import logging

import httpx

from scraper.extract import find_headline_links
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)

BASE_URL = "https://investa.co.tz"


async def scrape(client: httpx.AsyncClient) -> SourceResult:
    try:
        resp = await client.get(BASE_URL)
        resp.raise_for_status()
    except Exception as exc:  # noqa: BLE001
        logger.warning("investa: failed to fetch %s: %s", BASE_URL, exc)
        return SourceResult("investa", "Investa", "", ok=False, error=str(exc))

    links = find_headline_links(resp.text, BASE_URL, min_text_len=15, limit=15)
    if not links:
        return SourceResult(
            "investa", "Investa", "", ok=False,
            error="no static content found (site appears to be a client-rendered JS app)",
        )

    text = f"# Investa\nSource: {BASE_URL}\n\n" + "\n".join(f"- {l.text} — {l.url}" for l in links)
    return SourceResult("investa", "Investa — site digest", text, item_count=len(links))
