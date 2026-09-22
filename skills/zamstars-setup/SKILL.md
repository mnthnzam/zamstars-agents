---
name: zamstars-setup
description: "Zamstars onboarding and scaffolding. Use when the user says setup / onboard me / first time / I'm new, wants to start a new Zamstars app or join one, or when pre-flight fails. Walks a newcomer from zero, picks the git mode, tests access before cloning, retrofits or scaffolds the operating layer."
---

> **Generated from `agent/` in github.com/mnthnzam/zamstars-agents by build.sh — do not edit here.**
> If the repo you are in has `AGENTS.md`, that file and `docs/agent/` are authoritative and may be newer than this skill. Read and follow them; use the text below only when no repo exists yet.

# setup — onboarding and pre-flight

Gets one person from wherever they are to the point where catchup and handoff work on one
repo. Re-runnable and idempotent. Ends with a ✓/✗ report naming exactly what still needs a
human and the exact step. `docs/ONBOARDING.md` is the human-readable copy a newcomer reads on
GitHub before they have any agent at all.

## F0 — Prerequisites a brand-new person may not have
Ask which they already have; instruct only on gaps. Opening Terminal on a Mac: `Cmd+Space`,
type `Terminal`, Enter. Windows: **Git Bash** (comes with git) or PowerShell.

1. **GitHub account** — github.com → Sign up. An email they will keep.
2. **git** — `git --version`. Mac: accept the Command Line Tools prompt, or `xcode-select
   --install`, or `brew install git`. Windows: git-scm.com/download/win, defaults, then Git Bash.
3. **Node LTS** — `node --version`, `npm --version`. Missing → nodejs.org → **LTS** installer →
   reopen Terminal → re-check. Mac alternative: `brew install node`.
4. **Tell git who they are** — on their own machine, global is correct:
   `git config --global user.name 'Their Name'` and
   `git config --global user.email 'the-email-on-their-github-account'`
5. **A way to push.** GitHub does not accept account passwords for git. Easiest: GitHub CLI —
   `brew install gh` (Mac) or github.com/cli/cli — then `gh auth login` → GitHub.com → HTTPS →
   browser. Or a fine-grained token: github.com → profile photo → Settings → Developer settings →
   Personal access tokens → Fine-grained → repo access: only what they need → Contents: Read and
   write → copy once → on first `git push`, username + token as the password; the OS keychain
   remembers it.
6. **Repo access.** They must be a collaborator: owner → repo → Settings → Collaborators → Add
   people. They accept the email invite. Until then `clone` and `ls-remote` fail with
   **"repository not found" — that means no access, not a bad URL.** Say so explicitly.
7. **An agent that reads `AGENTS.md`** — Codex, Cursor, Copilot, Gemini CLI, Zed, Windsurf,
   JetBrains, or Claude Code (via `CLAUDE.md`). No install is needed beyond cloning: the rules
   travel with the repo. The `zamstars-*` skills are an optional accelerator for agents that
   support the Agent Skills standard; see `docs/ONBOARDING.md`.
8. **A folder for Zamstars repos**, e.g. `~/Zamstars/`.

## F1 — Pick the git mode
Can you run shell commands on the user's own machine? Yes → `direct`. No, or your shell is a
sandbox that is not their machine → `terminal`. When unsure, ask once: *"When git needs to run,
do you want me to hand you commands for your Terminal, or run them myself?"* Store it:
`git config --local zamstars.mode <mode>` (after the repo exists — defer to F2 if needed).

## F2 — Which situation?
Look for a repo in the target folder.
- **Found** → F3.
- **Not found** → ask: joining an existing app, or starting a new one?
  - **Joining** → ask for the GitHub URL. Test access **before** cloning: `git ls-remote --heads
    <url>`. Success → `git clone <url>` → F3. Failure → F0 step 6; nothing proceeds until they
    are a collaborator. Do not work around it.
  - **New** → they create the remote in a browser: github.com → New repository → name → Private
    → do **not** add a README or .gitignore → Create → copy the HTTPS URL. Then `git init` and
    `git remote add origin <url>`. Scaffold (below) runs after F7.
