---
name: zamstars-groom
description: "Zamstars maintenance pass. Use when the user says groom, 'clean up the docs', 'is this repo rotting', or when catchup reports STATE.md stale by more than two weeks. Walks every decay rule, checks each active decision's Revisit-if and Where against the code, archives what has expired, proposes removals and applies only what is approved."
---

# Zamstars groom — the deliberate maintenance pass

**Load `zamstars-ops` first.** It carries the git-mode protocol, pre-flight, hard rules, the
file shapes, and the *cheap* decay checks that `handoff` runs silently. This skill is the full,
noisy version: it inspects everything, reports everything, and **proposes removals rather than
making them.**

Principle, unchanged: cleansing never means automatic deletion. Things are demoted, not
destroyed. Never remove operating-layer content the user has not seen and agreed to lose.

No calendar job runs this. A scheduled clean-up fires whether or not anyone is working and gets
ignored the same way a stale doc does. It runs when a person asks, or when `catchup` finds the
operating layer more than two weeks behind the code.

## Procedure

0. Fast pre-flight from `zamstars-ops`. `git pull --ff-only` (terminal mode: hand over).
1. **Run every decay check and report all of them**, including the ones that passed, so the
   user can see the whole file set was actually inspected:
   - **STATE.md** — every bullet's `(MM-DD)` age. In-flight >14 days = abandoned; any >30 days = confirm or drop; >12 bullets = backlog. Each removal needs a ledger line and a verb (done / dropped / answered / moved); if the verb is unclear, ask.
   - **DECISIONS.md** — line and entry count vs 800 / 40. Any `> PROPOSED` older than 30 days. Superseded / obsolete / rejected entries eligible for `docs/decisions-<year>.md` (active and PROPOSED never leave).
   - **docs/LEDGER.md** — more than one year present? Split older years into `docs/ledger-<year>.md`.
   - **README.md** — "Run it" scripts vs `package.json`; `.env.example` vars vs `import.meta.env` / `process.env` in the code, both directions; Depends-on vs `package.json` and connectors actually used.
   - **CLAUDE.md** — app-specific rule count vs 10.
2. **Read each operating-layer file against the actual code**, not against itself. Name every
   claim that is no longer true, with the file and line that contradicts it.
3. **Walk every active DECISIONS entry.** For each:
   - Is its `Revisit if` condition **true now**? Ask it as a yes/no question and answer from evidence in the repo or from the user.
   - Does its `Where:` path still exist? `ls` it.
   - A yes to the first or a no to the second makes it a candidate for `> SUPERSEDED` or `> OBSOLETE`. List them with the evidence. Do not mark anything yet.
4. **Audit CLAUDE.md app-specific rules.** Any rule not referenced by a commit message or a
   DECISIONS entry in six months is a candidate for removal. `git log --grep` on a keyword from
   the rule is a cheap proxy. List them.
5. **Structure sweep** — the same `find src … wc -l` check as handoff, over the whole tree, plus
   a look for imports pointing sideways between `features/*` or upward. Report violations as
   candidates for `Broken / risky` bullets, not as things to fix now.
6. **Propose; do not apply.** Present one numbered list: what you would cut, move, mark, split or
   rewrite, one line of reasoning each, grouped by file. Wait for the user to approve items by
   number. Apply exactly those.
7. Every STATE bullet removed gets a ledger line. Every DECISIONS status line added is a status
   line only — bodies are never edited. Archived entries leave a one-line linked stub.
8. Commit `chore: groom operating layer` (terminal mode: one block). Push. Report what changed
   and what the user declined.

## What groom must never do
- Delete a decision, a ledger line, or a STATE bullet without a ledger line.
- Apply a removal the user did not approve by number.
- Resolve someone else's `> PROPOSED` entry — flag it for the owner instead.
- Fix code. Groom reports structure violations; fixing is a session of its own with its own handoff.