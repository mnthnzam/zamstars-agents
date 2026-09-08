# STATE — zamstars-agents

Updated: 2026-09-08 by Manthan
Active: none
Branch: main

## In flight — half-done, do not touch without talking to Active
- none

## Broken / risky — known bad right now
- (09-08) Two commits already on `origin/main` carry agent attribution — `8b755e6` (trailers) and `4e33e71` (session link in the subject). Cleaning them needs a force-push, which `AGENTS.md` forbids; the cheap window closes once anyone else clones
- (09-08) The system has never run in a non-Claude agent. The `AGENTS.md` trigger table is untested in Cursor, Codex or Gemini CLI — the whole "universal" claim rests on it
- (09-08) `SYSTEM.md` and `DECISIONS.md` now describe overlapping reasoning. SYSTEM is declared frozen, but nothing enforces that

## Next up — safe to pick up cold
- (09-08) Test the trigger table in one non-Claude agent — clone an app repo in Cursor or Codex, say `catchup`, see whether it opens the file
- (09-08) `templates/README.md` detail pass — low priority, it is the least-used template
- (09-08) Decide whether `zamstars-ops` should split — it is ~365 lines because it carries STRUCTURE.md, which `catchup` and `decision` never need

## Open questions — best place to pitch in
- (09-08) Should this repo carry `docs/ONBOARDING.md`? Its README already covers install; a second onboarding doc may just be a place to drift
- (09-08) Do the decay thresholds (14/30 days, 12 bullets, 40 entries) match reality? They were guesses and no repo has run long enough to test one
