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
