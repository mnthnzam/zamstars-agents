---
name: zamstars-ops
description: "Zamstars everyday operating layer. Use when the user says catchup / sync in, handoff / wrap up, or decision, or is working inside a Zamstars app repo. Start- and end-of-session git rituals in direct or terminal mode, decisions captured as they happen, codebase structure limits and how to split a file without making it worse. Core conventions."
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

# structure — the code limits, and what they are actually for

## Why there is a limit at all

Zamstars apps get handed to developers. The thing developers refuse to inherit is not a big
codebase, it is a file nobody can hold in their head — the 900-line `App.tsx` where every
feature touches every other one. That file is also the file an agent cannot edit surgically:
asked to change one thing it rewrites the whole file, and the diff is unreviewable, so nobody
reviews it, so the next agent inherits whatever the last one guessed.

The limits exist to keep two things true: **a human who did not write the file can read it in
one sitting**, and **an agent can change part of it without rewriting all of it.**

## The numbers

| Limit | Threshold | What happens |
|---|---|---|
| Source file | **200 lines** | Say so, propose the split. Proceed only if the user declines — and record the decline as a DECISIONS entry. |
| Source file | **300 lines** | Hard fail. Split before committing, not as a follow-up. |
| Function | **50 lines** | Same as 200: propose, don't force. |
| Exports per file | **1** | Named the same as the file. `types/` is exempt (below). |

200 is about three screens — roughly what a reviewer holds in working memory before they start
scrolling back. 300 is where "I'll read it later" becomes "I'll trust it." Neither number is
sacred; they are the point where a conversation should happen, not a law of nature.

## The limit is a proxy, and it is gameable

Line count measures size, not the thing that actually matters. **Two 130-line files that must
always be edited together are worse than one 260-line file** — you have paid the cost of a split
and bought nothing, and now the reader has to hold two files instead of one.

The rule the count is standing in for: **a file has one reason to change.** When the count trips,
that is the question to ask. If the honest answer is "this file has one job and the job is big",
say so and record it. Gaming the number to make the check pass is worse than failing the check.

## How to split — in this order

1. **Pull pure logic down to `lib/`.** The part that takes data and returns data, with no React
   in it. This is the split that pays every time: it is testable, reusable, and it shrinks the
   component by more than you expect.
2. **Pull out a sub-view.** A block of JSX with its own props and no shared local state. If it
   needs three pieces of the parent's state passed down, it is not a seam — leave it.
3. **Pull state into a hook.** `useThing.ts` beside the feature. Good when the file is long
   because of effects and handlers, not markup.
4. **Split the file by job.** If it is doing two things — a list and an editor — those were
   always two files.

Never split top-half / bottom-half to get under a number. Never create `utils.ts`, `helpers.ts`
or `misc.ts`; a file named for where things go instead of what they do becomes the next dumping
ground.

**Signs you split badly:** the new file exports six things the old one imports; the two files
appear together in every commit from now on; the new file is named `<Original>Helpers`.

## Exempt from the line count

- **Generated files** — `*.gen.ts`, generated Supabase types, lockfiles. Regenerate, don't edit.
- **`src/types/`** — type declarations with no behavior. Multiple exports allowed here.
- **SQL migrations** — append-only and never edited after they run; splitting one breaks ordering.
- **Data literals** — a long constant array is a table, not logic. It still gets its own file.
- **Test fixtures.**

That is the whole list. A sixth exemption is a DECISIONS entry, not a judgment call in the moment.

## How it is checked

From the repo root, at every handoff and in every groom:

```
find . -path ./node_modules -prune -o -path ./dist -prune -o -path ./.git -prune -o \
  -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.css' \) \
  -print0 | xargs -0 wc -l | sort -rn | head -20
```

Read the top of that list against the exemption list before reporting anything.

**Known weakness:** there is no cheap portable command for the 50-line function rule, so it is
checked by eye on the longest files from the list above. It is therefore the limit most likely
to rot. If a file is under 200 lines and still unreadable, one giant function is usually why.

## Import direction

`pages → features → lib → types`. Downward only.

- Never sideways between two `features/*`. Two features needing the same thing means the thing
  belongs **below** both of them — move it to `lib/` or `components/`.
- Never upward. A `lib/` file that imports from `features/` has stopped being a library.
- `features/` is the default home for new code. `components/` is only for what two or more
  features already use — not what you think they might.

Sideways imports are what turn a structured repo back into the single-file app, one shortcut at
a time, and they are invisible in a line count. They are worth more attention than the numbers.

## When someone declines a split

Record it as a DECISIONS entry with the real reason. That entry is what stops the same argument
happening again in three weeks. **Declining twice on the same file means the limit is wrong for
this repo** — change the number once, in the app-specific rules in `AGENTS.md`, with a decision
explaining why. Do not leave a rule in place that the team routinely ignores; a rule everyone
overrides teaches that all the rules are optional.


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
2. **Structure check — open `docs/agent/STRUCTURE.md` and follow it.** It carries the command,
   the exempt files, and how to split. In short: over 300 lines, split before committing, not as
   a follow-up; over 200, propose the split and record a DECISIONS entry if the user declines.
   Check the list against the exemptions before reporting — flagging a generated types file
   teaches the team to ignore you. Also flag: logic in a UI component, inline `<script>`/
   `<style>`, `onclick=`, a hardcoded secret, an import pointing sideways between features or
   upward.
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

