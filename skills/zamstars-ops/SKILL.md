---
name: zamstars-ops
description: "Zamstars everyday operating layer. Use when the user says catchup / sync in, handoff / wrap up, or decision, or is working inside a Zamstars app repo. Start- and end-of-session git rituals in direct or terminal mode, decisions captured as they happen, codebase structure limits. Core conventions."
---

> **Generated from `agent/` in github.com/mnthnzam/zamstars-agents by build.sh — do not edit here.**
> If the repo you are in has `AGENTS.md`, that file and `docs/agent/` are authoritative and may be newer than this skill. Read and follow them; use the text below only when no repo exists yet.

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
- One exported thing per file, named the same as the file.
- No business logic in UI components — components render and call; logic lives in `lib/` or the
  feature's own module.
- No inline `<script>`/`<style>`, no `onclick=`.
- **Imports point downward only:** `pages → features → lib → types`. Never sideways between
  features, never upward. Shared by two features → move it down to `lib/` or `components/`.
- `features/` is the default home; `components/` only for things used by 2+ features.
- Secrets in `.env` only. `.env.example` committed, `.env` never.
- Default stack: Vite + React + TypeScript + Tailwind; Supabase for data and auth.

## App-specific rules

Cap: 10. To add an eleventh, remove one. Each carries the date it was added.

1. (YYYY-MM-DD) <rule>

## If none of the words above do anything

You are an agent without these files loaded. Minimum discipline: at start, `git pull` and read
`README.md`, `STATE.md`, the top of `DECISIONS.md`. At end, overwrite `STATE.md` with what is
true now, add a DECISIONS entry if a real choice was made, commit, push.


---

# Shapes of the operating-layer files

**STATE.md** — live, open items only. Rewritten wholesale at every handoff.
```markdown
# STATE — <app>
Updated: <YYYY-MM-DD> by <name>
Active: <name (since YYYY-MM-DD)> | none
Branch: <branch>

## In flight — half-done, do not touch without talking to Active
- (MM-DD) <what was started, and what's left>
## Broken / risky — known bad right now
- (MM-DD) <symptom> → <suspected cause>
- (MM-DD) Don't touch: <file or area> — <why>
## Next up — safe to pick up cold
- (MM-DD) <task> — <the one thing you need to know to start>
## Open questions — best place to pitch in
- (MM-DD) <question> — <what a good answer would unblock>
```
Every bullet keeps the `(MM-DD)` it first appeared, carried forward unchanged — that turns "is
this stale?" into subtraction. Max 3 per section, 12 in the file; one line each; `- none` for an
empty section; never delete a heading; never write history here.

**docs/LEDGER.md** — everything that left STATE. Newest first under `## <year>`. Append-only.
```
- <date left> <verb> (<date entered>) <the bullet> — <why> [<short sha>, for done]
- 09-07 done     (09-02) auth redirect bug — guard ran before session restore [a1b2c3d]
- 09-07 dropped  (08-14) CSV export — nobody asked for it in three weeks
```
Verbs, exactly four: **done · dropped · answered · moved**. Both dates always — the gap is how
long the item lived. A `dropped` or `answered` item with real reasoning goes to DECISIONS; the
ledger line points there. Split by year into `docs/ledger-<year>.md` when it grows.

**DECISIONS.md entry** — newest at top. Body ≤12 lines. Title is a statement, not a topic.
```markdown
## YYYY-MM-DD [tag] — <the decision, stated as a fact>
**Context:** <what forced the choice — 1 to 3 lines>
**Chose:** <what we did>
**Rejected:** <what we didn't — one reason each; only alternatives actually discussed>
**Revisit if:** <a condition someone could answer yes/no to today>
**Where:** <file or folder this lives in — optional>
```
Tags, exactly one: `[stack] [data] [auth] [ui] [infra] [process] [scope]` — so
`grep '\[auth\]'` finds everything about auth.

Status lines — the **only** permitted change to a past entry, added at its top:
```
> PROPOSED   YYYY-MM-DD by <name>                — a pitch, not yet in force
> SUPERSEDED YYYY-MM-DD by <newer entry title>   — replaced; the newer entry carries the argument
> OBSOLETE   YYYY-MM-DD — <why>                  — the code it described no longer exists
> REJECTED   YYYY-MM-DD by <name> — <why>        — a proposal that did not land
```
No status line = active. To pitch against an active decision: write a *new* entry marked
PROPOSED, leave the old one alone; CATCHUP shows every PROPOSED entry to everyone until the owner
resolves it. Never resolve someone else's proposal without asking.

**Decay thresholds** (checked at handoff, acted on only when tripped): STATE in-flight bullet
>14 days = abandoned, move or drop; any bullet >30 days = confirm or drop; >12 bullets = cut.
DECISIONS >800 lines or 40 entries = archive superseded/obsolete/rejected to
`docs/decisions-<year>.md` with a stub; PROPOSED >30 days = nag the owner. App-specific rules
>10 = remove one to add one. Nothing is ever deleted — demoted, not destroyed.


---

# catchup — start of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first.
1. `git pull --ff-only` (terminal mode: hand over, paste back). Diverged or failed → **stop**,
   show the state, ask. Never auto-merge.
