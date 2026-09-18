---
name: setup-sentina
description: "Scaffold a fresh Sentina repo clone: confirm its profile, run scaffold.py, and record the Notion connection in .sentina/manifiesto.yaml. Run once before the first engineering flow."
disable-model-invocation: true
---

# Setup Sentina

Scaffold the per-repo configuration every other Sentina skill assumes already exists: the repo's profile (`repo.tipo`), its vault categories, and the Notion connection recorded in `.sentina/manifiesto.yaml`.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo before assuming anything:

- `git remote -v`: does the remote name match one of the four Sentina repo shapes (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`)?
- `.sentina/manifiesto.yaml`: does it already exist? If so, this repo is already profiled: skip to step 5 and offer to review/update it instead of scaffolding from scratch.
- `scaffold.py` at the repo root: does it exist? Without it, this repo isn't a Sentina template clone and scaffolding can't run here; tell the user and stop.
- `contexto/`, `bases/`, `esquema/`, `producto/`: which of these already exist, and do they look populated or empty?
- `CLAUDE.md` / `AGENTS.md`: does either already reference the Sentina skill set?

### 2. Present findings and confirm the profile

Summarize what's present and missing. Recommend a `repo.tipo` from the remote name (`sentina-notion` → `notion`, `sentina-web` → `web`, `sentina-ghl` → `ghl`, anything else → `cliente`), and confirm with the user before proceeding, one question at a time:

- **Profile.** State the recommended `--tipo` and ask for confirmation, or a correction.
- **Client details (only if `--tipo cliente`).** Ask for `--id <slug>`, `--nombre "<Nombre>"`, and one or two `--producto` values (`chatbot`, `agente-ia`, `automatizacion`, `workspace`).

### 3. Confirm and run scaffold

Show the exact command before running it:

```bash
python3 scaffold.py --tipo <profile> [--id <slug> --nombre "<Nombre>" --producto <modulo> [--producto <modulo2>]]
```

Explain what it does: writes `.env`, discriminates the manifest, creates categories and modules, re-identifies seed nodes, resets the vault's accounting, and runs the guardian. It refuses to run on an already-profiled repo or over modified seed nodes, so it's safe to offer even when unsure; it fails loudly instead of corrupting state.

Ask the user to confirm before running it. Do not run it unprompted.

### 4. Record the Notion connection

After scaffolding, `.sentina/manifiesto.yaml` exists but its `notion.tareas` and `notion.registro_de_cambios` database IDs are placeholders. Ask the user for the real Notion database IDs or URLs for:

- `notion.tareas`: the tasks/backlog database this repo's `ask-sentina` flow reads and writes (§11), and the one a product repo's `CHANGELOG.md` Backlog section links to.
- `notion.registro_de_cambios`: the change-log database Notion AI meeting notes land in.

Write them into `.sentina/manifiesto.yaml` directly; don't invent a separate docs file, this manifest is already the single source of truth every Sentina skill reads.

If the profile is `cliente`, also confirm `cliente.pagina_notion` (the client's Notion page ID) and `cliente.estado`.

### 5. Confirm secrets are names only

Read `secretos.requeridos` in the freshly written (or existing) manifest. Confirm with the user which secret **names** (never values) belong there for this repo's systems, and where they're actually managed (`secretos.gestionados_en`, e.g. `github-actions-secrets`). Never write a secret value into the manifest, or anywhere else in the repo.

### 6. Done

Tell the user setup is complete, show the final `.sentina/manifiesto.yaml`, and name the first skill to run next: `/grill-me`, or `/ask-sentina` if they're unsure where to start. Mention that re-running this skill on an already-profiled repo only reviews and updates the Notion IDs and secret names, since `scaffold.py` itself refuses to run twice.
