# handoff — end of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first, so the push at the end
   cannot surprise anyone.
1. `git status --short`, `git diff`, `git diff --cached`. Summarize **what changed** from the
   diff, not from memory of the session.
2. **Structure check.** From the repo root:
   ```
   find src -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.css' \) -exec wc -l {} + | sort -rn | head -20
   ```
   Over 300 lines: split now, before committing — not a follow-up. Over 200: say so, propose the
   split, proceed only if the user declines, and record that as a DECISIONS entry. Also flag:
   logic in a UI component, inline `<script>`/`<style>`, `onclick=`, a hardcoded secret, an import
   pointing sideways between features or upward.
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
   status output — never `git add -A`. Terminal mode: one block per commit ending with
   `git pull --rebase && git push`; ask for the output pasted back.
9. `git pull --rebase`, push. Conflict → stop and surface it. Auth failure → SETUP.md step F4.
10. Report: what was committed, what was pushed, what still needs a human.
