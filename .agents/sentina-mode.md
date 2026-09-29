# Sentina mode, personal mode, and generic mode

A skill in this repo runs in one of three kinds of target repo: a real Sentina product repo, a personal knowledge repo built on the Sentina vault template, or an ordinary project with no Sentina infrastructure. The split is a passive file check, never a prompt.

- **Sentina mode**: `.sentina/manifiesto.yaml` exists at the target repo's root and its `repo.tipo` is anything other than `personal` (`notion`, `web`, `ghl`, `cliente`, ...). `setup-sentina` writes this file once, on a freshly cloned Sentina repo; every skill below treats it as the signal that this repo follows the Notion-driven Sentina lifecycle (the vault under `contexto/`, `evidencia/<id>/`, GHL tag rules, `feat/tarea-*` branches, the anti-rationalization tables).
- **Personal mode**: `.sentina/manifiesto.yaml` exists and declares `repo.tipo: personal`. The repo may reuse the Sentina vault schema for durable personal knowledge, or be an ordinary personal project with only a minimal manifest. It has no Sentina delivery lifecycle, no client, no GHL, and no `evidencia/` gate. Treat it like generic mode for every lifecycle rule, with two differences: where it has a vault, the repo's own `AGENTS.md` is the only authority for where knowledge lives and how it is written (never create a parallel `CONTEXT.md`); and where its manifest names a task database, `/to-tickets` publishes there and `ask-sentina`'s generic path keeps the status current, without the Sentina lock or GitHub Actions transitions.
- **Generic mode**: that file doesn't exist. This covers both an ordinary personal project and a Sentina repo that's been cloned but not yet profiled, and both cases want the same fallback: there's no vault to write into yet, so plain SDLC practice is the only thing that's actually safe to do.

Check once per session (a repo doesn't change mode mid-session), and never ask the user which mode they're in: the file check, plus reading `repo.tipo` when the file exists, is the whole mechanism.

## Two patterns, matched to how a skill is reached

- **Model-invoked skills that auto-fire regardless of what the user typed** (`domain-modeling`, `git-workflow-and-versioning`, `code-review`, `security-and-hardening`) branch in place: Sentina-mode behavior stays exactly as documented, and generic and personal mode get a real fallback to plain SDLC practice, not a refusal. In personal mode, anything the fallback would write as project knowledge follows the repo's own `AGENTS.md` instead.
- **User-invoked skills whose entire value is Sentina infrastructure with no generic equivalent** (`grill-me`, `to-spec`, `implement`, `acceptance-test`) stop and redirect in both generic and personal mode: tell the user this skill assumes a Sentina product repo, and point at `ask-sentina`'s generic path. This mirrors the stop-and-explain pattern `setup-sentina` already uses when it can't find `scaffold.py`.

`setup-sentina` never scaffolds or re-profiles a personal repo, since that would pull it into the delivery lifecycle. In personal mode it only records the task database in the manifest's `notion` block.

## Task routing

Where tasks go is decided per repo, by the manifest, never by classifying a task. `notion.tareas` (or `notion.tareas_<entorno_activo>`) names the database in both modes: Sentina repos record an ID, personal repos record a name (`"<Parent page>/<Database>"`) so no Notion ID enters git. `notion.proyecto` optionally names the canonical project ID new tasks link to, and `notion.estados` maps the status property and its `inicial`, `en_curso`, and `completada` values. `/to-tickets` holds the full resolution rules.
