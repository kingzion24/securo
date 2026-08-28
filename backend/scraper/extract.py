"""Generic, site-agnostic HTML extraction helpers.

Deliberately NOT per-site CSS selectors — those break the moment a site
redesigns. Instead: heuristics that hold up across ordinary server-rendered
content sites (news portals, data tables), and fail soft (return less, never
raise) when a page doesn't match the shape they expect.
"""
from __future__ import annotations

from dataclasses import dataclass
from urllib.parse import urljoin, urlparse

from bs4 import BeautifulSoup

_NOISE_TAGS = ("script", "style", "nav", "header", "footer", "noscript", "svg", "form")


def soup_of(html: str) -> BeautifulSoup:
    return BeautifulSoup(html, "html.parser")


@dataclass
class Link:
    text: str
    url: str


def find_headline_links(html: str, base_url: str, *, min_text_len: int = 25, limit: int = 20) -> list[Link]:
    """Heuristic headline/article-link finder: same-domain <a> tags whose
    visible text is long enough to plausibly be a headline (not nav/footer
    boilerplate like "Home" or "Contact"). Dedupes by URL, preserves
    document order.
    """
    soup = soup_of(html)
    for tag in soup(_NOISE_TAGS):
        tag.decompose()
    domain = urlparse(base_url).netloc
    seen: set[str] = set()
    out: list[Link] = []
    for a in soup.find_all("a", href=True):
        text = " ".join(a.get_text(" ", strip=True).split())
        if len(text) < min_text_len:
            continue
        href = urljoin(base_url, a["href"])
        if urlparse(href).netloc != domain:
            continue
        href = href.split("#")[0]
        if href in seen:
            continue
        seen.add(href)
        out.append(Link(text=text, url=href))
        if len(out) >= limit:
            break
    return out


def extract_article_text(html: str, *, max_chars: int = 4000) -> str:
    """Best-effort full-text extraction for a single article page: prefer
    <article>/<main>, else the <body>'s <p> tags. Strips nav/script noise.
    Truncated (not summarized) at max_chars — good enough for a knowledge
    chunk without pulling in an entire heavy page.
    """
    soup = soup_of(html)
    for tag in soup(_NOISE_TAGS):
        tag.decompose()
    container = soup.find("article") or soup.find("main") or soup.body or soup
    paragraphs = [p.get_text(" ", strip=True) for p in container.find_all("p")]
    text = "\n\n".join(p for p in paragraphs if len(p) > 40)
    if not text:
        text = container.get_text("\n", strip=True)
    return text[:max_chars]


def extract_tables_as_text(html: str, *, limit: int = 5) -> str:
    """Convert the first few <table> elements into pipe-delimited text
    lines. Works regardless of column semantics — the LLM reads the header
    row to figure out what each column means."""
    soup = soup_of(html)
    blocks: list[str] = []
    for table in soup.find_all("table")[:limit]:
        rows = []
        for tr in table.find_all("tr"):
            cells = [" ".join(c.get_text(" ", strip=True).split()) for c in tr.find_all(["th", "td"])]
            cells = [c for c in cells if c]
            if cells:
                rows.append(" | ".join(cells))
        if rows:
            blocks.append("\n".join(rows))
    return "\n\n".join(blocks)
