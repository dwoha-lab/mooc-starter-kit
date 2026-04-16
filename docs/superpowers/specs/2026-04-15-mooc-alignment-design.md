# MOOC starter kit alignment — design spec

**Date:** 2026-04-15
**Branch:** `feat/mooc-alignment-2026-04`
**Scope:** Option C (full rebuild)

## Why

The `mooc-starter-kit` repo has been frozen since March 19, 2026. Since then, `mooc.amditis.tech` and the module videos have shifted what they actually teach. The biggest mismatch is Module 4 — the kit still ships MCP configs and a `beat-archive/` RAG exercise, but the course now teaches context management, sub-agents, and cross-model review. Modules 1–3 are less wrong but still under-equipped. This spec rewrites the kit so a student who forks it in week one finds the exact shapes the videos talk about.

## What students should experience

A student who watches Module 1 and forks this repo should, by the end of week one, be able to:

1. Run `cd mooc-starter-kit && claude` and have the session already feel different from a generic project
2. See a worked `CLAUDE.md` example (city council beat) alongside their own scaffold
3. Understand the three-layer context system (global, project, session) without leaving the repo
4. Find `MEMORY.md` and `LESSONS.md` files that show the memory-and-lessons pattern from video A2
5. Read a `docs/module-map.md` that tells them exactly which file matches which video

A student working through Module 2 should see:

1. Real Claude Code skills with YAML frontmatter and progressive disclosure — not markdown docs
2. A `.claude/commands/` directory with at least two working slash commands
3. A `.claude/hooks.json` one-way-door guardrail
4. A minimal `plugin.json` + plugin skeleton showing the shape Joe demos in B2
5. A pointer to `claude-skills-journalism` for more

A student working through Module 3 should find:

1. Scripts rewritten to show the fetch → clean → process → save pattern
2. A working `.github/workflows/` example demonstrating the hybrid cloud-detect/local-process pattern (read-only on public data)
3. An `examples/mamdani-mini/` folder with synthetic local-council video metadata + the pipeline prompts that would build a dashboard from it — no real scraping, just the shape
4. Clear secret-hygiene guidance and env-var examples

A student working through Module 4 should find:

1. `docs/context-management.md` — walkthrough of `/effort`, `/context`, `/compact`, the 40% rule, sub-agents, double-escape rewind
2. `docs/cross-model-review.md` — how to call Copilot CLI and Codex with `-p` from inside Claude Code
3. `docs/four-questions.md` — the tool-selection framework from video D4
4. A slim `mcp-configs/` section repositioned as "optional advanced" — not the spine of Module 4 anymore
5. `examples/rag-archive/` (renamed from `beat-archive/`) framed as an optional local RAG exercise, not the Module 4 centerpiece

## New directory layout

```
mooc-starter-kit/
├── README.md                      # rewritten — maps structure to modules
├── CLAUDE.md                      # scaffold with teaching comments
├── AGENTS.md                      # stub for Codex users
├── GEMINI.md                      # stub for Gemini users
├── MEMORY.md                      # example memory index
├── LESSONS.md                     # example lessons pattern
│
├── .claude/
│   ├── commands/
│   │   ├── beat-brief.md          # /beat-brief — summarize today's docs
│   │   ├── cross-review.md        # /cross-review — copilot + codex -p
│   │   └── verify-claim.md        # /verify-claim — SIFT walk-through
│   └── hooks.json                 # one-way-door guardrail example
│
├── skills/
│   ├── newsroom-style/
│   │   └── SKILL.md               # converted to real skill format
│   └── first-skill/
│       └── SKILL.md               # minimal template
│
├── plugin/                        # minimal plugin skeleton
│   ├── plugin.json
│   └── skills/
│       └── beat-brief/
│           └── SKILL.md
│
├── scripts/
│   ├── pipeline/
│   │   ├── 01-fetch.sh            # fetch stage
│   │   ├── 02-clean.sh            # clean stage
│   │   ├── 03-process.sh          # process stage
│   │   └── 04-save.sh             # save stage
│   └── legacy/
│       ├── summarize-article.sh   # kept for reference
│       └── batch-process.sh       # kept for reference
│
├── .github/workflows/
│   └── weekly-digest.yml          # Module 3 cloud-detect example
│
├── sample-docs/                   # unchanged — still the Greenfield beat
│   └── ...
│
├── examples/
│   ├── worked-claude-md/
│   │   └── CLAUDE.md              # fully written city council CLAUDE.md
│   ├── mamdani-mini/
│   │   ├── README.md
│   │   ├── sample-data/           # synthetic council video metadata
│   │   ├── prompts/               # the pipeline prompts from video B1
│   │   └── dashboard-skeleton.html
│   └── rag-archive/               # renamed from beat-archive/
│       └── README.md
│
├── mcp-configs/                   # slimmed — now marked as optional
│   ├── README.md
│   └── filesystem-example.json
│
├── docs/
│   ├── module-map.md              # file/folder ↔ module/video index
│   ├── context-management.md      # Module 4 walkthrough
│   ├── cross-model-review.md      # Module 4 walkthrough
│   ├── four-questions.md          # tool-selection framework
│   └── superpowers/
│       └── specs/
│           └── 2026-04-15-mooc-alignment-design.md  # this doc
│
├── og-image.png                   # unchanged
├── LICENSE                        # unchanged
├── .gitignore                     # unchanged
└── CLAUDE.md                      # scaffold (referenced above)
```

