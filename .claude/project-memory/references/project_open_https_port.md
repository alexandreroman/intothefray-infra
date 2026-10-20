---
name: "Open HTTPS port"
description: "No Cloudflare IP allowlist on the VPS"
type: project
---

# Open HTTPS port

The VPS setup has no firewall rule (ufw or `DOCKER-USER`) limiting port 443
to Cloudflare's IP ranges; ufw only restricts SSH to the tailnet.

**Why:** the user's decision, made on 2026-10-20, to keep the VPS setup
simple.

**How to apply:** do not add a Cloudflare IP filter to the VPS setup or the
README unless the user asks for it.
