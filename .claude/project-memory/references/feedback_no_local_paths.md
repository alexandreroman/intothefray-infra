---
name: "No local filesystem paths"
description: "Committed files never reference a path on a developer's machine"
type: feedback
---

# No local filesystem paths

Committed files reference other repositories by their GitHub URL and never by
a path on a developer's machine (`~/...`, `/Users/...`). Paths on the VPS
(`/opt/intothefray`) or the CI runner (`~/.ssh` in the workflow) are part of
the deployment and are fine.

**Why:** the repository is shared; a local path is meaningless, and leaks
personal layout, on any other machine.

**How to apply:** before committing, check docs and code for home-directory
or absolute local paths and replace them with a URL or a generic wording.
