"""TanzaniaInvest — independent investment portal. The /news listing page
is server-rendered and its content is clearly scrapable in principle, but
as of 2026-08-27 the site returns 403 Forbidden to plain httpx requests —
including with a standard browser User-Agent — which points to a WAF/bot
filter (Cloudflare-style) rather than a simple UA check. We don't attempt
to defeat that (no fingerprint spoofing, no JS-challenge solving) — this
module is left in place and will start working again on its own if the
site's filter configuration changes, or immediately if you point
SCRAPER_HTTP_TIMEOUT/headers at a real browser-backed fetcher later.
"""
from __future__ import annotations

import logging

import httpx

from scraper.extract import extract_article_text, find_headline_links
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)

BASE_URL = "https://www.tanzaniainvest.com"
NEWS_URL = f"{BASE_URL}/news"
ARTICLES_TO_FETCH = 8


async def scrape(client: httpx.AsyncClient) -> SourceResult:
    try:
        resp = await client.get(NEWS_URL)
        resp.raise_for_status()
    except Exception as exc:  # noqa: BLE001
        logger.warning("tanzaniainvest: failed to fetch %s: %s", NEWS_URL, exc)
        return SourceResult("tanzaniainvest", "TanzaniaInvest", "", ok=False, error=str(exc))

    links = find_headline_links(resp.text, NEWS_URL, limit=ARTICLES_TO_FETCH)
    if not links:
        return SourceResult("tanzaniainvest", "TanzaniaInvest", "", ok=False, error="no headlines found on listing page")

    sections = [f"# TanzaniaInvest — market & economy news\nSource: {NEWS_URL}\n"]
    for link in links:
        body = ""
        try:
            art = await client.get(link.url)
            art.raise_for_status()
            body = extract_article_text(art.text)
        except Exception as exc:  # noqa: BLE001
            logger.warning("tanzaniainvest: failed to fetch article %s: %s", link.url, exc)
        sections.append(f"## {link.text}\n{link.url}\n\n{body or '(full text unavailable — headline only)'}")

    return SourceResult(
        "tanzaniainvest", "TanzaniaInvest — news digest", "\n\n".join(sections), item_count=len(links)
    )
