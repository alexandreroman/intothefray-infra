# Into The Fray - Infrastructure

Deploys the backend of [Into The Fray](https://github.com/alexandreroman/intothefray)
(Go server + Redis, behind Caddy) to an OVH VPS at https://api.intothefray.xyz.
See [README.md](README.md) for the files, the deploy workflow and the VPS, Cloudflare, Tailscale and GitHub setup.

## Build & run

Nothing runs locally: a push to `main` that touches the stack redeploys it.
Validate every change first:

```sh
make check  # actionlint, shellcheck, compose config, caddy validate
```

## Deployment contract

The image, the `deploy-app` / `backend-deployed` dispatches and the Caddy and
Redis pins are shared with the app repo (see the project memory). Never change
them without asking the user, and change both repos together.

## Agents

Use the [skillbox](https://github.com/alexandreroman/skillbox) agents for all
code tasks:

- **code-writer**: any change to code, however small. Never edit source files
  directly.
- **code-reviewer**: read-only review before merging or when investigating.

## Memory

Read `.claude/project-memory/MEMORY.md` at the start of every conversation.
Persist decisions, references and feedback proactively with the
**project-memory** skill (skillbox), never with the built-in auto-memory,
which stays on one machine.

## Conventions

- All project text is in English: code, comments, docs, commit messages.
- Line length: 80 columns for text and Markdown, 120 for code.
- Markdown: blank line around headings and lists, fenced code blocks with a
  language tag, aligned tables.
- Use the latest stable versions of images, actions and tools; check them
  before pinning (e.g. `gh api repos/<owner>/<repo>/releases/latest`). Pin
  actions to their major version.
- Never echo secrets in the workflow; pass untrusted values (dispatch
  payloads, inputs) through `env`, never inline `${{ }}` in scripts.
- Commit directly on `main`.
