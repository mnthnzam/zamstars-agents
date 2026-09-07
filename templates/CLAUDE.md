# Operating contract — <App name>

This repo is the source of truth. Claude is an editor, never a store.

New here? Read docs/ONBOARDING.md, then say `setup`. Start every session with `catchup`. End every session with `handoff`.
Say `decision` to record one on the spot — Claude drafts it from the conversation; you say yes.

## If those words do nothing
You do not have the Zamstars skills (`zamstars-ops`, `zamstars-setup`). Ask <owner> for them. Until then, the minimum:
- Start: `git pull`; read README.md, STATE.md, and the top of DECISIONS.md.
- End: overwrite STATE.md with what is true now; add a DECISIONS entry if a real choice was
  made; commit; push. If commits fail, run `git config --global user.name` and `user.email` first.

## Non-negotiable
1. **Nothing ships that isn't committed.** A change made only in a chat does not exist.
2. **`STATE.md` is overwritten** every handoff. It is a snapshot; it never grows.
3. **`DECISIONS.md` is append-only.** Never edit or delete a past entry.
4. **Never force-push. Never silently resolve a merge conflict.** Surface it and stop.
5. **Never hardcode a secret.** All config via `.env`; `.env.example` is committed, `.env` is not.

## Code structure — these are hard limits, not preferences

The point is that a developer who has never seen this repo can find anything in 60 seconds
and change one thing without reading everything.

- **No source file over 200 lines.** At 300 it is a bug: split it before committing.
- **No function over 50 lines.**
- **One exported thing per file**, named the same as the file.
- **No business logic inside UI components.** Components render and call; logic lives in `lib/`
  or the feature's own module.
- **No inline `<script>` or `<style>` in HTML. No `onclick=` attributes.**
- **Imports point downward only:** `pages → features → lib → types`.
  Never sideways between features, never upward. If two features need the same thing,
  it moves down into `lib/` or `components/`.
- **`features/` is the default home.** `components/` is only for something used by 2+ features.

## Layout
```
CLAUDE.md  README.md  DECISIONS.md  STATE.md
.env.example
package.json
index.html
src/
  main.tsx          entry — wiring only, no logic
  App.tsx           routing and layout only
  pages/            one file per screen
  features/<name>/  a feature owns its own components, logic and types
  components/       shared, dumb, no business logic
  lib/              pure functions, API clients — no UI
  types/
  styles/
public/
```

## App-specific rules

**Cap: 10 rules.** To add an 11th, remove one. Each rule carries the date it was added.
A rule nobody has referenced in six months is a candidate for removal at the next `groom`.
Rule bloat is how this file stops being read.

1. (YYYY-MM-DD) <rule>
