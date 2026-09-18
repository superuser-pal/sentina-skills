Skills are organized into bucket folders under `skills/`:

- `engineering/`: daily code work
- `productivity/`: daily non-code workflow tools
- `misc/`: kept around but rarely used, not promoted
- `in-progress/`: beta: public on purpose, feedback wanted, not shipped in the default plugin
- `deprecated/`: no longer used

Every skill in `engineering/` or `productivity/` (the **promoted** buckets) must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`'s `skills` array. Skills in `misc/`, `in-progress/`, and `deprecated/` must not appear in either.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`. The promoted buckets' `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**; non-promoted bucket `README.md`s (`misc/`, `in-progress/`) use a flat list.

### Dual Harness Compatibility: Claude Code and Codex

1. **Claude Code**:
   - Registered in `.claude-plugin/plugin.json`.
   - User-invoked skills set `disable-model-invocation: true` in their `SKILL.md` frontmatter.

2. **Codex**:
   - Registered in `.codex-plugin/plugin.json` pointing to `./skills/`.
   - Every skill carries an `agents/openai.yaml` beside its `SKILL.md` declaring `interface.display_name` and `interface.short_description`.
   - User-invoked skills declare `policy.allow_implicit_invocation: false` in `agents/openai.yaml` to match `disable-model-invocation: true`.

Every `SKILL.md` is either user-invoked (reachable only by the human) or model-invoked (reachable autonomously by the agent or explicitly by the human). See [.agents/invocation.md](./.agents/invocation.md).

Skills that assume Sentina infrastructure (Notion, the vault, `evidencia/`) must detect that from `.sentina/manifiesto.yaml` rather than assuming it, so the same globally-installed skills also work in a personal project. See [.agents/sentina-mode.md](./.agents/sentina-mode.md).

[`ask-sentina`](./skills/engineering/ask-sentina/SKILL.md) is the router that maps every user-reachable skill and how they relate to the Sentina development lifecycle. Whenever you add, rename, remove, or change how a skill fits the flow, keep `ask-sentina`'s `SKILL.md` synchronized.

To (re)link every skill outside `deprecated/` and `misc/` into local harness skill directories (`~/.claude/skills`, `~/.agents/skills`), run `scripts/link-skills.sh`. Each entry is a symlink into this repo, so a `git pull` keeps installed skills current; re-run the script after adding, removing, or renaming a skill.

No em-dashes anywhere in this repo's prose (`SKILL.md` files, `README.md`, `CHANGELOG.md`, code comments). Where a sentence reaches for one, rewrite it instead with a comma, colon, period, parentheses, or a conjunction, whichever the sentence actually wants; never do a blind character substitution.
