---
description: Run GitHub Copilot CLI and OpenAI Codex against the current git diff for cross-model review
---

<!--
This is the cross-model review pattern from Module 4. The idea: do not trust
one model to grade its own homework. Send the same diff to a second and
third model and see what each one catches.

Heads up: this command assumes you have paid plans for both GitHub Copilot
and OpenAI Codex. Free tiers may rate-limit you out of useful reviews.

  - GitHub Copilot CLI: requires a Copilot subscription
  - OpenAI Codex CLI: requires an OpenAI API key with credits

If you do not have both, you can still use this command as a template — comment
out the call you cannot run and use just one reviewer. See
docs/cross-model-review.md in this repo for the full walkthrough.
-->

# Cross-model review

Run a cross-model code review on the current git diff using two external CLI agents. The goal is to catch bugs, security issues, and style problems that a single model might miss.

## Step 1: Verify the tools are installed

Run these checks. If either tool is missing, print the install instructions and stop.

- `which copilot` — should return a path. If not, tell the user to install with `npm install -g @github/copilot` and sign in by running `copilot` once (or ensure `gh auth login` is set).
- `which codex` — should return a path. If not, tell the user to install with `npm install -g @openai/codex` and set `OPENAI_API_KEY`.

Package names for both CLIs have shifted over the past year. If `npm install -g @github/copilot` doesn't work, check GitHub's current Copilot CLI docs — see `docs/cross-model-review.md` for context.

## Step 2: Capture the diff

Run `git diff` (unstaged) and `git diff --cached` (staged) and concatenate the output into `/tmp/cross-review-diff.txt`. If both are empty, tell the user there is nothing to review and stop.

## Step 3: Run Copilot CLI

Run:

```bash
copilot -p "Review the following git diff for bugs, security issues, and style problems. Be specific and cite file names and line numbers from the diff. Flag anything you would not approve in a code review." < /tmp/cross-review-diff.txt
```

Capture the full output.

## Step 4: Run Codex

Run:

```bash
codex exec -p "Review the following git diff for bugs, security issues, and style problems. Be specific and cite file names and line numbers. Flag anything you would not approve in a code review." < /tmp/cross-review-diff.txt
```

Capture the full output.

## Step 5: Summarize

Print a short side-by-side summary:

- **Copilot caught:** bullet list of what Copilot flagged
- **Codex caught:** bullet list of what Codex flagged
- **Both agreed on:** items both reviewers raised
- **Only one caught:** items where the two reviewers diverged, noting which agent caught what

End with a one-line recommendation: ship it, fix the agreed-on issues first, or stop and rethink.

See `docs/cross-model-review.md` for more on why this pattern matters and how the isolated context windows work.
