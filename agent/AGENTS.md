# Zamstars operating contract

This repo is one Zamstars app. **The repo is the source of truth; you are an editor, never a
store.** A change that exists only in a chat does not exist. No Claude Artifacts, no hosted
one-off pages — apps are normal repos built to be handed to a developer without apology.

## Files you will read and write

| File | One question it answers | Mutability |
|---|---|---|
| `README.md` | What is this, how do I run it, where does it run? | Edited rarely |
| `DECISIONS.md` | Why is the code the way it is? What was rejected? | Append-only, newest at top |
| `STATE.md` | What is true right now — in flight, broken, next, who holds it? | Overwritten every handoff; live items only |
| `docs/LEDGER.md` | What left STATE, when, and why? | Append-only |
| `docs/ONBOARDING.md` | What does a newcomer need before their first session? | Edited rarely |

Shapes for STATE, DECISIONS and LEDGER entries: `docs/agent/SHAPES.md`.
Limits and layout for the code itself: `docs/agent/STRUCTURE.md`.

## Rituals — when the user says a word, open the file and follow it exactly

| The user says | Open | Runs |
|---|---|---|
| `setup`, `onboard me`, "I'm new", or any pre-flight check below fails | `docs/agent/SETUP.md` | once per person per repo |
| `catchup`, `sync in` | `docs/agent/CATCHUP.md` | start of every session |
| `handoff`, `wrap up` | `docs/agent/HANDOFF.md` | end of every session |
| `decision`, "note that as a decision" — **or the moment a real choice is made** | `docs/agent/DECISION.md` | whenever it happens |
| `groom`, "is this repo rotting" | `docs/agent/GROOM.md` | occasionally |

Do not improvise a ritual from memory. Open the file.

## Git mode — who runs git

`git config --local zamstars.mode` is `direct` or `terminal`. Unset → run SETUP.

- **direct** — you can run shell commands on the user's own machine. You run git yourself.
- **terminal** — you cannot, or your shell is not their machine (a sandbox, a chat UI). For every
  mutating git command (`clone init remote config add commit pull push checkout stash`): hand the
  user one fenced block starting with `cd <absolute repo path>`, single-quote commit messages, say
  whether to paste the output back, and **wait**. Never proceed on assumption. Reads (`status`,
  `log`, `diff`) you run yourself if you have any shell; otherwise ask for them pasted too.

**Pre-flight before any commit or push:** a repo is found; `git config user.email` resolves;
`git remote get-url origin` returns something; `zamstars.mode` is set. Any failure → SETUP.

## Hard rules

- Nothing ships that isn't committed and pushed.
- Respect the git mode. In `terminal` mode never run a mutating git command yourself.
- `STATE.md` holds only live items and is rewritten wholesale. No bullet leaves it without a
  line in `docs/LEDGER.md`.
- `DECISIONS.md` bodies are never edited; the only change to a past entry is a status line at its
  top. No entry without a non-empty **Rejected** drawn from alternatives actually discussed.
- Decisions are recorded when made, not remembered at handoff.
- Never force-push. Never silently resolve a conflict. Never `git add -A` — add named files.
- Commit messages carry the human's authorship only. No `Co-Authored-By`, no session links, no
  agent attribution of any kind in commits, PRs or files.
- Never handle a token. Never write a credential into a tracked file.
- Never remove operating-layer content the user has not seen and agreed to lose.
- If these files contradict the code, trust the code, say the docs are wrong, fix them this handoff.

## Code rules — hard limits, checked at every handoff

- No source file over **200 lines** (fail at 300). No function over **50 lines**.
- One exported thing per file, named the same as the file. `src/types/` is exempt.
- No business logic in UI components — components render and call; logic lives in `lib/` or the
  feature's own module.
- No inline `<script>`/`<style>`, no `onclick=`.
- **Imports point downward only:** `pages → features → lib → types`. Never sideways between
  features, never upward. Shared by two features → move it down to `lib/` or `components/`.
- `features/` is the default home; `components/` only for things used by 2+ features.
- Secrets in `.env` only. `.env.example` committed, `.env` never.
- Default stack: Vite + React + TypeScript + Tailwind; Supabase for data and auth.

**Before enforcing a limit, splitting a file, or claiming one is too long, open
`docs/agent/STRUCTURE.md`** — it carries what the numbers are for, the exempt files, how to
split without making it worse, and what to do when someone declines. A split made without
reading it is usually a bad split.

## App-specific rules

Cap: 10. To add an eleventh, remove one. Each carries the date it was added.

1. (YYYY-MM-DD) <rule>

## If none of the words above do anything

You are an agent without these files loaded. Minimum discipline: at start, `git pull` and read
`README.md`, `STATE.md`, the top of `DECISIONS.md`. At end, overwrite `STATE.md` with what is
true now, add a DECISIONS entry if a real choice was made, commit, push.
