# <App name>

<One sentence: what it does, and for whom.>

## Status
`prototype` | `live` | `paused` | `deprecated`

## Run it
```bash
npm install
cp .env.example .env    # then fill in the values
npm run dev
```
<Anything else needed from a cold clone. Assume the reader knows nothing about us.>

## Stack
<e.g. Vite + React + TypeScript + Tailwind. Supabase for data and auth.>

## How it works (max 5 bullets)
-

## Where it runs
- Repo: <url>
- Deployed: <url, or "local only">
- Other surfaces: <workflow, sheet, endpoint, cron>

## Depends on
| Thing | Why | Who holds the account/key |
|---|---|---|
|  |  |  |

## Glossary
<Internal words a newcomer would misread. Delete if none.>

---
New here? Read `docs/ONBOARDING.md`, then say `setup`. Otherwise read `CLAUDE.md`, then say `catchup`.

<!--
DECAY: this file rots by becoming WRONG, not by growing. Every handoff cross-checks it:
- Do the scripts named under "Run it" still exist in package.json?
- Does every var in .env.example still appear in the code, and vice versa?
- Does the Depends-on table still match package.json and the connectors actually used?
A mismatch is a bug in this file. Fix it in the same handoff, do not defer it.
-->
