---
name: "Deployment contract with the app repo"
description: "What this repo and alexandreroman/intothefray agree on to deploy"
type: project
---

# Deployment contract with the app repo

This repo and the app repo (`alexandreroman/intothefray`) follow one shared
contract:

- **Image**: `ghcr.io/alexandreroman/intothefray`, `linux/amd64`, tagged with
  the full 40-character commit SHA and `main`. The app CI publishes it on a
  push to `main` once every job passes. The package is public: the VPS pulls
  it without credentials.
- **Release flow**: on a push to `main`, once every check passes, the app's
  `ci.yml` publishes the image, then publishes the frontend to GitHub Pages
  (reusable `pages.yml`), then sends `repository_dispatch` `deploy-app` to
  this repo with `client_payload: {"sha": "<sha>"}`, using its
  `INFRA_DISPATCH_TOKEN` secret. The frontend may be live a few minutes
  before its backend; the user accepts that.
- **Infra -> app**: this repo sends nothing back to the app repo after a
  deploy. Its secrets are `TS_OAUTH_CLIENT_ID`, `TS_OAUTH_SECRET`,
  `VPS_HOST`, `VPS_USER`, `VPS_SSH_KEY` and `VPS_SSH_KNOWN_HOSTS`.
- **Pins**: the Caddy and Redis images match the app repo's `compose.yaml`.
- **App runtime**: the app listens on `9000`, reads `REDIS_URL`,
  `ALLOWED_ORIGINS` and `GOMEMLIMIT`, serves `/healthz`, and its distroless
  binary probes itself with `/intothefray healthcheck`.

**Why:** the two repos deploy one product; a one-sided change breaks the
release chain.

**How to apply:** never change any of the above without asking the user, and
change both repos together. Check the app repo's workflows and `compose.yaml`
before bumping a pin or touching the dispatches.
