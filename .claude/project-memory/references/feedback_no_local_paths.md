---
name: "No local filesystem paths"
description: "Committed files never reference a personal local path"
type: feedback
---

# No local filesystem paths

Committed files reference other repositories by their GitHub URL and never by
a personal path on a developer's machine (a projects folder, `/Users/...`).
Standard locations every machine has, such as `~/.ssh/config` and keys in
`~/.ssh/`, are fine. Paths on the VPS (`/opt/intothefray`) or the CI runner
are part of the deployment and are fine too.

**Why:** the repository is shared; a personal path is meaningless, and leaks
personal layout, on any other machine.

**How to apply:** before committing, check docs and code for personal or
absolute local paths and replace them with a URL or a generic wording.