## File-by-file change list

### Root context files

- **`CLAUDE.md`** — rewrite. Keep the scaffold model, but richer teaching comments that point at `examples/worked-claude-md/CLAUDE.md` as the "here's what filled-in looks like." Add a short section on the remove-a-line heuristic from video A2. Add a cross-reference to `MEMORY.md` and `LESSONS.md`.
- **`AGENTS.md`** — new. Short stub explaining this repo also works with OpenAI Codex; call out the `agents.md` convention and `-p` flag.
- **`GEMINI.md`** — new. Same shape for Gemini CLI. Mention the free tier limit and `-p` flag.
- **`MEMORY.md`** — new. Example of the four memory types (user, feedback, project, reference) as an index file pointing to stub memory files. One stub per type.
- **`LESSONS.md`** — new. Joe's custom pattern: a single rolling log file where corrections become rules. Seed with one example lesson.

### Skills (converted to real format)

Both existing skills become directories with `SKILL.md` files carrying YAML frontmatter:

- **`skills/newsroom-style/SKILL.md`** — convert existing content. Frontmatter triggers on writing/editing news. Add a templates subfolder with one AP-style-before/after example.
- **`skills/first-skill/SKILL.md`** — rewrite the "my first skill" template into the real format. Minimal but complete.

### Commands

- **`.claude/commands/beat-brief.md`** — slash command that reads `sample-docs/` and drafts a short daily briefing. Simple prompt, demonstrates the shape.
- **`.claude/commands/cross-review.md`** — calls `copilot -p` and `codex exec -p` against the current git diff. Demonstrates the Module 4 cross-model review pattern. Includes a note that subscription plans are expected.
- **`.claude/commands/verify-claim.md`** — walks through the SIFT method on a given claim. Demonstrates skill/command distinction.

### Hooks

- **`.claude/hooks.json`** — one hook: a `PreToolUse` guardrail that fires when about to write a database schema or run `rm -rf` on anything outside the current directory. Non-blocking warning, not a hard stop. Mirrors the "one-way door" pattern from video B1.

### Plugin skeleton

- **`plugin/plugin.json`** — minimal manifest. Name: `mooc-beat-toolkit`. Version: `0.1.0`. One skill reference.
- **`plugin/skills/beat-brief/SKILL.md`** — real skill that demonstrates the plugin-vs-project-skills distinction from video B2.

### Scripts (rewritten to staged pipeline)

- **`scripts/pipeline/01-fetch.sh`** — reads one local sample doc, copies to a `work/` staging directory
- **`scripts/pipeline/02-clean.sh`** — strips HTML, normalizes whitespace
- **`scripts/pipeline/03-process.sh`** — calls `claude -p` with a beat-specific prompt
- **`scripts/pipeline/04-save.sh`** — writes output to `output/` with a timestamped filename
- Each stage has a header comment: "what this stage owns, what it hands off"
- **`scripts/legacy/`** — the two original scripts, kept as-is with a note explaining they're the "before" version

### GitHub Actions

- **`.github/workflows/weekly-digest.yml`** — scheduled weekly. Reads files from `sample-docs/`, runs the pipeline scripts against them, writes a digest to `output/` and commits. Uses the student's own API key via GitHub Secrets (documented in the workflow comments). Fail-gracefully if secret is missing so the workflow doesn't nag students who haven't set it up.
- Includes the secret-hygiene warning from video C1 inline as comments.

### Examples

- **`examples/worked-claude-md/CLAUDE.md`** — a fully written city council beat CLAUDE.md for a fictional reporter covering Greenfield (matching `sample-docs/`). Includes beat description, key people, style rules, source standards, terminology, avoid-patterns. ~80 lines, instructive density.

