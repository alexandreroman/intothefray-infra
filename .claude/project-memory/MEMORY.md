# Project Memory

> When a new decision **contradicts** an existing
> memory note, do NOT silently override it.
> Instead: surface the conflict, quote the
> existing memory, explain how the new decision
> differs, and ask for explicit confirmation
> before updating. **Do NOT take any action** —
> no tool calls, no file writes — until confirmed.

> **Note wording** — state permanent facts in the
> present tense. A note read out of context must
> not reveal what it replaces or what just
> happened. Ban narration markers: "now", "no
> longer", "previously / used to", "reverses /
> replaces", "kept", "changed to", "reintroduce",
> "the user asked to". Phrase prohibitions
> positively ("the API is versioned under /v2"),
> not as the negation of a former state. Test:
> remove the note from its context — if a sentence
> only makes sense knowing the prior state,
> rewrite it.

- [Deployment contract](references/project_deployment_contract.md) — app repo
- [License](references/project_license.md) — Apache-2.0, Alexandre Roman
- [Makefile scope](references/project_makefile_scope.md) — checks only
- [No local paths](references/feedback_no_local_paths.md) — URLs only
- [Open HTTPS port](references/project_open_https_port.md) — no IP filter
