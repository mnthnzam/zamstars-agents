---
name: zamstars-setup
description: "Zamstars onboarding and scaffolding. Use when the user says setup / onboard me / first time / I'm new, wants to start a new Zamstars app or join an existing one, or when zamstars-ops pre-flight fails. Walks a newcomer from zero (GitHub account, git, node, access, push auth), picks the git mode, tests access before cloning, retrofits or scaffolds the operating layer."
---

# Zamstars setup — onboarding and scaffolding

**Load `zamstars-ops` first.** It carries the git-mode protocol, the pre-flight, the hard rules,
and the shapes of STATE / DECISIONS / LEDGER. This skill adds what happens *before* the everyday
rituals can work: getting a person and a repo to the starting line.

Re-runnable and idempotent. Ends with a ✓/✗ report naming exactly what still needs a human and the
exact step. `docs/ONBOARDING.md` in every repo is the human-readable copy a newcomer reads on
GitHub before they have Claude or this skill.

## Routing

| Trigger | Path |
|---|---|
| `setup`, `onboard me`, "I'm new", pre-flight failure | **F0 → F7** |
| new app, scaffold, "start a new application" | F0 → F7, then **Mode C** |
| existing repo with no operating layer | F0 → F7 with **retrofit** at F5 |

---

## F0 — Prerequisites a brand-new person may not have

Ask which they already have; instruct only on gaps. Opening Terminal on a Mac: `Cmd+Space`, type
`Terminal`, Enter. Windows: **Git Bash** (comes with git) or PowerShell.

1. **GitHub account** — github.com → Sign up. Free. An email they will keep.
2. **git installed** — `git --version`.
   - **Mac:** accept the Command Line Tools prompt, or run `xcode-select --install`. Or `brew install git`. Re-check.
   - **Windows:** git-scm.com/download/win, installer with defaults, then open Git Bash and re-check.
3. **Node LTS** — `node --version` and `npm --version`. Missing → nodejs.org → **LTS** installer → run → reopen Terminal → re-check. Mac alternative: `brew install node`.
4. **Tell git who they are** — on their own machine, global is correct:
   ```
   git config --global user.name 'Their Name'
   git config --global user.email 'the-email-on-their-github-account'
   ```
5. **A way to push.** GitHub does not accept account passwords for git. One of:
   - **Easiest:** GitHub CLI — `brew install gh` (Mac) or github.com/cli/cli (Windows), then `gh auth login` → GitHub.com → HTTPS → browser. Push then just works.
   - **Or a token:** github.com → profile photo → Settings → Developer settings → Personal access tokens → Fine-grained → Generate. Repository access: only the repo(s) needed. Permissions: Contents → Read and write. Copy once. On first `git push`, username + token as the password; the OS keychain remembers it.
6. **Repo access.** They must be a collaborator. Owner: repo → Settings → Collaborators → Add people → their username. They accept the email invite. Until then `clone` and `ls-remote` fail with **"repository not found" — that means no access, not a bad URL.** Say this explicitly; newcomers lose an hour to it.
7. **Claude with `zamstars-ops` and this skill.** Until an internal marketplace exists, the owner sends them. Claude Code install: follow the current instructions at code.claude.com.
8. **A folder for Zamstars repos**, e.g. `~/Zamstars/`. In Cowork, connect that folder to the session.

## F1 — Pick the git mode

Ask once, plainly: *"When git needs to run — pull, commit, push — do you want me to hand you
commands to paste into your Terminal, or run them myself?"* Claude Code → `direct`, no need to
ask. Cowork → default `terminal`; `shell` only if they ask for Claude to run things.
Store: `git config --local zamstars.mode <mode>` (after the repo exists — defer to F2 if needed).

## F2 — Which situation?

Look for a repo in the target folder.
- **Found** → F3.
- **Not found** → ask: *joining an existing app*, or *starting a new one*?
  - **Joining** → ask for the GitHub URL. Test access **before** cloning: `git ls-remote --heads <url>` (terminal mode: hand over, paste back). Success → `git clone <url>` into the folder → F3. Failure → F0 step 6; **nothing proceeds until they are a collaborator.** Do not work around it.
  - **New** → they create the remote in a browser: github.com → New repository → name → Private → do **not** add a README or .gitignore → Create → copy the HTTPS URL. Then `git init` and `git remote add origin <url>` in the folder. Mode C runs after F7.
- Set `zamstars.mode` now if deferred.

## F3 — Identity in the mode that will commit

- **direct / terminal:** `git config user.email` must resolve. Empty → F0 step 4.
- **shell:** must be `--local`. Set `git config --local user.name` / `user.email` via `device_bash`. Why: the Cowork shell has a session-scoped `$HOME` and forgets global config every session (verified: fresh sessions fail with "Please tell me who you are"); `.git/config` is on their Mac and persists.

## F4 — Push access

`git push --dry-run origin HEAD` once a commit exists (otherwise defer to the end of Mode C). Auth failure:
- **direct / terminal:** F0 step 5. Re-test.
- **shell:** `.git/.cw-credentials` missing or wrong. They create it **in their own Terminal, never through Claude**, with a fine-grained token from F0 step 5:
  `printf 'https://<github-user>:<token>@github.com\n' > <repo>/.git/.cw-credentials && chmod 600 <repo>/.git/.cw-credentials`
  Re-test with the `-c credential.helper=...` push form.

A push that cannot succeed here **will** fail at handoff, and "nothing ships uncommitted" becomes "nothing ships." Fix it now.

## F5 — Operating layer present?

