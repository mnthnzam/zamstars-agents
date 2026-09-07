---
name: zamstars-ops
description: "Zamstars everyday operating layer. Use when the user says catchup / sync in, handoff / wrap up, or decision, or is working inside a Zamstars app repo. Runs the start- and end-of-session git rituals in direct, terminal, or Cowork-shell mode, captures decisions as they happen, enforces the codebase structure limits. Core conventions that zamstars-setup and zamstars-groom build on."
---

# Zamstars ops — the everyday skill

One repo per app. **The repo is the source of truth; Claude is an editor, never a store.**

Four operating-layer files at repo root, read every session: `README.md`, `DECISIONS.md`,
`STATE.md`, `CLAUDE.md`. Under `docs/`: `LEDGER.md`, `decisions-<year>.md`, `ONBOARDING.md`.

**Zamstars does not use Claude Artifacts.** Apps are normal repos built to be handed to a
developer without apology.

This skill is the core. Two siblings load it and extend it:
- **`zamstars-setup`** — onboarding a person, joining or starting a repo, scaffolding. Load it when
  the user says `setup`, `onboard me`, "I'm new", wants a new app, or when pre-flight below fails.
- **`zamstars-groom`** — the deliberate maintenance pass. Load it when the user says `groom`, or
  when `catchup` finds STATE.md stale by more than two weeks.

## Routing

| Trigger | Mode |
|---|---|
| `catchup`, `catch up`, `sync in` | **A — start of session** |
| `handoff`, `hand off`, `wrap up` | **B — end of session** |
| `decision`, "note that as a decision" | **E — record a decision now** |
| `setup`, new app, "I'm new", pre-flight failure | load `zamstars-setup` |
| `groom`, STATE stale >14 days | load `zamstars-groom` |

---

## Step 0 — environment, git mode, pre-flight

### Environment
- **Claude Code** — `Bash` runs on the user's Mac. Repo root: `git rev-parse --show-toplevel`.
- **Cowork** — `mcp__remote-devices__device_bash` runs in an isolated Linux VM; connected folders
  mount under `$HOME/mnt/`. `ls $HOME/mnt/`, then `git -C <path> rev-parse --show-toplevel`.
  Every call is a fresh shell; anchor paths at `$HOME`. It cannot delete files without an
  approved permission grant — prefer archiving.

If more than one repo is present, ask which app. Never guess.

### Git mode — who runs mutating git
Stored per person, per clone: `git config --local zamstars.mode <direct|terminal|shell>`.
Read it first. Unset → Claude Code defaults to `direct`, Cowork to `terminal`; `zamstars-setup`
stores it.

| Mode | Mutating git (`clone init remote config add commit pull push checkout stash`) | Reads (`status log diff config --get ls-files`) |
|---|---|---|
| `direct` | Claude, via `Bash` | Claude |
| `terminal` | **The user, in their own Terminal**, from a block Claude hands them | Claude, via the Cowork shell — needs no identity or credentials |
| `shell` | Claude, via `device_bash` — requires repo-local identity and `.git/.cw-credentials` | Claude |

**Terminal-mode protocol.** For every mutating command:
1. Hand over **one fenced block**: first line `cd <absolute repo path>`, then the commands, nothing else. Single-quote commit messages; escape an inner `'` as `'\''`.
2. Say what to paste back: the output for anything you must *read* (`status`, `pull`, `push`, `ls-remote`, `push --dry-run`); "say done" for the rest.
3. **Wait.** Never proceed on assumption. Diagnose from the pasted output; never re-issue blindly.
4. Group what belongs together (add + commit + pull --rebase + push) so one paste covers it, but never combine a read whose output decides something with the write that depends on it.

**Shell-mode push form:** `git -c credential.helper='store --file=.git/.cw-credentials' push`.

**In every mode:** never write a token, never ask for one in chat, never put one in a tracked
file or remote URL. Credential files are created by the user in their own Terminal.

### Fast pre-flight — before every mode, silent when it passes
1. A git repo is found at the target.
2. `git config user.email` resolves in the mode that will commit (`--local` in shell mode).
3. `git remote get-url origin` returns something.
4. `zamstars.mode` is set.

Any failure → load `zamstars-setup` before continuing. Never commit or push with a failing pre-flight.

---

## During every session — capture decisions when they happen

The *why* is the most perishable thing in a session. Long sessions get compacted; the diff
survives, the conversation where an alternative was rejected may not.

