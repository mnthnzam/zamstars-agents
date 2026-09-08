# Zamstars operating layer — system skeleton

> **Frozen background, 2026-09-08.** This is the narrative record of the design sessions that
> produced the system, kept because the arguments in it are worth reading. It is **not** the
> decision record: no tags, no status lines, no `Revisit if`, and it only grows. The record is
> `DECISIONS.md`; entries there link back to sections here. **Do not append to this file.**
> Parts of it describe superseded designs (three git modes, `CLAUDE.md` as the always-on file) —
> where it disagrees with `agent/AGENTS.md` or `DECISIONS.md`, those win.

One repo per app. The repo is the source of truth. Claude is an editor, never a store.

## The four files (repo root)

| File | The one question it answers | Mutability | Written by |
|---|---|---|---|
| `README.md` | What is this, how do I run it, where does it run, what does it depend on? | Edited, rarely | `handoff`, only when it changed |
| `DECISIONS.md` | Why is it built this way? What was tried and rejected? | **Append-only** | `handoff`, only when a real choice was made |
| `STATE.md` | What is true *right now* — in flight, broken, next, who holds it? | **Overwritten every time** | `handoff`, every session |
| `CLAUDE.md` | How must Claude behave in this repo? | Edited, rarely | Humans |

`updates.md` was deliberately cut. `git log` plus `DECISIONS.md` cover it, and an append-only
changelog becomes unreadable within a month.

## The two rituals

- **`catchup`** — pull, read the operating layer, read commits since your last one, report,
  claim the work. Run at the start of every session.
- **`handoff`** — summarize the diff, append a decision if one was made, rewrite `STATE.md`,
  commit, push, release the claim. Run at the end of every session.

Both live in the `zamstars-ops` skill so they behave identically in Cowork and Claude Code.

## Enforcement: read-time, not write-time

No git hooks. A hook cannot fire if someone never pushes, which is the actual failure mode.
Instead `catchup` runs a **staleness check**: if `STATE.md`'s `Updated:` date is older than
the newest commit, it says so loudly before doing anything else. Drift gets caught by the
next person to sit down, which is the only moment anyone is motivated to fix it.

Revisit this if the staleness warning starts getting ignored — that's the trigger for hooks.

## Working from Cowork

`git` is available in the Cowork shell and has network access, but `$HOME` there is
**session-scoped** — SSH keys and global git config do not survive between sessions.
So credentials must live inside the repo folder on your Mac, which does persist.

One-time per repo, from a Cowork session:

```
cd ~/mnt/<Folder>/<repo>
printf 'https://<github-username>:<PAT>@github.com\n' > .git/.cw-credentials
chmod 600 .git/.cw-credentials
```

`.git/` is never committed, so the token never leaves your machine. Then push with:

```
git -c credential.helper='store --file=.git/.cw-credentials' push
```

Passing it per-command (`-c`) rather than writing it into `.git/config` avoids clashing with
the macOS keychain helper Claude Code uses on the same repo. In Claude Code on the Mac,
your existing git credentials work as-is — no setup.

## Repo layout

```
<app-repo>/
  CLAUDE.md  README.md  DECISIONS.md  STATE.md
  .env.example  package.json  index.html
  src/
    main.tsx          entry — wiring only
    App.tsx           routing and layout only
    pages/            one file per screen
    features/<name>/  a feature owns its components, logic, types
    components/       shared, dumb, no business logic
    lib/              pure functions, API clients — no UI
    types/  styles/
  public/
```

## Code structure limits

We do not use Claude Artifacts. Apps are normal repos, built to be handed to a developer
without apology. These are hard limits, enforced by `handoff`, not style preferences:

- No source file over **200 lines** (hard fail at 300). No function over **50 lines**.
- One exported thing per file, named the same as the file.
- No business logic in UI components.
- No inline `<script>`/`<style>`, no `onclick=` attributes.
- **Imports point downward only:** `pages → features → lib → types`. Never sideways between
  features, never upward. This is the rule that actually prevents spaghetti; the line limits
  are just the cheap proxy for it.
- `features/` is the default home. `components/` is only for things used by 2+ features.
- Secrets in `.env` only. `.env.example` committed, `.env` never.

## Still to sharpen
Each of the four templates is a skeleton. Next pass: work through them one at a time.

## Decay: how each file stays clean

"Self-cleansing" here never means automatic deletion. Each file has a **decay rule** and a
**destination for what it sheds** — things are demoted, not destroyed. The check is cheap and
runs every `handoff`; it stays silent until a threshold trips.

