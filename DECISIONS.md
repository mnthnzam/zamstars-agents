# DECISIONS — zamstars-agents

Why the operating layer is designed the way it is. Append-only, newest at top.

`SYSTEM.md` is the frozen long-form record of the sessions that produced these; entries link to
it from `Where:` rather than repeating the argument. New reasoning goes here, not there.

## Write an entry when
A person reading this system in six months would ask **"why on earth did they do it this way?"**
Mechanical check: if **Rejected** would be empty, it is not a decision — it is a task.

## Never edit an entry's body
The only permitted change to a past entry is a status line at its top:

    > PROPOSED   YYYY-MM-DD by <name>                — a pitch, not yet in force
    > SUPERSEDED YYYY-MM-DD by <newer entry title>   — replaced; the newer entry says why
    > OBSOLETE   YYYY-MM-DD — <why>                  — what it described no longer exists
    > REJECTED   YYYY-MM-DD by <name> — <why>        — a proposal that did not land

## Tags — pick exactly one, grep by it
`[stack]` `[data]` `[auth]` `[ui]` `[infra]` `[process]` `[scope]`

---

## 2026-09-08 [process] — Source files may run to 500 lines, hard fail at 800
**Context:** 200/300 was set before any Zamstars app existed. It fires on JSX-heavy page
components that are long without being complex, and a limit that fires on every form teaches the
team to ignore every limit. No file has actually tripped it yet — the largest in `daily-tracker`
is 28 lines.
**Chose:** 500 propose / 800 hard fail, globally. The 50-line function rule stays and becomes the
primary readability check. STRUCTURE.md's rationale was rewritten to say what the count now does:
catch a runaway file, not protect readability. One-reason-to-change, downward imports and
no-logic-in-components carry that instead.
**Rejected:** raise it per repo in app-specific rules once a real file tripped — the sanctioned
path, but no file has tripped and waiting costs a scaffold cycle. Split by kind (200/300 for
`.ts`, 400/500 for `.tsx`) — two numbers to remember and a judgment call at every boundary.
**Revisit if:** two files in one repo cross 500 in the same month and nobody proposes a split.
**Where:** `agent/AGENTS.md`, `agent/docs/agent/STRUCTURE.md`, `agent/docs/agent/HANDOFF.md`

## 2026-09-08 [process] — Catchup routes between repos before it acts on one
**Context:** CATCHUP.md was cwd-bound: one repo, one `Active:` line, one staleness check. With
several apps running, "catchup" from the parent folder failed pre-flight and routed to SETUP —
wrong door — and the staleness check, the system's main enforcement, only ever fired on a repo
someone had already opened. The repo rotting hardest is the one nobody opens.
**Chose:** step 0.5 scans sibling folders for `docs/agent/CATCHUP.md`, prints repo / state date /
code date / Active, and either asks which to enter or carries the list into the step 6 report as
an "other repos going stale" line. Derived from the filesystem each run.
**Rejected:** a `PROJECTS.md` registry — state living outside every repo, which contradicts "the
repo is the source of truth" and rots the moment someone forgets to update it. Matching on the
AGENTS.md title string — `zamstars-agents`' own title differs, and a string is fragile.
**Revisit if:** apps stop being siblings one level under a shared parent.
**Where:** `agent/docs/agent/CATCHUP.md`

## 2026-09-08 [process] — The line limits get their own on-demand doc, not more lines in AGENTS.md
**Context:** "No file over 200 lines" was one bullet with no rationale, no exemptions and no
guidance on how to split. Agents were flagging generated files, and a bad split is worse than no
split. Elaborating it inline would have grown the always-on file every agent reads on every task.
**Chose:** `agent/docs/agent/STRUCTURE.md` — why the limits exist, the exemption list, how to
split in order of preference, bad-split smells, and what to do when someone declines. `AGENTS.md`
keeps the one-line rule plus a pointer. HANDOFF and GROOM defer to it.
**Rejected:** Inline in `AGENTS.md` — Claude Code wants instruction files under ~200 lines
including imports, and always-on tokens are paid on every task, not just the ones about
structure. Putting it only in `GROOM.md` — the limit is enforced at handoff, which is where the
reader needs it.
**Revisit if:** An agent is observed splitting a file badly *after* reading STRUCTURE.md — that
would mean the doc is the wrong fix and the check needs to be mechanical.
**Where:** `agent/docs/agent/STRUCTURE.md`

## 2026-09-08 [process] — The rules live in the repo, not in the agent
**Context:** Zamstars members are on separate individual accounts across different agents, with
no shared org. Context was living in chat threads, which is the root cause: a thread is not a
repository. Any fix that only worked in one vendor's tool would leave most of the team out.
**Chose:** Every app repo carries `AGENTS.md` plus `docs/agent/*.md`, read natively by Codex,
Cursor, Copilot, Gemini CLI, Zed, Windsurf and JetBrains, and by Claude Code through a
`CLAUDE.md` containing `@AGENTS.md`. Clone the repo, any agent knows the system, nothing to
install.
**Rejected:** A Claude-only skill or plugin — locks the system to one vendor and one account
type. A Team/Enterprise plan — costs money and still does not reach someone on Cursor. Keeping
it in chat threads — the failure being fixed.
**Revisit if:** A major agent stops reading `AGENTS.md`, or the trigger table demonstrably fails
in a non-Claude agent under real use.
**Where:** `agent/`, `SYSTEM.md` → "Universal across agents"

