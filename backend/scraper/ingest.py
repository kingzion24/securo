"""Bridges a scraped SourceResult into an agent's knowledge base, reusing
the exact same upload -> Celery ingest pipeline as a manual file upload in
the UI (app.agents.api.knowledge.upload_knowledge) — see
app.agents.tasks.ingest.ingest_doc for the parse/chunk/embed step this
dispatches.

Each source gets exactly ONE live document, named by its stable
source_key. A re-scrape deletes the previous doc for that source and
uploads fresh content, so the knowledge base always reflects the latest
digest per site instead of accumulating stale duplicates forever.
"""
from __future__ import annotations

import logging
import uuid

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.agents.models.knowledge import KnowledgeDoc
from app.agents.services import knowledge_service
from app.worker import celery_app
from scraper.sources import SourceResult

logger = logging.getLogger(__name__)


def _filename_for(source_key: str) -> str:
    return f"scraper__{source_key}.txt"


async def replace_source_doc(
    session: AsyncSession, *, agent_id: uuid.UUID, user_id: uuid.UUID, result: SourceResult
) -> bool:
    """Returns True if a fresh document was uploaded and queued for
    embedding, False if there was nothing to ingest (fetch failed / empty)."""
    if not result.ok or not result.text.strip():
        logger.info("scraper: skipping ingest for %s (ok=%s, error=%s)", result.source_key, result.ok, result.error)
        return False

    filename = _filename_for(result.source_key)
    existing = (
        await session.execute(
            select(KnowledgeDoc).where(KnowledgeDoc.agent_id == agent_id, KnowledgeDoc.source == filename)
        )
    ).scalar_one_or_none()
    if existing is not None:
        await knowledge_service.delete_doc(session, existing.id, user_id)

    doc = await knowledge_service.upload_doc(
        session,
        agent_id=agent_id,
        user_id=user_id,
        filename=filename,
        mime="text/plain",
        payload=result.text.encode("utf-8"),
    )
    # Store the human-readable title separately from the stable filename
    # used for dedup — the doc list in the UI should read "TanzaniaInvest
    # — news digest", not "scraper__tanzaniainvest.txt".
    doc.title = result.title
    await session.commit()

    celery_app.send_task("app.agents.tasks.ingest.ingest_doc", args=[str(doc.id), str(agent_id)])
    logger.info("scraper: queued ingest for %s (%d items, %d chars)", result.source_key, result.item_count, len(result.text))
    return True
