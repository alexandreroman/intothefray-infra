---
name: "Authenticated Origin Pulls"
description: "Caddy requires Cloudflare's global AOP client certificate"
type: project
---

# Authenticated Origin Pulls

Caddy requires and verifies the client certificate Cloudflare presents with
Authenticated Origin Pulls (zone setting `tls_client_auth`). It uses the
global option: Cloudflare's shared CA, committed as `origin-pull-ca.pem`
(expires 2029-11-01), not a zone-level certificate of our own.

**Why:** the user's decision, made on 2026-11-03 before making the
repository public, so that every request to the API goes through Cloudflare.
Global AOP is the user's choice for its simplicity. A Cloudflare IP allowlist
is not used (see [[project_open_https_port]]).

**How to apply:** `tls_client_auth` is on in Cloudflare before any deploy
of a Caddyfile that requires the certificate, and stays on while Caddy
requires it. Changing Cloudflare settings needs the user's go-ahead (see
[[reference_cloudflare_api]]). Before 2029-11-01, or when Cloudflare
publishes a new CA, update `origin-pull-ca.pem`. Moving to zone-level AOP
is the user's call.