2. Read `README.md`, `STATE.md`, the newest ~10 entries of `DECISIONS.md` plus every entry
   marked `> PROPOSED`, and the newest ~15 lines of `docs/LEDGER.md`.
3. **Staleness check.** Compare `STATE.md`'s `Updated:` date to `git log -1 --format=%cs`. If
   STATE is older, say so **first and prominently** — the operating layer is behind the code and
   everything below may be wrong. This is the system's main enforcement; do not soften or bury
   it. Stale by more than 14 days → offer `docs/agent/GROOM.md`.
4. Commits since this person last touched it: `git log --oneline <their-last-sha>..HEAD` if
   their name appears in the log, otherwise `git log --oneline -20`.
5. Read the `Active:` line. Held by someone else recently → say so and ask before claiming.
6. Report in exactly this shape, nothing else:
   - **What this is** — one line from README
   - **Since you last looked** — commits in plain language, grouped by what actually changed
   - **Finished / dropped** — from the ledger; call dropped items out with their reason, that is
     what stops someone re-proposing rejected work
   - **In flight / broken / next** — from STATE
   - **Decisions you may not know about** — entries newer than their last commit
   - **Open proposals** — every `> PROPOSED` entry, who pitched it, what it would supersede
   - **Currently held by** — the Active line
   - **What isn't written down** — specific gaps you hit while reading. Name them.
7. Claim it: set `Active:` to this person and today's date; commit `chore: claim <app>`; push
   (terminal mode: one block, add + commit + push).


---

# handoff — end of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first, so the push at the end
   cannot surprise anyone.
1. `git status --short`, `git diff`, `git diff --cached`. Summarize **what changed** from the
   diff, not from memory of the session.
2. **Structure check.** From the repo root:
   ```
   find src -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.css' \) -exec wc -l {} + | sort -rn | head -20
   ```
   Over 300 lines: split now, before committing — not a follow-up. Over 200: say so, propose the
   split, proceed only if the user declines, and record that as a DECISIONS entry. Also flag:
   logic in a UI component, inline `<script>`/`<style>`, `onclick=`, a hardcoded secret, an import
   pointing sideways between features or upward.
3. **Decay check** against the thresholds in `docs/agent/SHAPES.md`. Raise only what tripped;
   say nothing about what passed. Also cross-check README: do the "Run it" scripts exist in
   `package.json`? Do `.env.example` vars match what the code reads (`import.meta.env` /
   `process.env`), both directions? Does Depends-on match `package.json`? A mismatch is a bug in
   the README — fix it now.
4. **Decision sweep — backstop only.** Decisions should already be staged from DECISION.md
   during the session. Re-read the conversation once for anything missed; apply both tests; if
   something qualifies, run DECISION.md for it now. Do not pad. If nothing qualifies, say nothing.
5. **Rewrite `STATE.md` wholesale** per SHAPES.md — live items only, dates carried forward,
   caps respected, `- none` for empty sections, headings never deleted. Update `Updated:` and
   `Branch:`; `Active: none` unless the person says they're continuing.
6. **Every bullet that left STATE gets a ledger line** in `docs/LEDGER.md` per SHAPES.md. A
   bullet may never simply vanish. If you cannot say which of the four verbs applies, ask.
7. Touch `README.md` only if how-to-run, stack, where it runs, or dependencies changed — or
   step 3 found a mismatch.
8. Commit: `<verb>: <what> — <why>`. One commit per logical change. Add **named files** from the
   status output — never `git add -A`. Terminal mode: one block per commit ending with
   `git pull --rebase && git push`; ask for the output pasted back.
9. `git pull --rebase`, push. Conflict → stop and surface it. Auth failure → SETUP.md step F4.
10. Report: what was committed, what was pushed, what still needs a human.


---

# decision — record one now

The *why* is the most perishable thing in a session. Long sessions get compacted; the diff
survives, the conversation where an alternative was rejected may not. So decisions are written
**the moment they land**, not at handoff. Stage the edit; handoff commits it.

## Two tests — both must pass, or there is no entry
- **Reader test:** would a developer reading this code in six months ask "why on earth did they
  do it this way?" Self-explanatory code → no entry.
- **Mechanical test:** if **Rejected** would be empty, it is a task, not a decision. No entry.

**Rejected may only list alternatives actually on the table in this session.** Never invent a
straw alternative to make an entry look complete. One path discussed → no entry.

## Procedure
1. Draft from the conversation, in the DECISIONS shape from `docs/agent/SHAPES.md`: one tag,
   Context in 1–3 lines, Chose, Rejected with one reason each, a `Revisit if` someone could
   answer yes/no to **today** ("if a second client signs" — not "if we scale"), `Where:` when the
   decision has a physical home. Body ≤12 lines. Title is a statement, not a topic.
2. Show the draft in two or three lines and ask for a yes. The user is the authority on what was
   decided; you are the scribe.
3. On yes: insert at the top of `DECISIONS.md`. If it contradicts an active entry, add
   `> SUPERSEDED <date> by <new title>` to that entry's top. If the user is *proposing* against
   someone else's decision rather than making one, mark the new entry `> PROPOSED <date> by
   <name>` and leave the old one alone.
4. Stage `DECISIONS.md` (terminal mode: fold into handoff's block). Do not commit — handoff does.


---

