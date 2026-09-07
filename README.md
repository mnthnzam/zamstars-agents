# zamstars-claude

The Claude skills and templates Zamstars uses so people on separate Claude accounts can work on
the same app repos without losing context.

## Install (once per person)

In Claude Code:

```
/plugin marketplace add mnthnzam/zamstars-claude
/plugin install zamstars@zamstars
```

You need read access to this repo (ask Manthan to add you as a collaborator) and git must be
logged in to GitHub — `gh auth login` is the easy way. Then, in any Zamstars app repo, say
`setup` the first time and `catchup` / `handoff` every session after.

To pick up updates later: `/plugin marketplace update zamstars`.

## What's in here

| Path | What |
|---|---|
| `plugins/zamstars/skills/zamstars-ops/` | The everyday skill — `catchup`, `handoff`, `decision`. Core conventions. |
| `plugins/zamstars/skills/zamstars-setup/` | Onboarding from zero, joining or starting a repo, scaffolding. |
| `plugins/zamstars/skills/zamstars-groom/` | The deliberate maintenance pass. |
| `templates/` | The operating-layer files every app repo carries. |
| `SYSTEM.md` | Why the system is shaped the way it is — every decision and its reasoning. |

## The system in one paragraph

One repo per app. The repo is the source of truth; Claude is an editor, never a store. Four files
at the root of every app — `README.md`, `DECISIONS.md`, `STATE.md`, `CLAUDE.md` — plus a ledger
under `docs/`. Two rituals: `catchup` at the start of a session, `handoff` at the end. Say
`decision` when a real choice is made. No Claude Artifacts. Code is structured so a developer can
be handed it without apology. `SYSTEM.md` has the rest.

## Updating the skills

Skills are edited by Manthan in Claude, then copied here and pushed. Bump `version` in both
`.claude-plugin/marketplace.json` and `plugins/zamstars/.claude-plugin/plugin.json` when you do.