**The moment a real choice lands** — an approach picked over an alternative that was actually
discussed, a constraint discovered, something tried and abandoned — run Mode E right then. Stage;
do not commit. Do not wait for handoff to remember.

Two tests, both must pass:
- *Reader test:* would a developer reading this code in six months ask "why on earth did they do it this way?" Self-explanatory code → no entry.
- *Mechanical test:* if **Rejected** would be empty, it is a task, not a decision. No entry.

**Rejected may only list alternatives actually on the table in this session.** Never invent a
straw alternative. One path discussed → no entry. An honest gap beats a fabricated one.

---

## Mode E — `decision`

1. Draft from the conversation: `## YYYY-MM-DD [tag] — <statement>`, exactly one tag from
   `[stack] [data] [auth] [ui] [infra] [process] [scope]`; **Context** (1–3 lines), **Chose**,
   **Rejected** (only what was really considered, one reason each), a **checkable** `Revisit if`
   (yes/no answerable today — "if a second client signs", not "if we scale"), `Where:` when the
   decision has a physical home. Body ≤12 lines. Title is a statement, not a topic.
2. Show the draft in two or three lines; ask for a yes. The user is the authority, Claude the scribe.
3. On yes: insert at the top of `DECISIONS.md`. If it contradicts an active entry, add
   `> SUPERSEDED <date> by <new title>` to that entry's top. If the user is *proposing* against
   someone else's decision, put `> PROPOSED <date> by <name>` on the new entry and leave the old
   one alone. Never edit an entry's body; status lines are the only permitted change:
   `> PROPOSED` · `> SUPERSEDED` · `> OBSOLETE <date> — <why>` · `> REJECTED <date> by <name> — <why>`.
   No status line = active. Never resolve someone else's PROPOSED entry without asking.
