#!/usr/bin/env bash
# Generates skills/*/SKILL.md from the canonical files in agent/.
# Run after editing anything under agent/  (bash build.sh). Then bump version in .claude-plugin/*.json.
set -euo pipefail
cd "$(dirname "$0")"
A=agent/docs/agent
TMP="$(mktemp)"

emit() { # name description files...
  local name="$1" desc="$2"; shift 2
  mkdir -p "skills/$name"
  : > "$TMP"
  printf -- '---\nname: %s\ndescription: "%s"\n---\n\n' "$name" "$desc" >> "$TMP"
  printf '> **Generated from `agent/` in github.com/mnthnzam/zamstars-agents by build.sh — do not edit here.**\n' >> "$TMP"
  printf '> If the repo you are in has `AGENTS.md`, that file and `docs/agent/` are authoritative and may be newer than this skill. Read and follow them; use the text below only when no repo exists yet.\n\n' >> "$TMP"
  for f in "$@"; do cat "$f" >> "$TMP"; printf '\n\n---\n\n' >> "$TMP"; done
  cp "$TMP" "skills/$name/SKILL.md"
  echo "wrote skills/$name/SKILL.md ($(wc -l < "skills/$name/SKILL.md") lines)"
}

emit zamstars-ops \
  "Zamstars everyday operating layer. Use when the user says catchup / sync in, handoff / wrap up, or decision, or is working inside a Zamstars app repo. Start- and end-of-session git rituals in direct or terminal mode, decisions captured as they happen, codebase structure limits and how to split a file without making it worse. Core conventions." \
  agent/AGENTS.md "$A/SHAPES.md" "$A/STRUCTURE.md" "$A/CATCHUP.md" "$A/HANDOFF.md" "$A/DECISION.md"

emit zamstars-setup \
  "Zamstars onboarding and scaffolding. Use when the user says setup / onboard me / first time / I'm new, wants to start a new Zamstars app or join one, or when pre-flight fails. Walks a newcomer from zero, picks the git mode, tests access before cloning, retrofits or scaffolds the operating layer." \
  "$A/SETUP.md"

# --- zamstars-setup also carries the files an app repo needs, for agents with no network ---
rm -rf skills/zamstars-setup/files
mkdir -p skills/zamstars-setup/files/agent skills/zamstars-setup/files/templates
cp -R agent/. skills/zamstars-setup/files/agent/
cp -R templates/. skills/zamstars-setup/files/templates/
{
  printf '## Bundled files — for a single-file skill install (Claude Cowork)\n\n'
  printf 'The small files below are verbatim; write each to the path shown, at the app repo root. Prefer cloning the public repo (see **Getting the files**) — this appendix is only as new as the installed skill. The ritual files (`docs/agent/*.md`) are not repeated here: `AGENTS.md`, `SHAPES.md`, `STRUCTURE.md`, `CATCHUP.md`, `HANDOFF.md` and `DECISION.md` are the sections of the `zamstars-ops` skill in that order, `SETUP.md` is this skill, `GROOM.md` opens the `zamstars-groom` skill. Split them at the `---` rules.\n\n'
  for f in agent/CLAUDE.md agent/GEMINI.md agent/.cursor/rules/zamstars.mdc agent/.github/copilot-instructions.md agent/.windsurf/rules/zamstars.md templates/ONBOARDING.md templates/STATE.md templates/DECISIONS.md templates/LEDGER.md templates/README.md; do
    dest="${f#agent/}"; dest="${dest#templates/}"
    case "$f" in templates/ONBOARDING.md|templates/LEDGER.md) dest="docs/$dest";; esac
    printf '### `%s`\n\n````markdown\n' "$dest"; cat "$f"; printf '\n````\n\n'
  done
} >> skills/zamstars-setup/SKILL.md
echo "bundled $(find skills/zamstars-setup/files -type f | wc -l | tr -d ' ') files into skills/zamstars-setup/files/ and appended the appendix ($(wc -l < skills/zamstars-setup/SKILL.md) lines)"

emit zamstars-groom \
  "Zamstars maintenance pass. Use when the user says groom, 'is this repo rotting', or when catchup reports STATE.md stale by more than two weeks. Full decay pass, Revisit-if and Where checks on every active decision, propose-don't-apply." \
  "$A/GROOM.md" "$A/SHAPES.md" "$A/STRUCTURE.md"

rm -f "$TMP"
