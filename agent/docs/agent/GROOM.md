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
