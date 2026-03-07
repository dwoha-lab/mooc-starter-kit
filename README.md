# Advanced prompt engineering for journalists — starter kit

A starter repo for the [Knight Center](https://knightcenter.utexas.edu/) MOOC on using AI coding tools from the command line. Fork this repo, clone your fork, and use it as your workspace for all four modules.

**Course site:** [mooc.amditis.tech](https://mooc.amditis.tech)

---

### Instructor

**Joe Amditis** | [Center for Cooperative Media](https://centerforcooperativemedia.org), Montclair State University

[GitHub](https://github.com/jamditis) | [Substack](https://strugglestreet.substack.com) | [Twitter](https://twitter.com/jsamditis)

---

## What this repo is

This is your workspace for the course. It contains:

- A **starter context file** (`CLAUDE.md`) with placeholder sections you'll customize for your beat
- **Sample journalism documents** you'll use in exercises (press releases, meeting minutes, interview notes)
- **Skill templates** you'll modify and extend in Module 2
- **Starter scripts** for the pipeline exercise in Module 3
- **MCP configuration examples** for connecting AI to your documents in Module 4
- An **empty archive folder** where you'll add documents for the Module 4 RAG exercise

By the end of the course, this repo will be a working AI-assisted journalism toolkit — documented, version-controlled, and shareable.

## Getting started

### 1. Fork this repo

Click the **Fork** button at the top right of this page. This creates your own copy on GitHub that you can push to freely.

### 2. Clone your fork

Open a terminal and run:

```bash
git clone https://github.com/YOUR-USERNAME/mooc-starter-kit.git
cd mooc-starter-kit
```

Replace `YOUR-USERNAME` with your GitHub username.

### 3. Install the tools

You need [Node.js](https://nodejs.org/) (version 20+) and at least one AI CLI tool:

| Tool | Install | Cost |
|------|---------|------|
| **Gemini CLI** | `npm install -g @google/gemini-cli` | Free (1,000 req/day with Google account) |
| **Claude Code** | `npm install -g @anthropic-ai/claude-code` | Requires Claude Max ($20/mo) or API key |
| **Codex CLI** | `npm install -g @openai/codex` | Requires OpenAI API key |

The course exercises use Claude Code, but the concepts apply to all three tools.

### 4. Start the first exercise

Open the [Module 1 exercise](https://mooc.amditis.tech/module-1/) on the course site and follow the instructions.

## What's in each folder

```
mooc-starter-kit/
|
|-- CLAUDE.md               <-- Your context file (Module 1)
|                                Edit this with your beat, style rules, and source standards.
|                                Claude reads it at the start of every session.
|
|-- sample-docs/             <-- Sample journalism documents (Module 1)
|   |-- council-minutes-excerpt.md
|   |-- press-release-park-closure.md
|   |-- interview-notes-martinez.md
|   |-- tip-email.md
|   |-- sample-article.html
|   |-- sample-transcript.txt
|   +-- viral-claim-example.md
|
|-- skills/                  <-- Skill templates (Module 2)
|   |-- my-first-skill.md        A minimal template to copy and customize
|   +-- newsroom-style.md        A complete AP style skill with examples
|
|-- scripts/                 <-- Starter shell scripts (Module 3)
|   |-- summarize-article.sh     Single-file summarization
|   +-- batch-process.sh         Multi-file batch processing
|
|-- mcp-configs/             <-- MCP configuration examples (Module 4)
|   |-- filesystem-example.json  Example config for connecting Claude to local files
|   +-- README.md                How MCP configuration works
|
+-- beat-archive/            <-- Your document archive (Module 4)
    +-- README.md                Instructions for adding documents
```

## Which module uses what

| Module | Week | What you'll work with |
|--------|------|-----------------------|
| **1 — From chat window to command line** | 1 | `CLAUDE.md`, `sample-docs/` |
| **2 — Custom skills** | 2 | `skills/`, plus new skills you create |
| **3 — CLI workflows** | 3 | `scripts/`, plus pipelines you build |
| **4 — Agents, tools, and data access** | 4 | `mcp-configs/`, `beat-archive/`, final project |

## Related repositories

- **[Journalism skills library](https://github.com/jamditis/claude-skills-journalism)** — 36 pre-built Claude Code skills for journalism (source verification, FOIA requests, data journalism, editorial workflows). Browse for ideas or install individual skills.
- **[NICAR 2026: Skills in Codex and Claude](https://github.com/amkessler/nicar2026_skills_in_codex_claude)** — Aaron Kessler's NICAR session repo with examples of building and using skills across Claude Code and OpenAI Codex CLI for data journalism workflows.
- **[AI tools for newsrooms](https://github.com/jamditis/tools)** — A curated collection of AI tools and resources for journalists and newsrooms.

## License

Course materials are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You may share and adapt for any purpose with attribution.

**Attribution:** Joe Amditis, Center for Cooperative Media, Montclair State University. Course hosted by the Knight Center for Journalism in the Americas at the University of Texas at Austin.
