# handoff — end of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first, so the push at the end
   cannot surprise anyone.
1. `git status --short`, `git diff`, `git diff --cached`. Summarize **what changed** from the
   diff, not from memory of the session.
   Any status line you will not commit belongs to someone else's in-flight work. Name it in the
   report; never stash, add or revert it.
2. **Structure check — open `docs/agent/STRUCTURE.md` and follow it.** It carries the command,
   the exempt files, and how to split. In short: over 800 lines, split before committing, not as
   a follow-up; over 500, propose the split and record a DECISIONS entry if the user declines.
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
   status output — never `git add -A`. Terminal mode: one block per commit, `add` + `commit`
   only — **no pull or push until the last commit is made.** `git pull --rebase` refuses while
   anything is unstaged, so a pull attached to the first of several commits fails on the files
   the later commits still hold. Ask for the output pasted back after each.
9. After the final commit, once: `git pull --rebase --autostash`, then push. Skip the pull if
   nobody else pushes to the repo and you are already in sync. `--autostash` carries foreign
   changes across the pull and restores them; if the restore conflicts, git leaves them stashed
   and says so — that is a stop-and-surface, not a fix. Conflict → stop and surface it. Auth
   failure → SETUP.md step F4.
10. Report: what was committed, what was pushed, what still needs a human.
