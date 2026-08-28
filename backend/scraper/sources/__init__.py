from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class SourceResult:
    source_key: str  # stable id — used as the knowledge-doc filename, so it's how re-scrapes replace the old digest
    title: str  # human-readable, shown in the Knowledge tab
    text: str  # digest body fed to the chunker; empty means "nothing to ingest"
    item_count: int = 0
    ok: bool = True
    error: str | None = None
    # Structured (title, url) pairs, for sources whose page is a genuine
    # headline/announcement list (uttamis news, mystocks). Used to detect
    # "new since last cycle" items (see scraper/findings.py) — left empty
    # for sources that only produce free-text article bodies or tables,
    # since those have no stable per-item identity to diff against.
    items: list[tuple[str, str]] = field(default_factory=list)