- Set `zamstars.mode` now if deferred.

## F3 — Identity
`git config user.email` must resolve. Empty → F0 step 4. If your shell is a sandbox and you are
in `direct` mode anyway, set it `--local` so it lives in the repo folder and persists.

## F4 — Push access
`git push --dry-run origin HEAD` once a commit exists (otherwise defer to the end of scaffold).
Auth failure → F0 step 5, re-test. A push that cannot succeed here **will** fail at handoff, and
"nothing ships uncommitted" becomes "nothing ships." Fix it now.

## F5 — Operating layer present?
`AGENTS.md`, `CLAUDE.md`, `docs/agent/*`, `README.md`, `DECISIONS.md`, `STATE.md`,
`docs/LEDGER.md`, `docs/ONBOARDING.md`.
- New app → Scaffold.
- **Existing repo without them → retrofit.** Run the scaffold interview against what is actually
  there: `package.json`, the `src/` tree, the last 30 commits. Seed README from code plus
  interview, DECISIONS from the interview (stack, storage, deploy — whatever the code reveals),
  STATE from `git log` plus interview. Copy in `AGENTS.md`, the pointer files and `docs/agent/`
  (see **Getting the files** below). Record current structure violations as `Broken / risky`
  STATE bullets rather than fixing everything at once.

## F6 — `.gitignore`
Contains `.env` and `node_modules/`. Add what is missing.

## F7 — Report
One line per check, ✓ or ✗, what was fixed, what still needs the human and the exact step. All
passed → run `docs/agent/CATCHUP.md` (or Scaffold first for a new app).

## Getting the files
The operating layer is copied into every repo, never fetched at runtime. Take it from the first
source that works — never ask the user for a path before trying 1:
1. **Clone.** The repo is public: `git clone --depth 1 https://github.com/mnthnzam/zamstars-agents`
   into a scratch folder, then copy `agent/*` **including dotfiles** (`.cursor/`, `.github/`,
   `.windsurf/`) to the repo root and the `templates/*` you don't already have. Fill
   `docs/ONBOARDING.md`'s owner. Any shell with network can do this — a sandbox included.
2. **Bundled copy.** No network: the `zamstars-setup` skill ships the same files. Folder installs
   (Claude Code plugin, Codex, Cursor, Gemini) have them under `files/` next to `SKILL.md`; a
   single-file install (Claude Cowork) has the small ones verbatim in the skill's **Bundled
   files** appendix and the ritual files spread across the three skills' text. Prefer 1 — the
   bundle is only as new as the installed skill.
3. **A local clone the user connects.** Last resort.
Never hand-type these files from memory. Never edit them in the app repo — changes go to
zamstars-agents and get copied back in.

## Scaffold — a new app
Runs after F7 passes.
1. **Interview before writing.** Never write placeholders for the user to fill.
   - What does this app do, in one sentence, and for whom?
   - Who uses it — just Zamstars, or a client?
   - Data storage or auth needed? If yes, default to Supabase over writing a backend.
   - Where will it run — local only, or deployed?
   - What does it depend on, and who holds each key or account?
   - Anything the agent must never do in this repo?
2. Default stack: **Vite + React + TypeScript + Tailwind**, Supabase for data and auth. Do not
   invent a novel stack — hireability is the point.
3. Create the layout below: `AGENTS.md`, `CLAUDE.md`, the pointer files and `docs/agent/` (see
   **Getting the files**); `README.md`, `STATE.md`, `DECISIONS.md`, `docs/LEDGER.md` (empty),
   `docs/ONBOARDING.md` with the owner filled in; `.env.example`; `.gitignore`.
4. **Seed `DECISIONS.md` from the interview** — stack, storage/auth, deploy target are each a
   real decision with a rejected alternative. Two or three entries, tagged. An empty DECISIONS
   file teaches the team that nothing goes there.
5. Commit `chore: scaffold app and operating layer`. Run F4 if deferred. Push.

