---
name: setup-sentina
description: "Bootstrap a repo's .sentina/ configuration before any other Sentina skill runs. For a Sentina template clone: confirm its profile, run scaffold.py, and record the Notion connection in .sentina/manifiesto.yaml. For a generic repo with no vault: optionally wire up a Notion tasks database instead. Use when a repo has no .sentina/ config yet, when the user wants this repo's tasks connected to Notion, or before the first engineering flow in a freshly cloned Sentina repo."
---

# Setup Sentina

Bootstrap the per-repo configuration under `.sentina/` that other skills read. Which configuration depends on what kind of repo this is:

- A **Sentina template clone** gets the full scaffold: profile (`repo.tipo`), vault categories, and the Notion connection recorded in `.sentina/manifiesto.yaml`.
- A **generic repo** (no vault, no `scaffold.py`) has nothing to scaffold, but may still want its tasks tracked in Notion. That's a separate, lightweight file, `.sentina/notion-tasks.yaml`, that never implies the vault exists.
- A **personal-profile vault** (`.sentina/manifiesto.yaml` with `repo.tipo: personal`, see `.agents/sentina-mode.md`) is already fully configured for its own purpose; this skill only ever reviews it, never re-profiles it.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo before assuming anything:

- `git remote -v`: does the remote name match one of the four Sentina repo shapes (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`)?
- `.sentina/manifiesto.yaml`: does it already exist? If it declares `repo.tipo: personal`, stop: this is a personal-profile vault, not a product repo, and must not be re-profiled or connected to the delivery lifecycle. Otherwise the repo is already profiled: skip to step 6 and offer to review/update it instead of scaffolding from scratch.
- `.sentina/notion-tasks.yaml`: does it already exist? If so, this generic repo already opted into Notion task tracking: skip to step 6a and offer to review/update it instead.
- The scaffold: `.github/scripts/scaffold.py` (v3 layout), or `scaffold.py` at the repo root in a clone older than v3. Does either exist?
- `wiki/context/`, `wiki/bases/`, `wiki/schema/`, `wiki/products/`: which of these already exist, and do they look populated or empty?
- `CLAUDE.md` / `AGENTS.md`: does either already reference the Sentina skill set?

### 2. Branch on repo kind

- A scaffold exists: this is a Sentina template clone. Continue to step 3.
- No scaffold exists: this is a generic repo, not a Sentina clone. Skip straight to step 6a. Don't run `scaffold.py` or create `wiki/context/`, `wiki/bases/`, `wiki/schema/`, `wiki/products/` here: this repo has no vault, and inventing one it didn't ask for would be scaffolding infrastructure nothing else in the repo uses.

### 3. Present findings and confirm the profile

Summarize what's present and missing. Recommend a `repo.tipo` from the remote name (`sentina-brain` → `brain`, `sentina-web` → `web`, `sentina-ghl` → `ghl`, anything else → `cliente`), and confirm with the user before proceeding, one question at a time:

- **Profile.** State the recommended `--tipo` and ask for confirmation, or a correction.
- **Client details (only if `--tipo cliente`).** Ask for `--id <slug>`, `--nombre "<Nombre>"`, and one or two `--producto` values (`chatbot`, `agente-ia`, `automatizacion`, `workspace`).

### 4. Confirm and run scaffold

Show the exact command before running it:

```bash
python3 .github/scripts/scaffold.py --tipo <profile> [--id <slug> --nombre "<Nombre>" --producto <modulo> [--producto <modulo2>]]
# clon anterior al layout v3: python3 scaffold.py --tipo …
```

Explain what it does: writes `.env`, discriminates the manifest, creates categories and modules, re-identifies seed nodes, resets the vault's accounting, and runs the guardian. It refuses to run on an already-profiled repo or over modified seed nodes, so it's safe to offer even when unsure; it fails loudly instead of corrupting state.

Ask the user to confirm before running it. Do not run it unprompted.

### 5. Record the Notion connection

After scaffolding, `.sentina/manifiesto.yaml` exists but its `notion.tareas` and `notion.registro_de_cambios` database IDs are placeholders. Ask the user for the real Notion database IDs or URLs for:

- `notion.tareas`: the tasks/backlog database this repo's `ask-sentina` flow reads and writes (§11), the one `/to-tickets` publishes to, and the one a product repo's `CHANGELOG.md` Backlog section links to.
- `notion.registro_de_cambios`: the change-log database Notion AI meeting notes land in.

Write them into `.sentina/manifiesto.yaml` directly; don't invent a separate docs file, this manifest is already the single source of truth every Sentina skill reads.

Also record `notion.estados`: the status property name and the values for a new ticket, work started, and work done. `en_curso` is `En curso` and `completada` is `Completada` under §11; ask for `inicial`.

If the profile is `cliente`, also confirm `cliente.pagina_notion` (the client's Notion page ID) and `cliente.estado`.

### 6. Confirm secrets are names only

Read `secretos.requeridos` in the freshly written (or existing) manifest. Confirm with the user which secret **names** (never values) belong there for this repo's systems, and where they're actually managed (`secretos.gestionados_en`, e.g. `github-actions-secrets`). Never write a secret value into the manifest, or anywhere else in the repo.

Continue to step 7.

### 6a. Generic repo: optional Notion tasks

This repo isn't a Sentina template clone, so there's no vault and nothing to scaffold. The only thing worth asking is whether its tasks live in Notion.

Ask the user directly: does this repo's backlog live in a Notion database, or is it a fully local project with no Notion integration?

- **No Notion:** tell them no setup is needed here. Point them at `ask-sentina` for the generic development path (`grilling` → a plain spec in conversation → `tdd` → `code-review` → `git-workflow-and-versioning`). Stop; don't write anything.
- **Yes, Notion:** ask for the real database ID or URL, then write `.sentina/notion-tasks.yaml`:

  ```yaml
  notion:
    tareas: <db-id-or-url>
  ```

  Keep this file separate from `.sentina/manifiesto.yaml` on purpose: its presence only tells `ask-sentina`'s generic path where to pull and update tasks. It must never be mistaken for the Sentina-mode or Personal-mode signal in `.agents/sentina-mode.md`, and it must never trigger vault-only behavior (`wiki/context/`, `tasks/`, GHL tag rules) in any other skill. This repo still has no vault after writing it. It's also not the same thing as Personal mode: Personal mode is a vault with no Notion; this is Notion with no vault.

Continue to step 7.

### 7. Done

Tell the user setup is complete.

- **Sentina clone:** show the final `.sentina/manifiesto.yaml`, and name the first skill to run next: `grill-me`, or `ask-sentina` if they're unsure where to start. Mention that re-running this skill on an already-profiled repo only reviews and updates the Notion IDs and secret names, since `scaffold.py` itself refuses to run twice.
- **Generic repo:** show the final `.sentina/notion-tasks.yaml` if one was written, and point at `ask-sentina` for the generic path. Mention that re-running this skill here only reviews and updates the Notion database ID, since there's no vault or `scaffold.py` involved.
