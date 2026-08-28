from __future__ import annotations

from dataclasses import dataclass


@dataclass
class SourceResult:
    source_key: str  # stable id — used as the knowledge-doc filename, so it's how re-scrapes replace the old digest
    title: str  # human-readable, shown in the Knowledge tab
    text: str  # digest body fed to the chunker; empty means "nothing to ingest"
    item_count: int = 0
    ok: bool = True
    error: str | None = None
