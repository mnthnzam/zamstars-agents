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
  "Zamstars everyday operating layer. Use when the user says catchup / sync in, handoff / wrap up, or decision, or is working inside a Zamstars app repo. Start- and end-of-session git rituals in direct or terminal mode, decisions captured as they happen, codebase structure limits. Core conventions." \
  agent/AGENTS.md "$A/SHAPES.md" "$A/CATCHUP.md" "$A/HANDOFF.md" "$A/DECISION.md"

emit zamstars-setup \
  "Zamstars onboarding and scaffolding. Use when the user says setup / onboard me / first time / I'm new, wants to start a new Zamstars app or join one, or when pre-flight fails. Walks a newcomer from zero, picks the git mode, tests access before cloning, retrofits or scaffolds the operating layer." \
  "$A/SETUP.md"

emit zamstars-groom \
  "Zamstars maintenance pass. Use when the user says groom, 'is this repo rotting', or when catchup reports STATE.md stale by more than two weeks. Full decay pass, Revisit-if and Where checks on every active decision, propose-don't-apply." \
  "$A/GROOM.md" "$A/SHAPES.md"

rm -f "$TMP"
