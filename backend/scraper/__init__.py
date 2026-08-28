"""Standalone container: periodically scrapes Tanzanian market-data/news
sites and feeds the result into an agent's knowledge base (see
app.agents.services.knowledge_service) so a chat agent — e.g. "Scrooge" —
can search it via the existing search_knowledge_base MCP tool.

Runs as its own service (see docker-compose.prod.yml: `market-scraper`,
profile `agents`) so a slow/misbehaving site can never affect the API or
chat containers. Shares the backend image (same deps, same DB/session
plumbing, same Celery app to dispatch the embedding task) but has its own
entrypoint (scraper.main) and does nothing else.
"""