`README.md`, `DECISIONS.md`, `STATE.md`, `CLAUDE.md`, `docs/LEDGER.md`, `docs/ONBOARDING.md`.
- New app → Mode C.
- **Existing repo without them → retrofit.** Run the Mode C interview against what is actually there: read `package.json`, the `src/` tree, the last 30 commits. Seed README from code plus interview, DECISIONS from the interview (stack, storage, deploy — whatever the code already reveals), STATE from `git log` plus interview. Write CLAUDE.md with the structure rules; record current violations (files over 200 lines, logic in components) as `Broken / risky` STATE bullets rather than fixing everything at once.

## F6 — `.gitignore`

Contains `.env` and `node_modules/`. Add what is missing.

## F7 — Report, then hand back

One line per check, ✓ or ✗, what was fixed, what still needs the human and the exact step. All
passed → run `catchup` from `zamstars-ops` (or Mode C first for a new app).

---

## Mode C — scaffold a new app

Runs after F7 passes (repo initialised, remote set, identity set, mode chosen).

1. **Interview before writing.** Never write placeholders for the user to fill.
   - What does this app do, in one sentence, and for whom?
   - Who uses it — just Zamstars, or a client?
   - Data storage or auth needed? If yes, default to Supabase over writing a backend.
   - Where will it run — local only, or deployed?
   - What does it depend on, and who holds each key or account?
   - Anything Claude must never do in this repo?
2. Default stack unless told otherwise: **Vite + React + TypeScript + Tailwind**, Supabase for data and auth. Do not invent a novel stack — hireability is the point.
3. Create the layout below: four root files, `docs/LEDGER.md` (empty), `docs/ONBOARDING.md` with the owner filled in, `.env.example`, `.gitignore` (`.env`, `node_modules/`).
4. **Seed `DECISIONS.md` from the interview** — stack, storage/auth, deploy target are each a real decision with a rejected alternative. Two or three entries, tagged. An empty DECISIONS file teaches the team nothing goes there.
5. Commit `chore: scaffold app and operating layer`. Run F4 if deferred. Push.

```
CLAUDE.md  README.md  DECISIONS.md  STATE.md
.env.example  .gitignore  package.json  index.html
docs/
  LEDGER.md         everything that has left STATE
  ONBOARDING.md     what a newcomer needs before they have the skill
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

## Templates (STATE, DECISIONS, LEDGER shapes are in `zamstars-ops`)

**README.md**
```markdown
# <App name>
<One sentence: what it does, and for whom.>

## Status
`prototype` | `live` | `paused` | `deprecated`

## Run it
npm install / cp .env.example .env / npm run dev

## Stack
<Vite + React + TypeScript + Tailwind. Supabase for data and auth.>

## How it works (max 5 bullets)
-

## Where it runs
- Repo: <url>
- Deployed: <url, or "local only">

## Depends on
| Thing | Why | Who holds the account/key |
|---|---|---|

## Glossary
<Internal words a newcomer would misread. Delete if none.>

---
New here? Read `docs/ONBOARDING.md`, then say `setup`. Otherwise read `CLAUDE.md`, then say `catchup`.
```

**docs/ONBOARDING.md**
```markdown
# Joining <App name>

Owner: <name> — ask them for repo access and for the `zamstars-ops` and `zamstars-setup` Claude skills.

## Before your first session
1. GitHub account — github.com/signup. Send your username to the owner; accept the invite email.
   Until you do, cloning fails with "repository not found" — that means no access, not a bad link.
2. git — `git --version` in Terminal (Mac: Cmd+Space, "Terminal"). Mac: accept the Command Line
   Tools prompt or run `xcode-select --install`. Windows: git-scm.com, then use Git Bash.
3. Node LTS — nodejs.org → LTS installer → reopen Terminal → `node --version`.
4. Tell git who you are:
   git config --global user.name 'Your Name'
   git config --global user.email 'the email on your GitHub account'
5. Log in to GitHub for pushing — easiest: install GitHub CLI and run `gh auth login`.
   Or a fine-grained token (Settings → Developer settings → Personal access tokens, Contents:
   Read and write on this repo) pasted as the password on first push.
6. Make a folder, e.g. ~/Zamstars, and clone into it:  git clone <repo url>
7. Install the skills in your Claude (Cowork or Claude Code). Ask the owner.

## Your first session
Open the repo folder in Claude and say `setup`. It checks everything above and tells you what's
missing, then runs `catchup`, which tells you what this app is and where it stands.

Every session after: `catchup` at the start, `handoff` at the end, `decision` when a real choice
gets made. That's the whole ritual.

## How git commands get run
In Cowork, by default Claude hands you git commands to paste into your own Terminal and asks for
the output back — your Terminal already knows who you are and how to reach GitHub. If you'd
rather Claude run them itself, say so during `setup`.
```

**CLAUDE.md** — the Process and Code hard rules from `zamstars-ops`, verbatim, plus:
```markdown
New here? Read docs/ONBOARDING.md, then say `setup`.
Start every session with `catchup`. End every session with `handoff`.
Say `decision` to record one on the spot.

## If those words do nothing
You do not have the Zamstars skills. Ask <owner> for them. Until then, the minimum:
- Start: `git pull`; read README.md, STATE.md, and the top of DECISIONS.md.
- End: overwrite STATE.md with what is true now; add a DECISIONS entry if a real choice was
  made; commit; push. If commits fail, run `git config --global user.name` and `user.email` first.

## App-specific rules
**Cap: 10.** To add an eleventh, remove one. Each rule carries the date it was added.
1. (YYYY-MM-DD) <rule>
```