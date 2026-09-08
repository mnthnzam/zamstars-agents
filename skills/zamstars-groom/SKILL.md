---
name: zamstars-groom
description: "Zamstars maintenance pass. Use when the user says groom, 'is this repo rotting', or when catchup reports STATE.md stale by more than two weeks. Full decay pass, Revisit-if and Where checks on every active decision, propose-don't-apply."
---

> **Generated from `agent/` in github.com/mnthnzam/zamstars-agents by build.sh — do not edit here.**
> If the repo you are in has `AGENTS.md`, that file and `docs/agent/` are authoritative and may be newer than this skill. Read and follow them; use the text below only when no repo exists yet.

# groom — the deliberate maintenance pass

Runs when a person asks, or when catchup finds STATE more than 14 days behind the code. No
calendar job: a scheduled clean-up fires whether or not anyone is working and gets ignored the
same way a stale doc does. It inspects everything, reports everything, and **proposes removals
rather than making them.**

0. Pre-flight. `git pull --ff-only` (terminal mode: hand over).
1. **Run every decay check in `docs/agent/SHAPES.md` and report all of them**, including the
   ones that passed, so the user can see the whole file set was actually inspected.
2. **Read each operating-layer file against the actual code**, not against itself. Name every
   claim that is no longer true, with the file and line that contradicts it.
3. **Walk every active DECISIONS entry.** Is its `Revisit if` true now — answer it as a yes/no
   from evidence in the repo or from the user. Does its `Where:` path still exist — `ls` it. A
   yes to the first or a no to the second is a candidate for SUPERSEDED or OBSOLETE. List them
   with evidence. Mark nothing yet.
4. **Audit app-specific rules in AGENTS.md.** Any rule not referenced by a commit message or a
   DECISIONS entry in six months is a candidate for removal. `git log --grep` on a keyword from
   the rule is a cheap proxy.
5. **Structure sweep** — run the check in `docs/agent/STRUCTURE.md` over the whole tree, minus
   its exemptions, plus a look for imports pointing sideways between `features/*` or upward.
   Also check the trend: a file that was 180 lines last groom and is 195 now will trip next
   month, and splitting it now is cheaper than splitting it under pressure. Report violations
   as candidates for `Broken / risky` bullets, not as things to fix now.
6. **Propose; do not apply.** One numbered list: what you would cut, move, mark, split or
   rewrite, one line of reasoning each, grouped by file. Wait for approval by number. Apply
   exactly those.
7. Every STATE bullet removed gets a ledger line. Every DECISIONS change is a status line only.
   Archived entries leave a one-line linked stub.
8. Commit `chore: groom operating layer`. Push. Report what changed and what was declined.

Never: delete a decision, a ledger line, or a STATE bullet without a ledger line; apply an
unapproved removal; resolve someone else's PROPOSED entry; fix code — groom reports structure
violations, fixing is its own session.


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

