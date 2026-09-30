# Sentina mode, personal mode, and generic mode

A skill in this repo runs in one of three kinds of target repo: a real Sentina product repo, a personal knowledge repo built on the Sentina vault template, or an ordinary project with no Sentina infrastructure. The split is a passive file check, never a prompt.

- **Sentina mode**: `.sentina/manifiesto.yaml` exists at the target repo's root and its `repo.tipo` is anything other than `personal` (`notion`, `web`, `ghl`, `cliente`, ...). `setup-sentina` writes this file once, on a freshly cloned Sentina repo; every skill below treats it as the signal that this repo follows the Notion-driven Sentina lifecycle (the vault under `wiki/`, `tasks/<id>/`, GHL tag rules, `feat/tarea-*` branches, the anti-rationalization tables).
- **Personal mode**: `.sentina/manifiesto.yaml` exists and declares `repo.tipo: personal`. The repo may reuse the Sentina vault schema for durable personal knowledge, or be an ordinary personal project with only a minimal manifest. It has no Sentina delivery lifecycle, no client, no GHL, and no `tasks/<id>/` evidence gate. Treat it like generic mode for every lifecycle rule, with two differences: where it has a vault, the repo's own `AGENTS.md` is the only authority for where knowledge lives and how it is written (never create a parallel `CONTEXT.md`); and where its manifest names a task database, `/to-tickets` publishes there and `ask-sentina`'s generic path keeps the status current, without the Sentina lock or GitHub Actions transitions.
- **Generic mode**: that file doesn't exist. This covers both an ordinary personal project and a Sentina repo that's been cloned but not yet profiled, and both cases want the same fallback: there's no vault to write into yet, so plain SDLC practice is the only thing that's actually safe to do.

