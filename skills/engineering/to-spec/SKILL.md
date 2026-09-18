---
name: to-spec
description: Turns a Notion AI meeting note, conversation, or requirement into a formal, atomic technical specification for Sentina repositories.
disable-model-invocation: true
---

# To Spec (From Meeting Note to Atomic Specification)

Turns Notion AI meeting notes, requirements agreed on in `/grill-me`, or user requests into a formal, atomic technical specification.

Do NOT re-interview the user; synthesize with technical rigor what was agreed and validate it against the repository's context.

---

## Process

1. **Read and ground in the local context:**
   - Read `.sentina/manifiesto.yaml` (profile type, allowed categories and types).
   - Consult the canonical nodes in `contexto/` (`arquitectura.md`, `decisiones/`, `alcance.md`, `glosario.md`).
   - Use only the glossary's terminology and respect the contracts and decisions currently in force.

2. **Define seams and test strategy:**
   - Define the seams where the functionality will be tested. Prioritize existing high-level seams (observable behavior, endpoint contracts, schemas) over creating mocks or fragile internal seams.

3. **Preventive check of the Anti-Rationalization Tables (§14.2):**
   - Before closing the spec, validate it strictly complies with:
     - **Graph:** Are nodes created or superseded with their stable IDs (`id: tipo:slug`), `valid_from`, and `relationships` edges? Does every new node declare the full set of required keys (manifest §3.1): `title`, `category`, `tags`, `sources`, `summary`, `dueno`, `fuente_de_verdad`, `lifecycle`, `lifecycle_changed`, `aliases` (including the `id`), `created`, `updated`?
     - **External stubs:** Does any `relationships` edge point to a node owned by another repo? If so, the spec must declare the resolvable local stub (`contexto/sistemas/sistema-<x>.md` or `contexto/referencias/<tipo>-<slug>.md`, with `fuente_de_verdad: externo` and `repo_fuente`) or confirm it already exists (§3.2 rule 4, §8.2).
     - **GHL:** If it touches the CRM, were the 5 columns for every tag defined in `esquema/etiquetas.md` (including "Quién la quita")?
     - **Security:** Are environment variables used instead of real webhook URLs? Is zero customer PII guaranteed? Were non-obvious secrets identified (Notion database IDs, unrestricted Loom/Drive links, session IDs in example payloads, §8.3)?
     - **Evidence:** Does the spec define what evidence will be generated in `evidencia/<id>/meta.yaml`, with its full schema (§9) and its artifact/log?
     - **Changelog:** Is the change visible to the end user (a new feature, different behavior, a visible fix)? If so, declare the plain-language line and its Keep-a-Changelog category (`Added`/`Changed`/`Fixed`/`Deprecated`/`Removed`/`Security`) that `/implement` will write to `CHANGELOG.md`, next to the corresponding `dec:<slug>`, in the target repo's own language.
   - **If the spec comes from a Notion AI meeting note (§12.2):** besides the bi-temporal decision, declare whether `contexto/alcance.md` needs updating (step 3) and which atomic tasks derive into the Notion backlog, linked to the decision's ID (step 4).

4. **Draft the spec using the Sentina template:**
   Write the specification using the following formal structure:

---

## Sentina Specification Template

```markdown
# [Task ID or Name] - Technical Specification

## 1. Problem and Objective
- **Context:** What situation or need originates this change.
- **Technical objective:** What measurable end state the system will reach.

## 2. Files to Touch
Exhaustive list of paths relative to the repository root:
- `[NEW|MODIFY|SUPERSEDE]` `<path/to/file>`, brief justification for the change.

## 3. Impact on the Knowledge Graph
Explicit declaration of nodes and edges for `contexto/` or pure categories:
- **Nodes to create:** full frontmatter, not just the id, `valid_from`, and `relationships` (manifest §3.1):
  - `id: tipo:slug`, `aliases: ["tipo:slug"]`, `title`, `category`, `tags: [...]`, `dueno`, `fuente_de_verdad`, `lifecycle: vigente|borrador`, `lifecycle_changed: YYYY-MM-DD`, `valid_from: YYYY-MM-DD`, `sources: [...]`, `summary` (≤200 characters), `relationships: [...]`, `created`/`updated` (ISO 8601).
- **Nodes to supersede (bi-temporality):**
  - Previous node: `valid_until: YYYY-MM-DD`, `lifecycle: archived`, `lifecycle_changed: YYYY-MM-DD`, `superseded_by: "[[new-stem]]"`
  - New node: `relationships: [{type: replaces, target: "[[old-stem]]"}]`
- **Dependent edges:**
  - `relationships: [{type: depende_de, target: "[[stem]]"}]`
- **Required external stubs:** if any `target` references a node owned by another repo, declare the local stub to create or verify: path (`contexto/sistemas/sistema-<x>.md` or `contexto/referencias/<tipo>-<slug>.md`), `id`/`tipo` inherited from the owner, `fuente_de_verdad: externo`, `repo_fuente: <repo>`.
- **Vault accounting:** remind `/implement` that, after writing these nodes, it must sync `index.md`, `log.md`, and `hot.md` (via the target repo's `wiki-update` skill, §13.3), not just the guardian.
- **Changelog entry:** if applicable (see the checklist in step 3 above), the plain-language line and its category, for `/implement` to write to `CHANGELOG.md`.

## 4. Implementation Decisions and Contracts
- Modules, interfaces, or schemas to create or modify.
- Payload contracts (webhooks, APIs, models).
- If it touches GHL: tag details (Etiqueta, Propósito, Quién la pone, Quién la quita, Dependencias).
- Required environment variables (without including secrets or real URLs).

## 5. Test Cases and Acceptance Criteria
- **Acceptance Criteria:** Numbered list with verifiable conditions (Gherkin or a boolean checklist).
- **Test Seams:** What automated tests or local validation will run (e.g. `pytest`, `npm test`, guardian).
- **Evidence Plan:** Identifier for the technical fact and the expected file at `evidencia/<id>/meta.yaml`, populating the full §9 schema: `id`, `fecha`, `autor`, `tipo`, `sistema`, `afirmacion`, `resultado`, `tarea_notion`, `artefactos`, `decision_relacionada`; plus the reproducible log/artifact it references.

## 6. Out of Scope
- What aspects are explicitly excluded from this task.
```

Once the spec is drafted, present it to the user for approval before proceeding to **/implement**.
