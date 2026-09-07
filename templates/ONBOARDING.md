# Joining <App name>

Owner: <name> — ask them for repo access and for the `zamstars-ops` and `zamstars-setup` Claude skills.

## Before your first session

1. **GitHub account** — github.com/signup. Send your username to the owner; accept the invite
   email when it arrives. Until you do, cloning will fail with "repository not found" — that
   means no access, not a wrong link.
2. **git** — open Terminal (Mac: Cmd+Space, type "Terminal"; Windows: install git first, then
   use Git Bash) and run `git --version`.
   - Mac: if it offers to install Command Line Tools, accept. Or run `xcode-select --install`.
   - Windows: download from git-scm.com/download/win, run with defaults.
3. **Node LTS** — nodejs.org → download the **LTS** installer → run it → reopen Terminal →
   `node --version` and `npm --version` should both print a number.
4. **Tell git who you are:**
   ```
   git config --global user.name 'Your Name'
   git config --global user.email 'the email on your GitHub account'
   ```
5. **Log in to GitHub for pushing.** GitHub does not accept your account password for git.
   - Easiest: install GitHub CLI (Mac: `brew install gh`; Windows: github.com/cli/cli), then
     `gh auth login` → GitHub.com → HTTPS → log in with browser.
   - Or a token: github.com → profile photo → Settings → Developer settings → Personal access
     tokens → Fine-grained → Generate. Repository access: this repo. Permissions: Contents →
     Read and write. Copy it once. On first `git push`, use your GitHub username and paste the
     token as the password; your computer remembers it after that.
6. **Make a folder for Zamstars work**, e.g. `~/Zamstars`, and clone into it:
   ```
   cd ~/Zamstars
   git clone <repo url>
   ```
7. **Install the `zamstars-ops` and `zamstars-setup` skills** in your Claude (Cowork or Claude Code). Ask the owner.

## Your first session

Open the repo folder in Claude and say **`setup`**. It checks everything above, fixes what it
can, and tells you exactly what is still missing. Then it runs `catchup`, which tells you what
this app is and where it stands.

Every session after that: **`catchup`** at the start, **`handoff`** at the end, **`decision`**
when a real choice gets made. That is the whole ritual.

## How git commands get run

By default in Cowork, Claude hands you the git commands to paste into your own Terminal and asks
you to paste the output back. That is deliberate: your Terminal already knows who you are and
how to reach GitHub. If you would rather Claude run them itself, say so during `setup`.
