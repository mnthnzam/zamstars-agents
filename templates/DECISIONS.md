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