Check once per session (a repo doesn't change mode mid-session), and never ask the user which mode they're in: the file check, plus reading `repo.tipo` when the file exists, is the whole mechanism.

## A Generic-mode opt-in: `.sentina/notion-tasks.yaml`

A generic-mode repo (no `.sentina/manifiesto.yaml` at all) can still track its tasks in Notion without becoming Sentina mode or Personal mode: `setup-sentina` can write `.sentina/notion-tasks.yaml` (just `notion.tareas: <db-id>`) for an ordinary project whose backlog lives in Notion but has no vault. This is not a fourth mode and never gates any skill's Sentina-mode or Personal-mode branch, ever: only `ask-sentina`'s generic path reads it, to know where to pull and update tasks. A repo with only this file still has no vault, no `tasks/<id>/` evidence schema, and no GHL rules, exactly like any other generic-mode repo.

Don't confuse this with Personal mode above: Personal mode is a vault with no Notion; this file is the opposite, Notion with no vault. A skill that branches on `.sentina/manifiesto.yaml` presence or `repo.tipo` must never treat `.sentina/notion-tasks.yaml` as equivalent to either.

## Two patterns, matched to how a skill is reached

- **Model-invoked skills that auto-fire regardless of what the user typed** (`domain-modeling`, `git-workflow-and-versioning`, `code-review`, `security-and-hardening`, `ask-sentina`, `setup-sentina`) branch in place: Sentina-mode behavior stays exactly as documented, and generic and personal mode get a real fallback to plain SDLC practice, not a refusal. In personal mode, anything the fallback would write as project knowledge follows the repo's own `AGENTS.md` instead.
- **User-invoked skills whose entire value is Sentina infrastructure with no generic equivalent** (`grill-me`, `to-spec`, `implement`, `acceptance-test`) stop and redirect in both generic and personal mode: tell the user this skill assumes a Sentina product repo, and point at `ask-sentina`'s generic path.

`setup-sentina` is itself the branch, across three cases: `.sentina/manifiesto.yaml` present with `repo.tipo: personal` means stop, it's already profiled as a personal vault, and re-profiling it as a product repo would pull it into the delivery lifecycle. Present with any other `repo.tipo` means offer to review or update the existing Sentina product profile. Absent means check `.github/scripts/scaffold.py` (or a root `scaffold.py` in a clone older than the v3 layout): present means a genuine Sentina clone, run the full scaffold; absent means a generic repo, where it only ever offers the lightweight `.sentina/notion-tasks.yaml` opt-in above, never the vault. Being model-invoked, the agent may call it proactively when a repo has neither `.sentina/manifiesto.yaml` nor `.sentina/notion-tasks.yaml` yet, but should offer it once, not re-ask on every turn once the user has answered.

## Where files go: resolve paths, never hardcode them

In Sentina and personal mode, every path below is resolved from the target repo, not assumed:

- `REPO` is the directory holding `.sentina/manifiesto.yaml`.
- `VAULT` is `$REPO/$OBSIDIAN_VAULT_PATH`, read from `$REPO/.env`. In the current layout (`version_esquema: 3` in the manifest) that is `$REPO/wiki`.
- A category is a folder of `VAULT` listed in `OBSIDIAN_CATEGORIES`. Read the list; don't assume a profile has a given category.

Paths in these skills are written for the v3 layout. The table is the full contract, plus what each path was called in the v2 layout, for a repo that hasn't migrated yet (`version_esquema: 2`, `OBSIDIAN_VAULT_PATH=.`):

| What | v3 (current) | v2 (not yet migrated) |
|---|---|---|
| Architecture node | `wiki/context/architecture.md` | `contexto/arquitectura.md` |
| Glossary | `wiki/context/glossary.md` | `contexto/glosario.md` |
| Decision | `wiki/context/decisions/dec-<slug>.md` | `contexto/decisiones/dec-<slug>.md` |
| External system stub | `wiki/context/systems/sistema-<x>.md` | `contexto/sistemas/sistema-<x>.md` |
| Other external stub | `wiki/context/references/<stem>.md` | `contexto/referencias/<stem>.md` |
| Client identity / scope (client repos) | `wiki/context/client.md`, `wiki/context/scope.md` | `contexto/cliente.md`, `contexto/alcance.md` |
| GHL tag dictionary / webhook contract | `wiki/schema/etiquetas.md`, `wiki/webhooks/endpoints.md` | `esquema/etiquetas.md`, `webhooks/endpoints.md` |
| Product module (client repos) | `wiki/products/<tipo>/` | `producto/<tipo>/` |
| Everything for one delivery task | `tasks/<id>/` | `evidencia/<id>/` |
| Raw material until `/wiki-ingest` (gitignored) | `inbox/` | `entrada/` |
| One-off dated document | `reports/` | `reportes/` |
| Something a machine runs | `ops/` | `operativo/` |

Only folder and canonical file names differ between layouts. Page schema values (`tipo`, `id` prefixes, frontmatter keys) and page slugs are the same in both.

### Output routing

Every file a skill writes in Sentina or personal mode lands in exactly one of these places. The rule behind the table: a person reads it to understand or follow a process → the vault; it will become knowledge later → `inbox/`; a one-off document → `reports/`; a machine runs it → `ops/`; it belongs to one delivery task → `tasks/<id>/`.

| Skill output | Where |
|---|---|
| `/to-spec` specification | `tasks/<id>/spec.md` (and the Notion task) |
| `/to-tickets` local tickets | `tasks/<id>/tickets/NN-<slug>.md` |
| `/implement` evidence | `tasks/<id>/meta.yaml` plus its artifacts |
| `/acceptance-test` | `tasks/<id>/acceptance-tests.md` |
| Glossary terms (`domain-modeling`, `grill-with-docs`, `triage`…) | `wiki/context/glossary.md` |
| Decisions, including "we won't do X" (`grill-me`, `domain-modeling`, `triage`) | `wiki/context/decisions/dec-<slug>.md` |
| `/research` findings | `inbox/research-<slug>.md`, then `/wiki-ingest` |
| `/to-questionnaire` | `reports/AAAA-MM-DD-questionnaire-<slug>.md` |
| Diagram or visual explanation worth keeping | `reports/` (otherwise the skill's own out-of-repo default) |
| `/teach` workspace | `.personal/teach/` (gitignored) |
| `/handoff`, architecture review HTML | the OS temp directory, as each skill says |
| `/prototype` | a throwaway branch |

`<id>` is the task id that names the branch (`feat/tarea-<id>`). Never create `CONTEXT.md`, `docs/adr/`, `.out-of-scope/` or `.scratch/` in a repo with a vault: those are the generic-mode homes for the same content, and the Sentina guardian fails on the first three. In generic mode they stay exactly as each skill describes.