| File | What actually rots | Threshold | What happens |
|---|---|---|---|
| `STATE.md` | Bullets that quietly stop being true | In-flight bullet > 14 days; any bullet > 30 days; > 12 bullets total | Forced decision: move it, or delete it. History is in git, so nothing is lost. |
| `DECISIONS.md` | Unbounded growth | > 800 lines or > 40 entries | Superseded/obsolete entries move to `docs/decisions-<year>.md`, leaving a linked stub. Active entries never leave. |
| `README.md` | Becoming **wrong**, not long | Any mismatch | Cross-checked against `package.json`, `.env.example` and the code every handoff. Mismatch = fix now. |
| `CLAUDE.md` | Rule bloat nobody reads | > 10 app-specific rules | To add one, remove one. |

Every `STATE.md` bullet carries the date it first appeared, `(MM-DD)`, carried forward across
rewrites. That single change turns "is this stale?" from a judgment call into subtraction —
for a human reading the file, not just for Claude.

`groom` runs the full pass deliberately: the same checks plus a read of every file against the
actual code, and it proposes removals rather than making them.

**Why no calendar job.** A monthly scheduled clean-up fires whether or not anyone is working,
and gets ignored the same way a stale doc does. The checks ride on `handoff` instead, which
only happens when someone actually touched the repo — the one moment the context to judge a
bullet is in the room.

## Where completed bullets go

`STATE.md` holds only **live, open items**. Anything that stops being live moves to
`docs/LEDGER.md` — one line, newest first, written by `handoff`, never by hand:

```
09-07 done     (09-02) auth redirect bug — session wasn't restored before the guard ran [a1b2c3d]
09-07 dropped  (08-14) CSV export — nobody asked for it in three weeks
09-05 answered (08-29) do we need SSO? — no, single tenant for now → see DECISIONS 08-29
09-01 moved    (08-20) invoice screen — in flight >14 days, returned to Next up
```

Four verbs: `done`, `dropped`, `answered`, `moved`. Both dates are kept — the gap between them
is how long the item lived, which is the cheapest signal available for whether the team is
finishing things or accumulating them.

**Why a file and not commit-message footers.** Footers were the first design; a file is better
for this team. Manthan and most contributors are not going to run `git log --grep`, and a file
is readable in a browser on GitHub. A file also survives squash-merging, which eats footers.
Since the ledger is itself committed, `git log -p docs/LEDGER.md` still gives the git-native
view for anyone who wants it. One home, not two — no chance of the two records disagreeing.

**Why this is not `updates.md` coming back.** `updates.md` was cut because it would have
duplicated `git log`: what changed in the code. The ledger records something git does not know —
that a tracked item was **dropped**, or a question was **answered**. That information has no
other home, and it is exactly what a new contributor needs before pitching: *did we already try
this, and what happened?* If a line does not help answer that question, it does not belong here.

**Boundary with `DECISIONS.md`.** A dropped or answered item carrying real reasoning goes to
`DECISIONS.md`; the ledger line then points at it. The reasoning is written once.

**Decay.** Split by year. When the current year's section gets long it moves to
`docs/ledger-<year>.md` and `docs/LEDGER.md` keeps the current year only — same pattern as the
decisions archive, and it needs no judgment call.

## DECISIONS.md — sharpened

The file that carries the context currently dying in chat threads. Six changes from the skeleton:

**1. The filter is the whole game.** ADR files die one of two ways: nothing gets written because
"was that a decision?" is a judgment call people dodge, or everything gets written and it's noise.
Two tests replace the judgment call:
- *Reader test:* would a developer reading this code in six months ask "why on earth did they do
  it this way?" If the code is self-explanatory, no entry.
- *Mechanical test:* if **Rejected** would be empty, it is not a decision — it is a task.
  No alternative, no decision.

**2. Tags in the heading.** `## 2026-09-07 [auth] — ...` Seven fixed tags, pick exactly one.
Reverse-chronological order is useless to a contributor who needs "everything we ever decided
about auth"; `grep '\[auth\]' DECISIONS.md` answers it. This is the change that serves the
original requirement #2 — a newcomer pitching intelligently.

**3. `Where:` field.** The file or folder the decision lives in. Two-way link: `groom` can check
the path still exists (a mechanical staleness test), and a developer staring at odd code can grep
the path in DECISIONS.md to find the reasoning.

**4. `Revisit if` must be checkable, and `groom` actually checks it.** "Revisit if we scale" is a
vibe. "Revisit if a second client signs" is a yes/no question. `groom` reads every active entry's
Revisit-if and asks whether it is true now. Decisions expire on their own stated terms, not by age.