```
AGENTS.md  CLAUDE.md  GEMINI.md  README.md  DECISIONS.md  STATE.md
.cursor/rules/zamstars.mdc  .github/copilot-instructions.md  .windsurf/rules/zamstars.md
.env.example  .gitignore  package.json  index.html
docs/
  agent/            SETUP CATCHUP HANDOFF DECISION GROOM SHAPES
  LEDGER.md         everything that has left STATE
  ONBOARDING.md     what a newcomer needs before they have any agent
src/
  main.tsx          entry — wiring only, no logic
  App.tsx           routing and layout only
  pages/            one file per screen
  features/<name>/  a feature owns its components, logic and types
  components/       shared, dumb, no business logic
  lib/              pure functions, API clients — no UI
  types/  styles/
public/
```


---

## Bundled files — for a single-file skill install (Claude Cowork)

The small files below are verbatim; write each to the path shown, at the app repo root. Prefer cloning the public repo (see **Getting the files**) — this appendix is only as new as the installed skill. The ritual files (`docs/agent/*.md`) are not repeated here: `AGENTS.md`, `SHAPES.md`, `STRUCTURE.md`, `CATCHUP.md`, `HANDOFF.md` and `DECISION.md` are the sections of the `zamstars-ops` skill in that order, `SETUP.md` is this skill, `GROOM.md` opens the `zamstars-groom` skill. Split them at the `---` rules.

### `CLAUDE.md`

````markdown
@AGENTS.md

````

### `GEMINI.md`

````markdown
Read `AGENTS.md` at the repo root and follow it exactly. It is the operating contract for this repo; the rituals it names live in `docs/agent/`.

````

### `.cursor/rules/zamstars.mdc`

````markdown
---
description: Zamstars operating contract
alwaysApply: true
---
Read `AGENTS.md` at the repo root and follow it exactly. The rituals it names live in `docs/agent/`.

````

### `.github/copilot-instructions.md`

````markdown
Read `AGENTS.md` at the repo root and follow it exactly. The rituals it names live in `docs/agent/`.

````

### `.windsurf/rules/zamstars.md`

````markdown
Read `AGENTS.md` at the repo root and follow it exactly. The rituals it names live in `docs/agent/`.

````

### `docs/ONBOARDING.md`

````markdown
# Joining <App name>

Owner: <name> — ask them for repo access.

## Before your first session
1. **GitHub account** — github.com/signup. Send your username to the owner; accept the invite
   email. Until you do, cloning fails with "repository not found" — that means no access, not a
   bad link.
2. **git** — `git --version` in Terminal (Mac: Cmd+Space, "Terminal"). Mac: accept the Command
   Line Tools prompt or run `xcode-select --install`. Windows: git-scm.com, then use Git Bash.
3. **Node LTS** — nodejs.org → LTS installer → reopen Terminal → `node --version`.
4. **Tell git who you are:**
   `git config --global user.name 'Your Name'`
   `git config --global user.email 'the email on your GitHub account'`
5. **Log in to GitHub for pushing** — easiest: install GitHub CLI and run `gh auth login`.
   Or a fine-grained token (Settings → Developer settings → Personal access tokens, Contents:
   Read and write on this repo) pasted as the password on first push.
6. **Make a folder**, e.g. `~/Zamstars`, and clone into it: `git clone <repo url>`
7. **Any coding agent.** The rules travel with the repo in `AGENTS.md`, which Codex, Cursor,
   Copilot, Gemini CLI, Zed, Windsurf and JetBrains read on their own, and Claude Code reads
   through `CLAUDE.md`. Nothing to install. Optional accelerator for agents that support the
   Agent Skills standard (Claude Code, Codex, Cursor, Gemini CLI): the `zamstars-*` skills from
   github.com/mnthnzam/zamstars-agents — see that repo's README.

## Your first session
Open the repo folder in your agent and say **`setup`**. It checks everything above, fixes what
it can, and tells you exactly what is still missing. Then it runs `catchup`, which tells you
what this app is and where it stands.

