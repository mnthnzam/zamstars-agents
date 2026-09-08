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
5. **Structure sweep** — the handoff `find … wc -l` check over the whole tree, plus a look for
   imports pointing sideways between `features/*` or upward. Report violations as candidates
   for `Broken / risky` bullets, not as things to fix now.
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