## 2026-09-08 [process] — `skills/` is generated from `agent/`, and the repo always beats the skill
**Context:** The same rituals need to exist as repo files (universal) and as installed skills
(usable before a repo exists, and in Cowork which does not auto-read repo files). Two hand-kept
copies of the same rules disagree within weeks, and the disagreement is silent.
**Chose:** `build.sh` concatenates `agent/*` into `skills/*/SKILL.md`. Every generated skill
opens by saying the repo's `AGENTS.md` is authoritative and may be newer. One source, one
direction, and a stated winner when they differ anyway.
**Rejected:** Maintaining skills by hand — guaranteed drift with no way to tell which copy is
right. Shipping only skills — leaves out every agent that does not implement Agent Skills.
Shipping only repo files — nothing to scaffold a repo that does not exist yet.
**Revisit if:** A generated skill is ever edited by hand, or `build.sh` grows conditional logic
per agent — either means the concatenation model has run out.
**Where:** `build.sh`, `skills/`

## 2026-09-08 [process] — Two git modes, `direct` and `terminal`; `shell` removed
**Context:** Whether the agent can run git depends on whether its shell is the user's own
machine. The Cowork sandbox is not, and it cannot commit at all — it cannot unlink `index.lock`
without a delete grant. Guessing wrong fails at push time, at the end of a session, after the
work is done.
**Chose:** `git config --local zamstars.mode` set to `direct` (agent runs git) or `terminal`
(agent hands over a paste block and waits). Pre-flight checks it before every commit or push.
**Rejected:** A third `shell` mode running git inside the sandbox — cannot commit, and the user
did not want it. Auto-detecting per command — the failure surfaces too late and is confusing when
it does.
**Revisit if:** The sandbox gains durable identity and the ability to remove lock files.
**Where:** `agent/AGENTS.md` → "Git mode", `agent/docs/agent/SETUP.md` F1

## 2026-09-08 [process] — Enforcement is read-time, not write-time. No git hooks, no scheduled job
**Context:** The drift being prevented is documentation that stops matching the code. The obvious
enforcement is a hook or a cron.
**Chose:** `catchup` compares `STATE.md`'s `Updated:` date to the newest commit and says so
loudly, first, before anything else. Drift is caught by the next person to sit down — the one
moment someone has both the context and the motive to fix it.
**Rejected:** Git hooks — a hook cannot fire if nobody pushes, which is the actual failure mode,
and hooks are per-clone so they miss exactly the person who skipped setup. A scheduled clean-up —
fires whether or not anyone is working and gets ignored like any other stale notification.
**Revisit if:** The staleness warning starts getting ignored in practice. That is the trigger for
hooks, and nothing before it is.
**Where:** `agent/docs/agent/CATCHUP.md` step 3, `SYSTEM.md` → "Enforcement: read-time"

## 2026-09-08 [process] — What leaves STATE goes to a ledger file, not a commit footer
**Context:** `STATE.md` holds only live items, so finished and dropped items need somewhere to
go. Git already records what changed in the code; it does not record that a tracked item was
dropped or a question was answered.
**Chose:** `docs/LEDGER.md`, one line per departure, four verbs, both dates kept. Readable in a
browser on GitHub by someone who will never run `git log`.
**Rejected:** Commit-message footers — most contributors here will not run `git log --grep`, and
squash-merging eats footers. A `Done` section inside STATE — reintroduces the growth STATE exists
to avoid. `updates.md` — would duplicate `git log`, which is why it was cut in the first place.
**Revisit if:** The ledger is never read — check by asking whether anyone has used it to answer
"did we already try this?"
**Where:** `templates/LEDGER.md`, `agent/docs/agent/SHAPES.md`

## 2026-09-08 [process] — A decision is written the moment it lands, not at handoff
**Context:** The *why* is the most perishable thing in a session. Long sessions get compacted:
the diff survives, the conversation where an alternative was rejected may not. "Summarize from
the diff" recovers what changed and cannot recover why.
**Chose:** `decision` is a wake word, and any real choice is drafted into `DECISIONS.md` the
moment it is made. `handoff` sweeps once as a backstop and does not pad.
**Rejected:** Writing decisions only at handoff — recovers them from memory that may no longer
exist. Letting humans author entries — nobody will, which is how the chat-thread problem started.
**Revisit if:** Entries start appearing that fail the Rejected test, meaning the agent is padding
to look thorough.
**Where:** `agent/docs/agent/DECISION.md`
