# Git No-Pager PowerShell Rule

Status: ACTIVE

Purpose:
Prevent Git from opening the interactive pager screen in PowerShell.

Problem:
Some Git commands open a scroll viewer/pager when the output is long. The user sees a `:` prompt at the bottom and may think PowerShell is loading or stuck. It is not loading; Git is waiting inside the pager. Press `q` to leave it.

Rule:
Use `git --no-pager` by default for readout commands that may produce multi-line output.

Preferred:
- `git --no-pager status --short`
- `git --no-pager diff --cached --name-only`
- `git --no-pager diff --cached --stat`
- `git --no-pager log --oneline -5`
- `git --no-pager show --stat`

Avoid in helper/user-facing command blocks:
- `git diff --cached --name-only`
- `git diff --cached --stat`
- `git log --oneline`
- Any Git command likely to open a pager without `--no-pager`

Operator note:
If the `:` pager screen appears, press `q`. Do not press Ctrl+C unless intentionally cancelling the command.

Project rule:
Future Codex, assistant, mule, and helper instructions for this repo must use `git --no-pager` for Git readout commands unless there is a specific reason not to.