**5. PROPOSED / REJECTED status lines — the pitch mechanism.** A contributor who disagrees with
an active decision writes a *new* entry with `> PROPOSED` at the top, full Context/Chose/Rejected
structure, and leaves the old one alone. `catchup` surfaces every PROPOSED entry to everyone until
the owner resolves it. Without this, disagreement either happens in chat and evaporates, or the
contributor just does it anyway. Reasoning still lives in exactly one place — the proposal.

**6. Scaffold seeds it.** The new-app interview already produces two or three decisions (stack,
Supabase or not, deploy target). Mode C writes them as the first entries. A file that starts empty
teaches the team that nothing goes there.

Body cap ~12 lines per entry. Titles are statements ("Single-tenant, no org model"), not topics
("Tenancy"). No numbering — date plus title is the reference.

### Who writes DECISIONS.md, and when

Claude writes it. Nobody hand-authors entries. But **when** matters more than it looks:

- **Not at handoff.** The *why* is the most perishable thing in a session. Long sessions get
  compacted; the diff survives, the conversation where an alternative was rejected may not.
  And "summarize from the diff" — right for *what changed* — cannot recover *why*.
- **At the moment the choice lands.** The instant a real decision is made mid-session, Claude
  drafts the entry, shows it in two lines, gets a yes, stages it. `handoff` just commits.
- **`decision` is the wake word** to force one from whatever was just discussed.
- **`handoff` sweeps once as a backstop**, for anything missed. It does not pad.

One rule against Claude documenting its own reasoning too generously: **Rejected may only list
alternatives that were actually on the table.** No straw alternatives to make an entry look
complete. If only one path was ever discussed, the mechanical test fails and there is no entry.

## Onboarding — `setup`

The gap Manthan spotted on 2026-09-07: the rituals assumed a repo existed, identity was set, and
access worked. None of that is true for a newcomer, and one of them is false for *everyone* in
Cowork.

**Verified in the Cowork shell:** every session starts with **no git identity**. A commit fails
with "Please tell me who you are." Without a fix, `handoff` would break for every Cowork user,
every session. The fix is repo-local identity — `git config --local user.name / user.email` — which
lives in `.git/config` on the Mac and persists. Node 22 and npm are present in Cowork, so the Vite
stack works there; `gh` is not.

`setup` runs a checklist, fixes what it can, and reports ✓/✗ with the exact step for anything it
cannot do itself:

1. Tools — git, node, npm.
2. Situation — repo found? If not: *joining* (test read access with `git ls-remote` **before**
   cloning; failure means not a collaborator → ask the owner, nothing proceeds) or *new* (user
   creates the empty GitHub repo in a browser; Claude never handles tokens to do it via API).
3. Identity — repo-local, always, in both Cowork and Claude Code.
4. Push access — `git push --dry-run`. On failure: Cowork needs `.git/.cw-credentials`, created by
   the user **in their own Terminal**, never through Claude, so the token never appears in chat.
5. Operating layer present? New app → scaffold. Existing repo without it → **retrofit**: interview
   against the real code, seed README/DECISIONS/STATE from what's there, record current structure
   violations as STATE "Broken / risky" bullets instead of fixing everything at once.
6. `.gitignore` sanity.
7. Report, then `catchup`.

`catchup` and `handoff` now run a three-line **fast pre-flight** every time (repo found, local
identity set, remote set) and hand off to `setup` on any failure — so identity or auth can never
fail at the end of a session.

### The distribution gap — not yet solved

`setup` can onboard a person to a *repo*. It cannot install itself. A teammate who clones a repo
and says `catchup` without the `zamstars-ops` skill gets nothing. Two mitigations, one built:

- **Built:** `CLAUDE.md` in every repo carries a six-line fallback — the minimum start/end
  discipline in plain git commands, plus "ask the owner for the skill." Claude Code auto-reads it,
  so a Claude Code user gets ~70% of the system with zero install. Cowork does not auto-read repo
  CLAUDE.md, so Cowork users need the skill.
- **Not built:** an internal plugin marketplace — a small GitHub repo holding the skill, which each
  teammate adds once. This is the real fix and the next build item. Until it exists, distribution
  is "Manthan sends the SKILL.md."

## Git modes — who runs the git commands (decided 2026-09-07)

Three modes, stored per person per clone in `.git/config` as `zamstars.mode`, never committed:

| Mode | Mutating git (commit, push, pull, clone, config) | Reads (status, log, diff) | Default |
|---|---|---|---|
| `direct` | Claude, via Claude Code's shell | Claude | Claude Code |
| `terminal` | **The user**, pasting a block Claude hands them into their own Terminal | Claude, via the Cowork shell (read-only, needs no identity or creds) | **Cowork** |
| `shell` | Claude, via the Cowork shell | Claude | Cowork, opt-in only |