4. Stage `DECISIONS.md` (terminal mode: fold into handoff's block). Do not commit — handoff does.

---

## Mode A — `catchup`

0. Fast pre-flight. Failure → `zamstars-setup`.
1. `git pull --ff-only` (terminal mode: hand over, paste back). Diverged or failed → **stop**, show, ask. Never auto-merge.
2. Read `README.md`, `STATE.md`, `CLAUDE.md`, the newest ~10 `DECISIONS.md` entries plus every `> PROPOSED` one, and the newest ~15 lines of `docs/LEDGER.md`.
3. **Staleness check.** `STATE.md` `Updated:` vs `git log -1 --format=%cs`. STATE older → say so **first and prominently**: the operating layer is behind the code and everything below may be wrong. This is the system's main enforcement; do not soften or bury it. Stale >14 days → offer `zamstars-groom`.
4. Commits since this person last touched it: `git log --oneline <their-last-sha>..HEAD`, else `-20`.
5. `Active:` line — held by someone else recently? Say so; ask before claiming.
6. Report in exactly this shape, nothing else:
   - **What this is** — one line from README
   - **Since you last looked** — commits in plain language, grouped by what changed
   - **Finished / dropped** — from the ledger; call dropped items out with their reason
   - **In flight / broken / next** — from STATE
   - **Decisions you may not know about** — entries newer than their last commit
   - **Open proposals** — every `> PROPOSED` entry, who pitched it, what it would supersede
   - **Currently held by** — the Active line
   - **What isn't written down** — specific gaps hit while reading. Name them.
7. Claim: set `Active:` to this person + today; commit `chore: claim <app>`; push (terminal mode: one block).

---

## Mode B — `handoff`

0. Fast pre-flight. Failure → `zamstars-setup`, so the push cannot surprise anyone.
1. `git status --short`, `git diff`, `git diff --cached` — reads, Claude runs them in every mode. Summarize **what changed** from the diff, not from memory.
2. **Structure check.** From the repo root:
   ```
   find src -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.css' \) -exec wc -l {} + | sort -rn | head -20
   ```
   - Over **300 lines**: split now, before committing. Not a follow-up.
   - Over **200 lines**: say so, propose the split; proceed only if the user declines, and record that in DECISIONS.
   - Also flag: logic in a UI component, inline `<script>`/`<style>`, `onclick=`, a hardcoded secret, an import pointing sideways between features or upward.
3. **Cheap decay check** — raise only what trips; say nothing about what passed:
   - STATE: an `In flight` bullet >**14 days** old is abandoned — move to Next up or drop; any bullet >**30 days** — confirm or drop; >**12 bullets** — cut. Every removal gets a ledger line.
   - DECISIONS: >**800 lines or 40 entries** → propose archiving to `docs/decisions-<year>.md` (superseded/obsolete/rejected only; active and PROPOSED never leave). A `> PROPOSED` entry >**30 days** old → ask the owner to resolve it.
   - README: do the "Run it" scripts exist in `package.json`? Do `.env.example` vars match what the code reads (`import.meta.env` / `process.env`)? Does Depends-on match `package.json`? Mismatch = fix now.
   - CLAUDE.md: app-specific rules capped at **10**; to add one, name the one that leaves.
4. **Decision sweep — backstop only.** Re-read the conversation once for anything Mode E missed. Apply both tests. Do not pad; if nothing qualifies, say nothing.
5. **Rewrite `STATE.md` wholesale** — live, open items only. Every bullet keeps the `(MM-DD)` it first appeared; max 3 per section, 12 in the file; one line each; `- none` for empty sections; never delete a heading; never write history. Update `Updated:` and `Branch:`; `Active: none` unless continuing.
6. **Every bullet that left STATE gets a ledger line** at the top of the current year in `docs/LEDGER.md`:
   `<date left> <verb> (<date entered>) <bullet> — <why> [<sha> for done]` — verbs **done / dropped / answered / moved** only. Both dates always. A bullet may never simply vanish; if the verb is unclear, ask. Reasoning-heavy `dropped`/`answered` items go to DECISIONS; the ledger line points there.
7. Touch `README.md` only if how-to-run, stack, where it runs, or dependencies changed — or the consistency check found a mismatch.
8. Commit: `<verb>: <what> — <why>`. One commit per logical change. Add **named files** from the status output — never `git add -A`. Terminal mode: one block per commit ending `git pull --rebase && git push`; paste back.
9. `git pull --rebase`, push. Conflict → stop and surface. Auth failure → `zamstars-setup` F4.
10. Report: committed, pushed, what still needs a human.

---

## File shapes handoff writes

**STATE.md**
```markdown
# STATE — <app>
Updated: <YYYY-MM-DD> by <name>
Active: <name (since YYYY-MM-DD)> | none
Branch: <branch>

## In flight — half-done, do not touch without talking to Active
- (MM-DD) ...
## Broken / risky — known bad right now
- (MM-DD) <symptom> → <cause>   ·   - (MM-DD) Don't touch: <area> — <why>
## Next up — safe to pick up cold
- (MM-DD) <task> — <the one thing you need to know>
## Open questions — best place to pitch in
- (MM-DD) <question> — <what an answer unblocks>
```

**docs/LEDGER.md** — `## <year>` sections, newest first:
`- 09-07 done (09-02) auth redirect bug — guard ran before session restore [a1b2c3d]`

**DECISIONS.md entry**
```markdown
## YYYY-MM-DD [tag] — <statement>
**Context:** ...  **Chose:** ...  **Rejected:** ... — one reason each
**Revisit if:** <yes/no-checkable condition>  **Where:** <path, optional>
```

---

## Hard rules

**Process**
- **Nothing ships that isn't committed.** A change made only in a chat does not exist.
- **Pre-flight before any commit or push.**
- **Respect the git mode.** In `terminal` mode never run a mutating git command yourself.
- `STATE.md` is overwritten and holds only live items. `DECISIONS.md` and `docs/LEDGER.md` are append-only — DECISIONS status lines are the sole exception.
- **No bullet leaves STATE without a ledger line.**
- **No DECISIONS entry without a non-empty Rejected drawn from alternatives actually discussed.**
- **Decisions are recorded when made, not remembered at handoff.**
- Never resolve another person's PROPOSED entry without asking.
- Never force-push. Never silently resolve a conflict. Never `git add -A`.
- Never handle a token. Never write a credential into a tracked file.
- Never remove operating-layer content the user has not seen and agreed to lose.
- If the files contradict the code, **trust the code**, say the docs are wrong, fix them this handoff.

**Code**
- ≤200 lines per source file (hard fail 300). ≤50 lines per function.
- One exported thing per file, named the same as the file.
- No business logic in UI components — logic lives in `lib/` or the feature's module.
- No inline `<script>`/`<style>`, no `onclick=`.
- **Imports point downward only:** `pages → features → lib → types`. Never sideways, never up.
- `features/` is the default home; `components/` only for things used by 2+ features.
- Secrets in `.env` only. `.env.example` committed, `.env` never.