Every session after: **`catchup`** at the start, **`handoff`** at the end, **`decision`** when a
real choice gets made. That is the whole ritual.

## How git commands get run
If your agent can run commands on your own machine (Claude Code, Cursor, Codex CLI, Gemini CLI),
it runs git itself. If it cannot — a chat interface, or a sandbox that is not your computer — it
hands you the commands to paste into Terminal and asks for the output back. Your Terminal already
knows who you are and how to reach GitHub; that is why.

````

### `STATE.md`

````markdown
# STATE — <app>

Updated: <YYYY-MM-DD> by <name>
Active: <name (since YYYY-MM-DD), or `none`>
Branch: <where the live work is>

## In flight — half-done, do not touch without talking to Active
- (MM-DD) <what was started, and what's left>

## Broken / risky — known bad right now
- (MM-DD) <symptom> → <suspected cause, if known>
- (MM-DD) Don't touch: <file or area> — <why>

## Next up — safe to pick up cold
- (MM-DD) <task> — <the one thing you need to know to start>

## Open questions — best place to pitch in
- (MM-DD) <question> — <what a good answer would unblock>

<!--
RULES (delete this block in real files):
- Every bullet carries the date it FIRST appeared, in (MM-DD). Carry it forward unchanged
  across rewrites. It is what makes staleness visible instead of a judgment call.
- Max 3 bullets per section, 12 in the file. One line each. If it needs a paragraph it is a
  DECISION or a doc.
- Empty section = write `- none`. Never delete a heading; the shape must stay stable.
- Never write history here. "Fixed X" belongs in the commit message.
- Rewritten wholesale every handoff. Never appended to.

WHEN A BULLET LEAVES (handoff does this):
Bullets are never moved to a "Done" section here. STATE holds only live, open items. Anything
that stops being live moves to `docs/LEDGER.md` as one line:

  09-07 done     (09-02) auth redirect bug — session wasn't restored before the guard ran [a1b2c3d]
  09-07 dropped  (08-14) CSV export — nobody asked for it in three weeks

Four verbs only: done / dropped / answered / moved. Keep the bullet's ORIGINAL date alongside
the date it left, so how long it lived stays visible.

A bullet may never simply vanish. If handoff cannot say which verb applies, it asks.

DECAY (handoff enforces this):
- An "In flight" bullet older than 14 days is not in flight, it is abandoned. Decide:
  move it to "Next up", or delete it. It may not stay.
- Any bullet older than 30 days: confirm it is still true or delete it.
- Deleting from STATE loses nothing — STATE is a snapshot, and the history is in git.
-->

````

### `DECISIONS.md`

````markdown
# DECISIONS — <app>

Why the code is the way it is. Append-only, newest at top.

## Write an entry when
A developer reading this code in six months would ask **"why on earth did they do it this way?"**
That is the whole test. If the code is self-explanatory, there is no entry.
Mechanical check: if **Rejected** would be empty, it is not a decision — it is a task. Skip it.

## Never edit an entry's body
The only permitted change to a past entry is a status line at its top:

    > PROPOSED   YYYY-MM-DD by <name>                — a pitch, not yet in force
    > SUPERSEDED YYYY-MM-DD by <newer entry title>   — replaced; the newer entry says why
    > OBSOLETE   YYYY-MM-DD — <why>                  — the code it described no longer exists
    > REJECTED   YYYY-MM-DD by <name> — <why>        — a proposal that did not land

No status line means **active and in force**. Reasoning is written once: a superseding entry
carries the argument, the old entry just gets the status line.

## To pitch a change that contradicts an existing decision
Write a new entry with `> PROPOSED` at its top. Do not touch the old one. `catchup` shows every
PROPOSED entry to everyone until the owner resolves it: remove the PROPOSED line and mark the old
entry SUPERSEDED, or mark the proposal REJECTED with one line of why.

## Tags — pick exactly one, grep by it
`[stack]` `[data]` `[auth]` `[ui]` `[infra]` `[process]` `[scope]`

---

