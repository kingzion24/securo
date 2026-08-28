"""Public capability/feature-flag endpoint.

Tells the frontend which optional features are enabled so it can hide
nav items, routes, etc. Lightweight — no auth required.
"""
from fastapi import APIRouter

from app.core.config import get_settings
from app.core.feature_flags import feature_flag

router = APIRouter(prefix="/api", tags=["info"])


@router.get("/info")
async def get_app_info():
    return {
        "features": {
            "agents": feature_flag("AGENTS_ENABLED"),
            "tesouro_direto": feature_flag("TESOURO_DIRETO_ENABLED"),
        },
    }


@router.get("/.well-known/assetlinks.json")
async def android_asset_links():
    """Digital Asset Links statement proving the Android app owns this domain.

    Must be reachable at `https://<domain>/.well-known/assetlinks.json` (the
    reverse proxy maps that fixed path here, since it can't live under /api on
    the wire) — Android's Credential Manager fetches it before trusting the
    app for passkeys on this domain. Empty when no fingerprint is configured,
    so a deployment that hasn't set up the Android app yet doesn't advertise a
    bogus association.
    """
    settings = get_settings()
    fingerprints = [
        f.strip() for f in settings.webauthn_android_cert_fingerprints.split(",") if f.strip()
    ]
    if not fingerprints:
        return []
    return [
        {
            "relation": [
                "delegate_permission/common.handle_all_urls",
                "delegate_permission/common.get_login_creds",
            ],
            "target": {
                "namespace": "android_app",
                "package_name": settings.webauthn_android_package_name,
                "sha256_cert_fingerprints": fingerprints,
            },
        }
    ]
