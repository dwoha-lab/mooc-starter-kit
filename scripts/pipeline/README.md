# Pipeline scripts

A staged journalism pipeline: fetch → clean → process → save. Each stage is its own bash script in this folder, and each one only does one thing.

## The stages

| Stage | Script | Owns | Reads from | Writes to |
|-------|--------|------|------------|-----------|
| 1 | `01-fetch.sh` | grabbing the bytes | a source directory | `./work/01-raw/` |
| 2 | `02-clean.sh` | making text safe to feed a model | `./work/01-raw/` | `./work/02-clean/` |
| 3 | `03-process.sh` | the model call and prompt shape | `./work/02-clean/` | `./work/03-processed/` |
| 4 | `04-save.sh` | final artifact and naming | `./work/03-processed/` | `./output/digest-YYYY-MM-DD.md` |

Stages communicate through files in `./work/` (staging) and `./output/` (final). No global variables, no shared state, no surprises.

## Why stages

- **One job per script.** When something breaks, you know which stage owns it.
- **Testable.** You can re-run stage 3 without re-fetching or re-cleaning. The work directory is the cache.
- **Swappable.** Swap `02-clean.sh` for a Python cleaner, or `03-process.sh` for a different model. The contract is the directory layout, not the language.
- **Chainable.** Add a stage 5 (publish to a CMS, post to Slack, append to a sheet) without touching the earlier ones.

This ties to video C1 — "don't write one big script that does everything."

## Run the full pipeline

```bash
cd scripts/pipeline
./run-all.sh
```

That runs 01 → 02 → 03 → 04 against `sample-docs/` by default. Pass a different source directory as the first argument:

```bash
./run-all.sh /path/to/my/beat-docs
```

Or run a single stage to debug it:

```bash
./01-fetch.sh
./02-clean.sh
# inspect ./work/02-clean/ here
./03-process.sh
./04-save.sh
```

## Test small

Don't run this on 5,000 files the first time. Run it on 5. The `sample-docs/` folder has 7 — that's the right size to learn the shape. Once you trust the pipeline, point it at your real corpus.

## Secret hygiene

- `claude` reads `ANTHROPIC_API_KEY` from your environment. Don't hardcode it in any script.
- Don't commit your `./work/` or `./output/` folders if they contain anything sensitive — add them to `.gitignore`.
- If you swap in another API in stage 3, put its key in an env var too. Never paste keys into prompts, comments, or filenames.

## Why not one big script

You can write one 200-line script that does all four jobs. People do. Then a stage breaks and you re-run the whole thing. Then you want to swap the cleaner and you can't because it's tangled with the fetcher. Then you can't tell which step is slow. Stages cost you 30 seconds of structure and pay you back every time you debug.
