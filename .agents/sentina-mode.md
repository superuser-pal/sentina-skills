# Sentina mode, personal mode, and generic mode

A skill in this repo runs in one of three kinds of target repo: a real Sentina product repo, a personal knowledge repo built on the Sentina vault template, or an ordinary project with no Sentina infrastructure. The split is a passive file check, never a prompt.

- **Sentina mode**: `.sentina/manifiesto.yaml` exists at the target repo's root and its `repo.tipo` is anything other than `personal` (`notion`, `web`, `ghl`, `cliente`, ...). `setup-sentina` writes this file once, on a freshly cloned Sentina repo; every skill below treats it as the signal that this repo follows the Notion-driven Sentina lifecycle (the vault under `contexto/`, `evidencia/<id>/`, GHL tag rules, `feat/tarea-*` branches, the anti-rationalization tables).
- **Personal mode**: `.sentina/manifiesto.yaml` exists and declares `repo.tipo: personal`. The repo reuses the Sentina vault schema for durable personal knowledge, but it has no Notion task lifecycle, no client, no GHL, and no `evidencia/` gate. Treat it like generic mode for every lifecycle rule, with one difference: it does have a vault, and the repo's own `AGENTS.md` is the only authority for where knowledge lives and how it is written. Never create a parallel `CONTEXT.md` or apply Sentina delivery rules there.
- **Generic mode**: that file doesn't exist. This covers both an ordinary personal project and a Sentina repo that's been cloned but not yet profiled, and both cases want the same fallback: there's no vault to write into yet, so plain SDLC practice is the only thing that's actually safe to do.

Check once per session (a repo doesn't change mode mid-session), and never ask the user which mode they're in: the file check, plus reading `repo.tipo` when the file exists, is the whole mechanism.

## A Generic-mode opt-in: `.sentina/notion-tasks.yaml`

A generic-mode repo (no `.sentina/manifiesto.yaml` at all) can still track its tasks in Notion without becoming Sentina mode or Personal mode: `setup-sentina` can write `.sentina/notion-tasks.yaml` (just `notion.tareas: <db-id>`) for an ordinary project whose backlog lives in Notion but has no vault. This is not a fourth mode and never gates any skill's Sentina-mode or Personal-mode branch, ever: only `ask-sentina`'s generic path reads it, to know where to pull and update tasks. A repo with only this file still has no vault, no `evidencia/` schema, and no GHL rules, exactly like any other generic-mode repo.

Don't confuse this with Personal mode above: Personal mode is a vault with no Notion; this file is the opposite, Notion with no vault. A skill that branches on `.sentina/manifiesto.yaml` presence or `repo.tipo` must never treat `.sentina/notion-tasks.yaml` as equivalent to either.

## Two patterns, matched to how a skill is reached

- **Model-invoked skills that auto-fire regardless of what the user typed** (`domain-modeling`, `git-workflow-and-versioning`, `code-review`, `security-and-hardening`, `ask-sentina`, `setup-sentina`) branch in place: Sentina-mode behavior stays exactly as documented, and generic and personal mode get a real fallback to plain SDLC practice, not a refusal. In personal mode, anything the fallback would write as project knowledge follows the repo's own `AGENTS.md` instead.
- **User-invoked skills whose entire value is Sentina infrastructure with no generic equivalent** (`grill-me`, `to-spec`, `implement`, `acceptance-test`) stop and redirect in both generic and personal mode: tell the user this skill assumes a Sentina product repo, and point at `ask-sentina`'s generic path.

`setup-sentina` is itself the branch, across three cases: `.sentina/manifiesto.yaml` present with `repo.tipo: personal` means stop, it's already profiled as a personal vault, and re-profiling it as a product repo would pull it into the delivery lifecycle. Present with any other `repo.tipo` means offer to review or update the existing Sentina product profile. Absent means check `scaffold.py`: present means a genuine Sentina clone, run the full scaffold; absent means a generic repo, where it only ever offers the lightweight `.sentina/notion-tasks.yaml` opt-in above, never the vault. Being model-invoked, the agent may call it proactively when a repo has neither `.sentina/manifiesto.yaml` nor `.sentina/notion-tasks.yaml` yet, but should offer it once, not re-ask on every turn once the user has answered.
