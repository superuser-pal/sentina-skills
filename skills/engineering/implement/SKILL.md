---
name: implement
description: "Isolated, disciplined execution of a task on the feat/tarea-* branch, following a technical specification rigorously, with local validation and anti-rationalization tables."
disable-model-invocation: true
---

# Implement (Isolated, Disciplined Execution)

Implement the work described in a formal technical specification or approved task. Drive development on an isolated working branch, run rigorous local validation, generate mandatory evidence, and prepare the Pull Request.

---

## Prerequisite

This skill assumes a Sentina repo: confirm `.sentina/manifiesto.yaml` exists at the repo root (see `.agents/sentina-mode.md`). If it doesn't, stop: this isn't a Sentina repo (a personal project, or a Sentina clone that hasn't run `/setup-sentina` yet), and the vault sync, evidence schema, and anti-rationalization tables below don't apply. Tell the user to use `ask-sentina` for the generic path instead (plain spec, `/tdd`, `/code-review`, generic branch naming).

---

## Execution Rules

1. **Isolated working branch:**
   - All work happens on a branch prefixed `feat/tarea-*` (or `fix/tarea-*`), where `tarea-*` corresponds to the task's identifier in Notion.
   - Never commit directly to `main`.

2. **Strict adherence to the specification:**
   - Build exclusively the files and scope declared in the spec.
   - Use test-driven development (`/tdd`) at the pre-agreed seams.

3. **Continuous local validation:**
   - Run tests and type checks frequently.
   - Run Sentina's validation tooling before committing:
     - The repo's guardian/linter: e.g. `python3 .github/scripts/guardian.py` or the project's equivalent scripts.
     - The project's full test suite (`pytest`, `npm test`, etc.).

4. **Mandatory evidence generation:**
   - Any PR that interacts with external systems (Notion, GHL, webhooks, APIs) or modifies contracts **is forcibly required to populate `evidencia/<id>/meta.yaml` and its reproducible artifact or log**.
   - `meta.yaml` follows the manifest's fixed §9 schema, with no optional fields omitted or left `null`:
     ```yaml
     id: <fact-id>
     fecha: YYYY-MM-DD
     autor: <user-or-agent>
     tipo: <api|webhook|migracion|integracion|...>
     sistema: <system-touched>
     afirmacion: <what is claimed to work>
     resultado: <what actually happened, with anonymized data>
     tarea_notion: <notion-task-id>
     artefactos: [<paths-to-anonymized-logs-or-screenshots>]
     decision_relacionada: "[[dec-<slug>]]"   # only if the fact derives from a decision
     ```
   - The evidence must be committed on the branch before opening the PR, so that `.github/workflows/notion-publish-context.yml` publishes it on merge to `main`.

5. **Sync the vault's accounting:**
   - After creating or superseding any node in `contexto/` (or another pure category), don't stop at the node's own file: invoke the `wiki-update` skill (or update by hand if unavailable) to refresh `index.md`, `log.md` (verb `ACTUALIZACION` or `CAPTURA` per §13.3, with the date and the affected `id`), and `hot.md`.
   - If the spec declared a changelog entry (a change visible to the end user), append it under the right Keep-a-Changelog category in `CHANGELOG.md` (create the file from the fixed template if it doesn't exist yet; the section headers stay in English, the entry text goes in the target repo's own language), linking the `dec:<slug>` just written.
   - If the spec declared a new or to-be-verified external stub (`contexto/sistemas/` or `contexto/referencias/`), create or confirm it before considering the task complete: an edge with no resolvable stub fails the guardian (§3.2 rule 4).

6. **Final review before the PR:**
   - Before opening the PR, run a code review (`/code-review` or `/code-review-and-quality`) to verify standards, absence of PII, and adherence to the specification.

---

## Anti-Rationalization Injection (Non-Negotiable)

As an AI agent, you're prone to justifying shortcuts on the pretext that changes are "small", "temporary", or "purely internal". **These justifications are explicitly forbidden.** You must adhere without exception to the following four tables:

### 1. Graph Protection
| Agent's usual excuse | Sentina invariant | Mandatory action |
|---|---|---|
| *"It's just a minor config or copy change, it doesn't need to touch `contexto/`"* | Every behavioral or architectural change alters the system's state of truth | Create `contexto/decisiones/dec-<slug>.md` with its `id: dec:<slug>`, declare `valid_from`, and update `relationships` on the affected nodes. |
| *"I'll overwrite the previous decision directly since the new one replaces it"* | Facts are superseded, not destroyed (bi-temporality) | On the previous node: `lifecycle: archived`, `lifecycle_changed`, `valid_until: <date>`, `superseded_by: "[[dec-<new-slug>]]"`. On the new one: `relationships: [{type: replaces, target: "[[dec-<previous-slug>]]"}]`. |

### 2. CRM Loop Prevention (GoHighLevel)
| Agent's usual excuse | Sentina invariant | Mandatory action |
|---|---|---|
| *"We just need to tag the contact when the automation fires"* | A tag with no documented exit creates a permanent loop and traps contacts | If the spec touches `sentina-ghl`, **it's forbidden to generate code, JSON, or YAML without having documented the "Quién la quita" column in `esquema/etiquetas.md`**. |
| *"We'll add the exit condition later once we test the flow live"* | Schema safety precedes execution | Require in `/to-spec` and validate in `/implement` that every referenced tag has all 5 columns complete (§6.1). |

### 3. Security, Privacy, and Secrets
| Agent's usual excuse | Sentina invariant | Mandatory action |
|---|---|---|
| *"I'll put the full webhook URL in the test JSON to validate that it works"* | An inbound webhook URL **is** an executable credential (§6.2, §8.3) | **Never write real webhook URLs into JSON or configuration files.** Always use the environment variable and document it in `webhooks/endpoints.md`. |
| *"I'll use a real customer payload as an example since it's more realistic"* | Zero customer data in Git repositories (§8.1) | Strictly anonymize every name, email, phone number, identifier, and amount before saving it to the repository. |

### 4. Mandatory Evidence Rule
| Agent's usual excuse | Sentina invariant | Mandatory action |
|---|---|---|
| *"The change was an API call that returned 200, no need to save formal evidence"* | If there's no reproducible evidence, the technical fact doesn't exist | Every PR that touches or interacts with external systems (Notion, GHL, webhooks, APIs) **is forcibly required to populate `evidencia/<id>/meta.yaml` with the full §9 schema (`id`, `fecha`, `autor`, `tipo`, `sistema`, `afirmacion`, `resultado`, `tarea_notion`, `artefactos`, `decision_relacionada`) and its corresponding artifact or log**. |
| *"The evidence can go up in a later commit after the merge"* | Merging to `main` triggers the automatic workflow to Notion | The evidence must be committed on the branch before opening the Pull Request, so the continuous integration system publishes it on merge. |
| *"The automated tests already passed, nobody needs to test it by hand"* | An automated test proves what the code believes it does; only a human running the real flow against the live system confirms it does what the business actually asked for | Every PR requires a complete `evidencia/<id>/acceptance-tests.md` (generated by `/acceptance-test`), with "Observations" filled in for every case and no open defects, before opening the Pull Request. |
