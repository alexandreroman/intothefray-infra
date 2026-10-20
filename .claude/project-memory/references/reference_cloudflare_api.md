---
name: "Cloudflare API access"
description: "The local .env holds the Cloudflare API token for intothefray.xyz"
type: reference
---

# Cloudflare API access

The repository's local `.env` (gitignored, never committed) holds
`CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ZONE_ID` for the `intothefray.xyz`
zone. The token is scoped to that zone only, with Zone Read, DNS Edit and
Zone Settings Edit.

**Why:** it lets a session read and change the zone's DNS records and
settings (SSL mode, WebSockets) without the dashboard.

**How to access:** load the file without printing it
(`set -a; . ./.env; set +a`), then call
`https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/...` with
`Authorization: Bearer $CLOUDFLARE_API_TOKEN`. It cannot create Origin CA
certificates; those are made in the dashboard.
