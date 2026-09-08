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
  from the zamstars-agents repo. Record current structure violations as `Broken / risky` STATE
  bullets rather than fixing everything at once.

## F6 — `.gitignore`
Contains `.env` and `node_modules/`. Add what is missing.

## F7 — Report
One line per check, ✓ or ✗, what was fixed, what still needs the human and the exact step. All
passed → run `docs/agent/CATCHUP.md` (or Scaffold first for a new app).

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
3. Create the layout below: `AGENTS.md`, `CLAUDE.md`, the pointer files and `docs/agent/` from
   the zamstars-agents repo; `README.md`, `STATE.md`, `DECISIONS.md`, `docs/LEDGER.md` (empty),
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