**Why `terminal` is the Cowork default.** Every Cowork-shell problem found today — no identity,
no keychain, session-scoped `$HOME`, the `.cw-credentials` workaround — vanishes if the user's own
Mac runs the mutating commands. Their Terminal already knows who they are and how to reach GitHub.
The cost is a paste-and-paste-back round trip per git action; `handoff` groups add + commit +
pull --rebase + push into one block so it is usually one round trip.

Protocol: one fenced block, `cd <repo>` first, single-quoted commit messages; Claude says
whether to paste the output back or just say "done"; Claude **waits** and diagnoses from real
output, never re-issues blindly. Reads still happen through the Cowork shell so Claude can decide
what to add without asking.

## Newcomer onboarding — F0

`setup` now starts from zero: GitHub account → git installed (Mac: Command Line Tools /
`xcode-select --install`; Windows: git-scm.com + Git Bash) → Node LTS → `git config --global`
identity → a way to push (`gh auth login` recommended; or a fine-grained token used as the
password on first push) → collaborator access ("repository not found" means *no access*, not a
bad URL) → the skill → a folder to clone into. Only the gaps get instructions.

`docs/ONBOARDING.md` is the human-readable copy that lives in every repo, so a newcomer can read
it on GitHub in a browser **before** they have Claude, the skill, or anything installed. That is
what breaks the chicken-and-egg: you cannot run `setup` without the skill, but you can read a file.

## Skill set (split 2026-09-07)

One skill had grown to ~550 lines — past the point where Claude follows rather than skims. Split
by frequency of use:

| Skill | When it runs | Carries |
|---|---|---|
| **`zamstars-ops`** (core) | Every session | Git-mode protocol, pre-flight, `catchup`, `handoff`, `decision`, cheap decay checks, hard rules, STATE/DECISIONS/LEDGER shapes |
| **`zamstars-setup`** | Once per person per repo | Newcomer prerequisites F0–F7, git-mode choice, access test before clone, retrofit, scaffold, README/CLAUDE/ONBOARDING templates |
| **`zamstars-groom`** | Occasionally, or when STATE is >2 weeks stale | The full, noisy decay pass; Revisit-if and Where checks on every active decision; propose-don't-apply |

`setup` and `groom` both begin with "load `zamstars-ops` first" — the core owns every shared
convention, so a rule changes in one place. `ops` routes to the other two by trigger word so a
user never has to know which skill they need.

A newcomer needs `zamstars-ops` + `zamstars-setup`. `zamstars-groom` can come later.

## Universal across agents (decided 2026-09-08)

The system now lives **in the repo, not in the agent.** Verified from official docs: Claude Code
does not read `AGENTS.md`; the sanctioned bridge is a `CLAUDE.md` containing `@AGENTS.md`.
Codex, Cursor, Copilot, Gemini CLI, Zed, Windsurf, JetBrains and others read `AGENTS.md`
natively. Claude Code wants instruction files under ~200 lines, imports included.

So every app repo carries:
- `AGENTS.md` (~80 lines) — always-on: file map, hard rules, code rules, git-mode rule, and a
  **trigger table**: "when the user says X, open `docs/agent/X.md` and follow it exactly."
- `docs/agent/` — `SETUP`, `CATCHUP`, `HANDOFF`, `DECISION`, `GROOM`, `SHAPES`. Opened on demand.
  This is how skills work, done with plain files any agent can read.
- Pointer files, two lines each: `CLAUDE.md` (`@AGENTS.md`), `GEMINI.md`,
  `.cursor/rules/zamstars.mdc`, `.github/copilot-instructions.md`, `.windsurf/rules/zamstars.md`.
- App-specific rules moved **into `AGENTS.md`** so every tool sees them; `CLAUDE.md` is a pure import.

Git modes collapsed to two: `direct` (agent runs shell on the user's machine) and `terminal`
(agent hands over commands). `shell` mode is gone — the user does not want the Cowork sandbox
running git, and it could not commit anyway (cannot unlink `index.lock` without a delete grant).

`skills/` is **generated** from `agent/` by `build.sh` — Agent Skills standard, installable in
Claude Code (plugin marketplace, source `./`), Codex, Cursor, Gemini CLI. Each generated skill
opens with: *if the repo has `AGENTS.md`, it is authoritative and may be newer than this skill.*
Repo beats installed skill, always — that is the drift rule.

Repo renamed `zamstars-claude` → `zamstars-agents`; the old folder is in `_to_delete/`.
