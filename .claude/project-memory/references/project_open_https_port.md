---
name: "Open HTTPS port"
description: "No Cloudflare IP allowlist on the VPS; AOP guards port 443"
type: project
---

# Open HTTPS port

The VPS setup has no firewall rule (ufw or `DOCKER-USER`) limiting port 443
to Cloudflare's IP ranges; ufw only restricts SSH to the tailnet. Caddy's
Authenticated Origin Pulls check keeps traffic going through Cloudflare (see
[[project_origin_pulls]]).

**Why:** the user's decision, made on 2026-10-20, to keep the VPS setup
simple; confirmed on 2026-11-03 by choosing mTLS over an IP allowlist.

**How to apply:** do not add a Cloudflare IP filter to the VPS setup or the
README unless the user asks for it.