## YYYY-MM-DD [tag] — <the decision, one line, stated as a fact>
**Context:** <what forced the choice — 1 to 3 lines>
**Chose:** <what we did>
**Rejected:** <what we didn't — one reason each>
**Revisit if:** <a condition someone could answer yes/no to today>
**Where:** <file or folder this decision lives in — optional>

<!--
RULES (delete this block in real files):
- Body max ~12 lines. If Context needs a paragraph, put the paragraph in docs/ and link it.
- "Revisit if" must be checkable. "if we scale" fails. "if a second client signs" passes.
  groom reads every active entry's Revisit-if and asks: is this true now?
- "Where" is what lets groom verify the decision against the code, and what lets a developer
  grep from the code back to the reasoning. Fill it when the decision has a physical home.
- Title is a statement, not a topic. "Single-tenant, no org model" — not "Tenancy".
- Never number entries. Date + title is the reference: "see 2026-09-07 no-artifacts".

DECAY (handoff checks, acts only when tripped):
- Over 800 lines or 40 entries: move SUPERSEDED / OBSOLETE / REJECTED entries into
  docs/decisions-<year>.md, leaving a one-line stub here that links to each. Active and
  PROPOSED entries never leave this file.
- Nothing is ever deleted. If you are tempted to delete a decision, you are about to remove
  the only record of why something is the way it is.
-->

````

### `docs/LEDGER.md`

````markdown
# LEDGER — <app>

Everything that has left `STATE.md`, newest first. `STATE.md` holds only live, open items;
this is where they go when they stop being live.

Written by `handoff`, never by hand. Append-only: never edit or delete a line. When the current
year's section gets long, it is split into `docs/ledger-<year>.md` and this file keeps the
current year only.

Line format: `<date left> <verb> (<date entered>) <the bullet> — <why> [<commit>]`

Four verbs only: **done** · **dropped** · **answered** · **moved**

---

## 2026

- 09-07 done     (09-02) auth redirect bug — session wasn't restored before the route guard ran [a1b2c3d]
- 09-07 dropped  (08-14) CSV export — nobody asked for it in three weeks
- 09-05 answered (08-29) do we need SSO? — no, single tenant for now → see DECISIONS 08-29
- 09-01 moved    (08-20) invoice screen — in flight >14 days, returned to Next up

<!--
RULES (delete this block in real files):
- Newest at top, within the newest year.
- A `dropped` or `answered` line carrying real reasoning goes to DECISIONS.md; the ledger line
  then just points at it. Do not write the reasoning twice.
- `done` lines carry the short commit sha so you can jump straight to the code.
- Keep both dates. The gap between them is how long the item lived, which is the cheapest
  signal you have about whether the team is finishing things or accumulating them.
- This file exists to answer one question: "did we already try this, and what happened?"
  If a line does not help answer that, it should not be here.
-->

````

### `README.md`

````markdown
# <App name>

<One sentence: what it does, and for whom.>

## Status
`prototype` | `live` | `paused` | `deprecated`

## Run it
```bash
npm install
cp .env.example .env    # then fill in the values
npm run dev
```
<Anything else needed from a cold clone. Assume the reader knows nothing about us.>

## Stack
<e.g. Vite + React + TypeScript + Tailwind. Supabase for data and auth.>

## How it works (max 5 bullets)
-

## Where it runs
- Repo: <url>
- Deployed: <url, or "local only">
- Other surfaces: <workflow, sheet, endpoint, cron>

## Depends on
| Thing | Why | Who holds the account/key |
|---|---|---|
|  |  |  |

## Glossary
<Internal words a newcomer would misread. Delete if none.>

---
New here? Read `docs/ONBOARDING.md`, then say `setup`. Otherwise read `CLAUDE.md`, then say `catchup`.

<!--
DECAY: this file rots by becoming WRONG, not by growing. Every handoff cross-checks it:
- Do the scripts named under "Run it" still exist in package.json?
- Does every var in .env.example still appear in the code, and vice versa?
- Does the Depends-on table still match package.json and the connectors actually used?
A mismatch is a bug in this file. Fix it in the same handoff, do not defer it.
-->

````

