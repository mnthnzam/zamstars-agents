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
