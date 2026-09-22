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
