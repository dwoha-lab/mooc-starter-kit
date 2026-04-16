# Cross-model code review

This is the Module 4 walkthrough for video D3. It covers the pattern of calling other AI coding tools — GitHub Copilot CLI and OpenAI Codex CLI — from inside Claude Code to get a second opinion on your work before you ship it.

The short version: different models catch different bugs. Don't be loyal to one tool.

## Why cross-model review

I've been writing journalism software with Claude Code for a while now. Claude is very good. It's also wrong sometimes. The mistakes Claude makes are not random — they cluster. There are blind spots in any one model.

Copilot catches different things than Claude. Codex catches different things than both. Running your code past two or three of them before you open a pull request takes a few minutes and routinely catches stuff you'd otherwise miss.

This is a habit, not a one-time gimmick. On any project where someone else (or future you) is going to depend on the code working, cross-model review is worth the time.

## The `-p` flag pattern

Most CLI agents — Claude Code, Copilot CLI, Codex CLI, Gemini CLI — support a non-interactive one-shot mode. You pass a prompt with `-p` (or `exec`), the tool runs it once, prints the answer, and exits.

```
copilot -p "review the current branch and flag anything you'd change"
codex exec -p "review the current branch and flag anything you'd change"
claude -p "summarize this folder in three bullets"
```

That's the whole trick. From inside a Claude Code session, you can run `copilot -p "..."` as a bash command and Claude will execute it, capture the output, and read the result back.

Two things make this powerful:

1. **Each CLI invocation runs in its own isolated context window.** The work the other model does doesn't count against your main Claude Code session's tokens. Your context budget is untouched.
2. **If you're on subscription plans for both services, the cost is zero marginal.** No per-token billing. The other model reviews your code for free as far as your wallet is concerned.

(If you're on per-call API billing instead of a subscription, this is still fine, but it's no longer free.)

## Installing Copilot CLI

```
npm install -g @github/copilot
```

Auth uses the GitHub account Copilot is licensed against. Run `copilot` once and it'll walk you through signing in. If you already have `gh` logged in, Copilot CLI will pick that up.

Package names shift — if the above doesn't produce a working `copilot` binary, check [GitHub's Copilot CLI docs](https://docs.github.com/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli) for the current install command.

Quick test:

```
copilot -p "what does this repo do"
```

If it returns a sensible summary, you're good.

## Installing Codex CLI

OpenAI's Codex CLI ships through `@openai/codex`:

```
npm install -g @openai/codex
```

Auth uses your OpenAI account — set `OPENAI_API_KEY` in your env, or run `codex` once to walk through the login. Package name has shifted a couple of times, so check [OpenAI's Codex CLI docs](https://github.com/openai/codex) if the command above doesn't land.

Quick test:

```
codex exec "what does this repo do"
```

Same idea. Sensible summary back means you're good.

## Calling Copilot from inside Claude Code

In a Claude Code session, you can ask Claude directly:

> Run `copilot -p "review the current branch against main and tell me what you'd change"` and tell me what it says.

Claude will execute the bash command, read the output, and reason about it. You can also do it as a one-liner if you want the raw output:

```
copilot -p "review the diff of my current branch versus main and flag any bugs, dead code, or risky patterns"
```

For a focused review of specific files:

```
copilot -p "review the changes in scripts/pipeline/03-process.sh and flag anything wrong"
```

Copilot tends to catch things like duplicated logic, dead branches, and rerun collisions where two cron jobs would step on each other on the same day. In Joe's live demo from video D3, Copilot flagged a same-day rerun collision and pointed at dead code that had built up across iterations.

## Calling Codex from inside Claude Code

Same idea, different binary:

```
codex exec "review my current branch versus main, flag anything that looks wrong, and rate the severity of each finding"
```

Codex tends to hit harder on architectural and logic issues. In the same demo, Codex came back with a sharper critique that included a high-severity finding both Claude and Copilot had missed. That's exactly why you run both.

You can also tell Claude to call Codex on a specific file:

> Run `codex exec "review backend/main.py for any logic bugs or missing error handling"` and summarize what it finds.

## What to review

Pick whichever scope matches the moment:

- **Current branch vs main** — pre-PR review, the most common case
- **Uncommitted changes** — quick sanity check before you commit
- **Specific files** — when you've just made a tricky change to one file and want a focused look
- **A specific function** — paste it in or point at it by line number

The narrower the scope, the better the review. Don't ask another model to "review my whole codebase." Give it a target.

## Reconciling the findings

Don't blindly accept everything either tool says. Some findings are real. Some are wrong. Some are right but not worth fixing right now.

A pattern that works well: bring all the findings back to Claude inside your main session and say:

> Here are the findings from Copilot and Codex. Read them, decide which are real, and fix everything reasonable. For anything you're skipping, tell me why.

That puts Claude in the role of triaging the other models' output. Claude is closer to your project context than either reviewer was, so it has a better shot at deciding what matters. You can then read Claude's call and override when you disagree.

This is also when you re-run your own eyes on the diff. The whole point of cross-model review is to catch things humans miss. The cost of a missed bug is much higher than the cost of a five-minute reread.

## Why this pattern works

Three reasons it scales:

1. **Isolated context windows.** The other model's review doesn't eat your main session's tokens. You can ask for several reviews per task without ever feeling the cost in your own conversation.
2. **Subscription pricing.** If you're on Claude Pro, GitHub Copilot, and ChatGPT, you've already paid the marginal cost. Nothing extra per review.
3. **Different blind spots.** Three models with three sets of training data catch three different sets of bugs. The overlap is real, but the non-overlap is where the value lives.

There's a fourth reason that's softer but matters: the discipline of running a review at all. Even a bad reviewer is better than no reviewer. Once you have the habit, the quality of your shipped code goes up.

## When NOT to use it

- **Personal projects nobody else will read.** You're the only reviewer either way. Don't burn tooling on it.
- **Early-draft exploration.** When you're still figuring out what you're building, cross-model review is noise. Wait until the shape is settled.
- **Tiny changes.** Renaming a variable doesn't need a three-model review.

The rule of thumb: review when the cost of being wrong is higher than the cost of the review.

## Ready-made slash command

The kit ships a slash command for this exact pattern at `.claude/commands/cross-review.md`. Run `/cross-review` in any Claude Code session inside this project and it will call Copilot and Codex against your current diff, gather the findings, and hand them to Claude for triage.

Open the command file to see how it's wired up — it's a worked example of the pattern in this doc. Copy it into your own projects and adapt as needed.

## Note on Claude Code's own review plugin

Claude Code ships an official code-review plugin too. Install it alongside Copilot and Codex, not instead of them. Multiple reviewers is the whole point — adding Claude's own structured review to the mix is one more set of eyes, not a replacement for the others.
