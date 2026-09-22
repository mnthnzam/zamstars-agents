# Joining <App name>

Owner: <name> — ask them for repo access.

## Before your first session
1. **GitHub account** — github.com/signup. Send your username to the owner; accept the invite
   email. Until you do, cloning fails with "repository not found" — that means no access, not a
   bad link.
2. **git** — `git --version` in Terminal (Mac: Cmd+Space, "Terminal"). Mac: accept the Command
   Line Tools prompt or run `xcode-select --install`. Windows: git-scm.com, then use Git Bash.
3. **Node LTS** — nodejs.org → LTS installer → reopen Terminal → `node --version`.
4. **Tell git who you are:**
   `git config --global user.name 'Your Name'`
   `git config --global user.email 'the email on your GitHub account'`
5. **Log in to GitHub for pushing** — easiest: install GitHub CLI and run `gh auth login`.
   Or a fine-grained token (Settings → Developer settings → Personal access tokens, Contents:
   Read and write on this repo) pasted as the password on first push.
6. **Make a folder**, e.g. `~/Zamstars`, and clone into it: `git clone <repo url>`
7. **Any coding agent.** The rules travel with the repo in `AGENTS.md`, which Codex, Cursor,
   Copilot, Gemini CLI, Zed, Windsurf and JetBrains read on their own, and Claude Code reads
   through `CLAUDE.md`. Nothing to install. Optional accelerator for agents that support the
   Agent Skills standard (Claude Code, Codex, Cursor, Gemini CLI): the `zamstars-*` skills from
   github.com/mnthnzam/zamstars-agents — see that repo's README.

## Your first session
Open the repo folder in your agent and say **`setup`**. It checks everything above, fixes what
it can, and tells you exactly what is still missing. Then it runs `catchup`, which tells you
what this app is and where it stands.

Every session after: **`catchup`** at the start, **`handoff`** at the end, **`decision`** when a
real choice gets made. That is the whole ritual.

## How git commands get run
If your agent can run commands on your own machine (Claude Code, Cursor, Codex CLI, Gemini CLI),
it runs git itself. If it cannot — a chat interface, or a sandbox that is not your computer — it
hands you the commands to paste into Terminal and asks for the output back. Your Terminal already
knows who you are and how to reach GitHub; that is why.
