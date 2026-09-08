# catchup — start of session

0. Pre-flight (AGENTS.md). Any failure → `docs/agent/SETUP.md` first.
0.5 **Which repo?** Zamstars people run several apps at once; this ritual acts on exactly one.
   Scan for the rest. `ROOT` is `.` when the current folder has no `AGENTS.md`, otherwise `..`:
   ```
   for d in "$ROOT"/*/; do
     [ -f "$d/docs/agent/CATCHUP.md" ] || continue
     printf '%s | state %s | code %s | active %s\n' "$(basename "$d")" \
       "$(sed -n 's/^Updated: *//p' "$d/STATE.md" 2>/dev/null | head -1)" \
       "$(git -C "$d" log -1 --format=%cs 2>/dev/null)" \
       "$(sed -n 's/^Active: *//p' "$d/STATE.md" 2>/dev/null | head -1)"
   done; true
   ```
   The test is `docs/agent/CATCHUP.md`, not a title string: an app is a repo that carries the
   rituals. The tooling repo `zamstars-agents` has no `docs/agent/`, so it never appears — right,
   it is not an app. Nothing is pulled here, so every date is local and a repo may be further
   ahead on its remote — say so whenever you report one.
   - **No `AGENTS.md` in the current folder** — you are standing in the parent, not in an app.
     Print the scan as a table, mark every repo whose state date is behind its code date, and ask
     which to enter. Do **not** run SETUP: nothing is broken, the only missing thing is which repo.
     Scan finds nothing → *then* it is SETUP.
   - **`AGENTS.md` present** — continue from step 1 here. Keep the scan; step 6 uses it.
   - **In a repo but the scan finds nothing** — the apps are not siblings. Continue, drop the
     roster line at step 6, and say once that you cannot see the others from here.

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
   - **Other repos going stale** — from the 0.5 scan, excluding this one: only repos whose state
     date is behind their code date, or whose newest commit is over 14 days old. One line each, worst first. Nothing
     tripped → omit this heading entirely. It is the only place anyone sees a repo they did not
     open, and the repo rotting hardest is always the one nobody opens.
   - **Currently held by** — the Active line (this repo)
   - **What isn't written down** — specific gaps you hit while reading. Name them.
7. Claim it: set `Active:` to this person and today's date; commit `chore: claim <app>`; push
   (terminal mode: one block, add + commit + push).
