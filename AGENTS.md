# zamstars-agents — operating contract for THIS repo

> **This file governs work on the operating layer itself.**
> The file that gets copied into app repos is **`agent/AGENTS.md`**. They are different files
> with different rules. Changing how apps behave means editing `agent/AGENTS.md`, not this one.

This repo is the canonical source of the Zamstars operating layer. It is not an app: it ships
markdown and one bash script. The repo is the source of truth; you are an editor, never a store.

## Files you will read and write

| File | One question it answers | Mutability |
|---|---|---|
| `README.md` | What is this and how do I use it on an app? | Edited rarely |
| `DECISIONS.md` | Why is the system designed this way? What was rejected? | Append-only, newest at top |
| `SYSTEM.md` | The long-form argument behind the decisions | **Frozen** — background only, see below |
| `STATE.md` | What is true right now — in flight, broken, next, who holds it? | Overwritten every handoff |
| `docs/LEDGER.md` | What left STATE, when, and why? | Append-only |

**`SYSTEM.md` is frozen background.** It is the narrative record of the design sessions that
produced this system and it is worth keeping, but it is not the decision record: no tags, no
status lines, no `Revisit if`, and it only grows. New reasoning goes in `DECISIONS.md`. Do not
append to `SYSTEM.md`; link to its sections from a decision's `Where:` instead.

Shapes for STATE, DECISIONS and LEDGER entries: `agent/docs/agent/SHAPES.md`.

## Rituals — when the user says a word, open the file and follow it exactly

The ritual files live at **`agent/docs/agent/`** in this repo — the same files that get copied
into apps. There is deliberately no second copy here to drift.

| The user says | Open |
|---|---|
| `setup`, `onboard me`, "I'm new" | `agent/docs/agent/SETUP.md` |
| `catchup`, `sync in` | `agent/docs/agent/CATCHUP.md` |
| `handoff`, `wrap up` | `agent/docs/agent/HANDOFF.md` |
| `decision` — or the moment a real choice is made | `agent/docs/agent/DECISION.md` |
| `groom`, "is this repo rotting" | `agent/docs/agent/GROOM.md` |

Do not improvise a ritual from memory. Open the file.

## Git mode — who runs git

`git config --local zamstars.mode` is `direct` or `terminal`. Unset → run SETUP.
In `terminal` mode, never run a mutating git command yourself: hand the user one fenced block
starting with `cd <absolute repo path>`, single-quote commit messages, and wait.

**Pre-flight before any commit or push:** a repo is found; `git config user.email` resolves;
`git remote get-url origin` returns something; `zamstars.mode` is set. Any failure → SETUP.

## Hard rules

- Nothing ships that isn't committed and pushed.
- **Edit only under `agent/` and `templates/` to change the system.** `skills/` is generated.
- **After any change under `agent/`: run `bash build.sh`, then bump `version` in BOTH
  `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`.** A change committed
  without a rebuild ships a skill that disagrees with the source — the one failure this repo
  exists to prevent.
- Never hand-edit anything in `skills/`. If a generated file is wrong, the source or `build.sh`
  is wrong.
- The drift rule is load-bearing: an app repo's `AGENTS.md` beats any installed skill. Every
  generated `SKILL.md` must keep saying so.
- `STATE.md` holds only live items, rewritten wholesale. No bullet leaves without a line in
  `docs/LEDGER.md`.
- `DECISIONS.md` bodies are never edited; the only change to a past entry is a status line.
- Never force-push. Never silently resolve a conflict. Never `git add -A` — add named files.
- Commit messages carry the human's authorship only. No `Co-Authored-By`, no session links, no
  agent attribution of any kind in commits, PRs or files.
- Never handle a token. Never write a credential into a tracked file.

## Content rules — this repo ships prose, so prose is the code

- `agent/AGENTS.md` stays under **100 lines**. It is always-on in every app; every line costs
  every agent on every task. Detail belongs in `agent/docs/agent/*.md`, opened on demand.
- A ritual file stays under **60 lines** and is a numbered procedure, not an essay. `SETUP.md`
  and `STRUCTURE.md` are the allowed exceptions — both are reference, not per-session reading.
- Every rule earns its place by naming the failure it prevents. A rule without a failure mode
  is a preference, and preferences get ignored, which teaches that rules can be ignored.
- Write for an agent that is skimming. Numbered steps, imperative voice, thresholds as numbers.

## App-specific rules

Cap: 10. To add an eleventh, remove one. Each carries the date it was added.

1. (2026-09-08) Never add a ritual without adding its trigger row to `agent/AGENTS.md` and its
   file to the right `emit` line in `build.sh`. A ritual nobody can reach is dead weight.
2. (2026-09-08) Templates in `templates/` are seeded by SETUP's scaffold, never shipped empty.
   An empty `DECISIONS.md` teaches a team that nothing goes there.
