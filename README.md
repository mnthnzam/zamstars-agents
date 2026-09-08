# zamstars-agents

How Zamstars people on different AI agents and different accounts work on the same app repos
without losing context. Works with any agent that reads `AGENTS.md` — Codex, Cursor, Copilot,
Gemini CLI, Zed, Windsurf, JetBrains — and with Claude Code via `CLAUDE.md`.

## The idea

**The rules live in the repo, not in the agent.** Every Zamstars app carries an `AGENTS.md`
(always-on rules, ~80 lines) and a `docs/agent/` folder (one file per ritual, opened on demand
when the user says the word). Clone the repo and any agent already knows the system. Nothing to
install.

| Say | The agent opens | When |
|---|---|---|
| `setup` | `docs/agent/SETUP.md` | first time on a repo |
| `catchup` | `docs/agent/CATCHUP.md` | start of every session |
| `handoff` | `docs/agent/HANDOFF.md` | end of every session |
| `decision` | `docs/agent/DECISION.md` | whenever a real choice is made |
| `groom` | `docs/agent/GROOM.md` | occasionally |

## What's in this repo

| Path | What |
|---|---|
| `agent/` | **The canonical source.** `AGENTS.md`, `CLAUDE.md` (a one-line import), per-tool pointer files, `docs/agent/*.md`. This is what gets copied into every app repo. |
| `templates/` | The other files every app repo carries: README, STATE, DECISIONS, LEDGER, ONBOARDING. |
| `skills/` | **Generated** from `agent/` by `build.sh`. Agent Skills standard (`SKILL.md`) for agents that support it. Do not edit by hand. |
| `SYSTEM.md` | Every design decision and why. |
| `build.sh` | Regenerates `skills/` from `agent/`. |

## Using it on an app

**New app or existing repo:** copy `agent/*` (including dotfiles) into the repo root, and the
files from `templates/` you don't already have. Then say `setup` to your agent. SETUP.md walks
through the rest, including retrofitting an existing codebase.

## Optional: install the skills (an accelerator, not a requirement)

Skills give you the rituals even outside a repo — useful for scaffolding a new app, or for agents
like Claude Cowork that don't auto-read repo files. The repo's own `AGENTS.md` always wins if
both exist.

| Agent | How |
|---|---|
| Claude Code | `/plugin marketplace add mnthnzam/zamstars-agents` then `/plugin install zamstars@zamstars` |
| Codex CLI | copy `skills/*` into `~/.codex/skills/` |
| Cursor | copy `skills/*` into the repo's `.cursor/skills/` |
| Gemini CLI | copy `skills/*` into `~/.gemini/skills/` |
| Claude Cowork | add each `skills/*/SKILL.md` as a skill in the app |

Private repo: you need collaborator access and git logged in to GitHub (`gh auth login`).

## Editing the system

Edit files under `agent/` only. Run `bash build.sh`. Bump `version` in both
`.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`. Commit and push. App repos
pick up changes when someone copies `agent/*` in again — `groom` flags when a repo's copy is
behind.
