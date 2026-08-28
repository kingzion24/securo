"""MyStocks Africa — Tanzania. Reachable and server-rendered, but real
trading data/prices sit behind a login wall (confirmed by inspection
before writing this) — the public page is mostly a landing/educational
page listing which counters are covered. Scraped anyway for whatever
public context it offers (featured listings, market-driver explainers);
expect a thin digest compared to tanzaniainvest/uttamis.
"""
from __future__ import annotations

import logging

import httpx

from scraper.extract import extract_article_text, find_headline_links
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)

BASE_URL = "https://mystocks.africa/countries/tanzania"


async def scrape(client: httpx.AsyncClient) -> SourceResult:
    try:
        resp = await client.get(BASE_URL)
        resp.raise_for_status()
    except Exception as exc:  # noqa: BLE001
        logger.warning("mystocks: failed to fetch %s: %s", BASE_URL, exc)
        return SourceResult("mystocks", "MyStocks Africa", "", ok=False, error=str(exc))

    links = find_headline_links(resp.text, BASE_URL, min_text_len=15, limit=15)
    body = extract_article_text(resp.text, max_chars=2000)
    if not links and not body:
        return SourceResult("mystocks", "MyStocks Africa", "", ok=False, error="no content found")

    parts = [f"# MyStocks Africa — Tanzania\nSource: {BASE_URL}\n"]
    if body:
        parts.append(body)
    if links:
        parts.append("## Links\n" + "\n".join(f"- {l.text} — {l.url}" for l in links))

    return SourceResult("mystocks", "MyStocks Africa — Tanzania digest", "\n\n".join(parts), item_count=len(links))
