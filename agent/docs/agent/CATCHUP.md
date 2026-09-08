# catchup — start of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first.
1. `git pull --ff-only` (terminal mode: hand over, paste back). Diverged or failed → **stop**,
   show the state, ask. Never auto-merge.
2. Read `README.md`, `STATE.md`, the newest ~10 entries of `DECISIONS.md` plus every entry
   marked `> PROPOSED`, and the newest ~15 lines of `docs/LEDGER.md`.
3. **Staleness check.** Compare `STATE.md`'s `Updated:` date to `git log -1 --format=%cs`. If
   STATE is older, say so **first and prominently** — the operating layer is behind the code and
   everything below may be wrong. This is the system's main enforcement; do not soften or bury
   it. Stale by more than 14 days → offer `docs/agent/GROOM.md`.
4. Commits since this person last touched it: `git log --oneline <their-last-sha>..HEAD` if
   their name appears in the log, otherwise `git log --oneline -20`.
5. Read the `Active:` line. Held by someone else recently → say so and ask before claiming.
6. Report in exactly this shape, nothing else:
   - **What this is** — one line from README
   - **Since you last looked** — commits in plain language, grouped by what actually changed
   - **Finished / dropped** — from the ledger; call dropped items out with their reason, that is
     what stops someone re-proposing rejected work
   - **In flight / broken / next** — from STATE
   - **Decisions you may not know about** — entries newer than their last commit
   - **Open proposals** — every `> PROPOSED` entry, who pitched it, what it would supersede
   - **Currently held by** — the Active line
   - **What isn't written down** — specific gaps you hit while reading. Name them.
7. Claim it: set `Active:` to this person and today's date; commit `chore: claim <app>`; push
   (terminal mode: one block, add + commit + push).
