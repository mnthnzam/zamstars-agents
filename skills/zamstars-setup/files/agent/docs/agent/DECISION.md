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