- **`examples/mamdani-mini/`** — the scaled-down version of video B1's demo:
  - `README.md` — explains this is the "here's the shape" version, not a runnable scrape
  - `sample-data/videos.json` — 5 synthetic council meeting video entries (fake titles, URLs, durations, transcripts)
  - `prompts/01-discover.md` — the video-discovery prompt shape
  - `prompts/02-transcribe.md` — the transcription prompt shape (notes Whisper turbo)
  - `prompts/03-dashboard.md` — the dashboard-build prompt shape (calls the Anthropic front-end design skill)
  - `dashboard-skeleton.html` — a static HTML page that would be the output target

- **`examples/rag-archive/`** — the old `beat-archive/` renamed. README updated to reframe it as "if you want to do local RAG over your own docs as an optional exercise, here's the folder."

### MCP configs (slimmed)

- **`mcp-configs/README.md`** — rewrite top section to say "MCP is still useful for specific integrations but is no longer the centerpiece of Module 4. See `docs/context-management.md` and `docs/cross-model-review.md` for the current Module 4 material."
- **`mcp-configs/filesystem-example.json`** — kept as-is.

### Docs folder

- **`docs/module-map.md`** — a table mapping every file in the repo to the module and video that uses it. This is the "where does this go?" index.
- **`docs/context-management.md`** — walkthrough of `/effort`, `/context`, `/compact`, the 40% rule, sub-agents, double-escape rewind. Includes placeholder `[screenshot]` markers where Joe can drop in screenshots later.
- **`docs/cross-model-review.md`** — the full cross-model review recipe. Install steps for Copilot CLI and Codex CLI. Example prompts. The `-p` flag pattern. Notes on isolated context windows.
- **`docs/four-questions.md`** — the tool-selection framework from video D4: what's the task, how much context, does it need tools, how cost-sensitive. Each question gets a short section with worked examples.

### README

- **`README.md`** — full rewrite:
  - Opening paragraph stays (Knight Center + course site link)
  - New "What this repo is" section reflects the rebuilt structure
  - "Getting started" simplified to match the "only cd and claude" direction from recent site commits
  - "Which module uses what" table rebuilt from `docs/module-map.md`
  - "What's in each folder" tree rebuilt
  - "Related repositories" preserved + emphasized

## Out of scope

- No new sample journalism documents — the Greenfield beat set is already good
- No rewrite of the existing `og-image.png`
- No touching `LICENSE` or `.gitignore`
- No changes to the course site itself — this is the kit only
- No real scraping in `examples/mamdani-mini/` — synthetic data only
- No screenshots in Module 4 docs — placeholders for Joe to fill in later
- No CI green-check chasing — if GitHub Actions fails on first run due to missing secrets, that's fine (documented)

## Commit strategy

One feature branch, multiple commits grouped by domain:

1. `docs: add alignment design spec`
2. `core: rewrite root context files (CLAUDE, MEMORY, LESSONS, AGENTS, GEMINI)`
3. `skills: convert to real SKILL.md format`
4. `commands: add .claude/commands/ with three worked slash commands`
5. `hooks: add one-way-door hooks.json example`
6. `plugin: add minimal plugin.json skeleton`
7. `scripts: rewrite as staged pipeline, keep originals as legacy`
8. `ci: add weekly-digest GitHub Actions workflow`
9. `examples: add worked-claude-md, mamdani-mini, rename beat-archive → rag-archive`
10. `mcp: slim mcp-configs to optional-advanced framing`
11. `docs: add module-map, context-management, cross-model-review, four-questions`
12. `readme: rewrite to reflect new structure`

## Risks and decisions made autonomously

1. **Beat for worked example:** Picked Greenfield city council to match existing `sample-docs/`. Any other choice would have orphaned the sample documents.

2. **No PR merge:** Per Joe's memory rules, never merge own PRs. Branch gets pushed, PR opened, Copilot review triggered, Joe merges when back.

3. **Screenshots deferred:** Module 4 docs use `[screenshot: /context output]` placeholders. Taking real screenshots would require running an interactive Claude Code session, which isn't clean in this autonomous mode.

4. **`mamdani-mini` is synthetic:** Real scraping would pull from public social accounts and risks surfacing real people's content in a public starter kit. Synthetic data preserves the pedagogical shape without that risk.

5. **MCP preserved but demoted:** Joe has talked about MCP being real but token-heavy in videos. The kit still ships the filesystem example because students may want it for their final projects — but it's no longer load-bearing for any module.

## Success criteria

- A student reading `docs/module-map.md` can find, for every video, at least one file in the repo that corresponds to it
- Every directory has a `README.md` or equivalent header explaining what it's for
- The repo passes a `claude -p "read this whole repo and tell me what course it's for"` smell test
- No Title Case anywhere in the new content, no banned words, no AI-attribution boilerplate
- The PR body documents every changed directory and why
