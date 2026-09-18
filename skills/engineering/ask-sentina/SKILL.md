---
name: ask-sentina
description: Router for the Sentina development flow. Guides which skill to use depending on the phase of work (from Notion/meeting notes to the PR verified with evidence).
disable-model-invocation: true
---

# Ask Sentina

The official router over the development skills in the Sentina ecosystem. Orients you on which skill or flow corresponds to each moment of your work.

---

## 0. Detect the Repo's Mode

Check whether `.sentina/manifiesto.yaml` exists at the repo root (see `.agents/sentina-mode.md`):

- **Present:** this is a Sentina repo, follow the Main Flow below.
- **Absent:** this isn't a Sentina repo, either a personal project, or a Sentina clone that hasn't run `/setup-sentina` yet. Don't use `/setup-sentina`, `/grill-me`, `/to-spec`, `/implement`, or `/acceptance-test`: they assume Notion and the vault. Instead, follow the generic path:
  1. `/grilling` to interrogate the requirement.
  2. Write a plain spec directly in the conversation (problem, files to touch, acceptance criteria): no vault frontmatter, no evidence schema.
  3. `/tdd` at the agreed seams to build it.
  4. `/code-review`: its Standards axis still applies generically, and the Sentina-only checks skip themselves.
  5. `/git-workflow-and-versioning`'s generic branch naming (`feature/<description>`) and commit discipline, then open the PR.

---

## 1. The Main Flow: Notion Task → PR with Evidence

This is the standard path for all development in Sentina repositories (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`):

1. **Inbound from Notion:**
   - The task originates in Notion (§11.1).
   - Create and switch to the isolated working branch: `git checkout -b feat/tarea-<id-or-slug>`.

2. **Concurrency lock in Notion (§11.1.4):**
   - Before writing a single line of code or spec, update the task's status in Notion to **"En curso"** and explicitly assign the owner (the user or the agent executing it).
   - This lock is mandatory and is the agent's job, not a CI workflow's: it prevents another session or agent from picking up the same task in parallel. If you don't have direct access to the Notion API in this session, ask the user to confirm it before continuing.

3. **Audit and Interrogation with the Vault → `/grill-me`:**
   - The agent reads the Vault's context (`contexto/`, `bases/`, `esquema/`, `relationships` edges).
   - Actively questions requirements, tacit assumptions, hidden dependencies, and security risks through rounds of questions with suggested answers (frontier pattern).
   - No code is written during this phase.

4. **From Meeting Note / Requirement to Atomic Spec → `/to-spec`:**
   - Formalizes the agreement into a technical specification.
   - Declares: files to touch, graph nodes to create or supersede with their full frontmatter (`id: dec:<slug>`, `valid_from`, `replaces`, and the rest of the keys required by §3.1), typed edges (`depende_de`), external stubs if applicable, test cases, and the 4 anti-rationalization tables.
   - The user approves the spec before proceeding.

5. **Disciplined, Validated Execution → `/implement`:**
   - Implements the changes on the `feat/tarea-*` branch, rigorously following the spec.
   - Drives development via tests (`/tdd`).
   - Runs local validations (`python3 .github/scripts/guardian.py` and the project's tests).
   - Generates evidence in `evidencia/<id>/meta.yaml` (full schema §9) and attaches reproducible logs/artifacts.
   - Syncs `index.md`, `log.md`, and `hot.md` in the vault after writing or superseding nodes (§13.3), and adds the corresponding entry to `CHANGELOG.md` when the change is visible to the end user.
   - Adheres inflexibly to the 4 Anti-Rationalization Tables.

6. **Quality and Security Review → `/code-review` (or `/code-review-and-quality`):**
   - Audits the diff against the specification, architecture standards, total absence of customer PII, and schema compliance.

7. **Live Functional Verification → `/acceptance-test`:**
   - Mandatory manual gate: a human runs every case from the spec's Test Cases and Acceptance Criteria section (§5) against the real, running system and records what they observe in `evidencia/<id>/acceptance-tests.md`.
   - The PR does not open without this document complete and with no unresolved open defects (Mandatory Evidence Table, manifest §14.2).

8. **Pull Request and Outbound Sync:**
   - Commit the evidence on the branch before opening the PR.
   - On merging to `main`, the GitHub Actions workflows transition the Notion task to "Completada" and publish the context and evidence (§11.2). This outbound part is the workflow's responsibility, unlike the inbound lock in step 2, which is the agent's responsibility.

---

## 2. Domain and Architecture Skills

- **Business vocabulary and concepts:** Use `/domain-modeling` to sharpen terms in `contexto/glosario.md` with stable identifiers `id: glosario:<slug>`.
- **Deep module and interface design:** Use `/codebase-design` to structure modules with small interfaces and clean seams.
- **API and contract design:** Use `/api-and-interface-design` for REST endpoints, webhooks, or schema contracts between Notion, GHL, and client modules.
- **Large or foggy initiatives (fog exploration):** Use `/wayfinder` to map complex decisions and record them as bi-temporal nodes in `contexto/decisiones/dec-<slug>.md`.
- **Throwaway prototypes:** Use `/prototype` to answer design questions on `prototype/<name>` branches.

---

## 3. Quality and Security Guardians

- **Security and privacy:** Use `/security-and-hardening` to audit code against vulnerabilities, protect secrets, and ensure data anonymization (§8.1).
- **Agent shortcut control:** Use `/constraint-driven-development` to set inflexible quality bars and stop an agent from relaxing checks or disabling lints/tests.
- **Simplification and technical debt:** Use `/code-simplification` to clean up accidental complexity ("clarity over cleverness") while keeping tests green.
- **Deprecations and migrations:** Use `/deprecation-and-migration` to retire old schemas, endpoints, or contracts applying the expand/contract pattern aligned with bi-temporality (§3.2, §10).
- **Doubts on critical decisions:** Use `/doubt-driven-development` to subject high-impact changes to adversarial risk analysis before implementing them.

---

## 4. Diagnosis and Support

- **Hard bugs or regressions:** Use `/diagnosing-bugs` to isolate a tight feedback loop before theorizing solutions.
- **Git conflicts:** Use `/resolving-merge-conflicts` to resolve conflict hunks by tracing intent back to primary sources.
- **Credentials and human actions on dashboards:** Use `/wizard` to generate interactive scripts for tasks that require human intervention on portals or environment variables.
- **Handoff between sessions or agents:** Use `/handoff` to synthesize work state into a portable document before restarting or switching context.
- **Writing and structuring content:** Use `/writing-beats`, `/writing-fragments`, and `/writing-shape` to articulate syntheses, guides, and long-form documents.

---

## Precondition

**`/setup-sentina`**: run once on a freshly cloned Sentina repo, before step 1 of the main flow. It confirms the repo's profile, runs `scaffold.py`, and records the Notion connection in `.sentina/manifiesto.yaml`, the file every skill above reads. If `.sentina/manifiesto.yaml` already exists, the repo is already set up and you can skip straight to step 1.
