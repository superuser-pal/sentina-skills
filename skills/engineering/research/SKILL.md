---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads.

Its job:

1. Investigate the question against **primary sources** (official docs, source code, specs, first-party APIs), not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it where the repo keeps such notes. In a Sentina or personal repo (`.sentina/manifiesto.yaml` exists) that is `inbox/research-<slug>.md`: raw material that `/wiki-ingest` later compiles into the vault (`.agents/sentina-mode.md` § Output routing). Elsewhere, match the existing convention, and if there is none, put it somewhere sensible and say where.
