---
name: "Makefile scope"
description: "The Makefile validates the stack only; it never runs it locally"
type: project
---

# Makefile scope

The `Makefile` holds validation targets only (`make check`: actionlint,
shellcheck, `docker compose config`, `caddy validate`) plus `help`. It has no
`dev`, `app-up` or `app-down` target.

**Why:** this repo only deploys the backend; the app runs locally from the app
repo (`alexandreroman/intothefray`), and the production stack needs the
Cloudflare Origin CA certificate, which never leaves the VPS.

**How to apply:** add new checks to `make check` rather than a local stack;
run `make check` to validate any change to the stack or the workflow.
