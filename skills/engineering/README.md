# Engineering

Skills for daily engineering work in Sentina repositories.

## User-invoked

Reachable only when explicitly invoked by the developer (`disable-model-invocation: true`).

- **[ask-sentina](./ask-sentina/SKILL.md)**: Router for the Sentina development workflow: guides which skill to use from Notion task to PR with evidence.
- **[to-spec](./to-spec/SKILL.md)**: Turn a Notion AI minute, conversation, or task into an atomic, formal technical specification with graph IDs and anti-rationalization validation.
- **[implement](./implement/SKILL.md)**: Disciplined execution on branch `feat/tarea-*` following a spec, with local validation, required evidence in `evidencia/<id>/meta.yaml`, and strict anti-rationalization tables.
- **[to-tickets](./to-tickets/SKILL.md)**: Break a plan or spec into tracer-bullet slices, each declaring its blocking edges.
- **[grill-with-docs](./grill-with-docs/SKILL.md)**: Grilling session that builds the project's domain model, sharpening terminology and updating documentation.
- **[triage](./triage/SKILL.md)**: Move incoming issues through a state machine of triage roles.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)**: Scan a codebase for deepening opportunities and present them as a visual report.
- **[wayfinder](./wayfinder/SKILL.md)**: Chart a shared map of decisions for large or foggy efforts, resolved one at a time.

## Model-invoked

Model- or user-reachable skills that trigger automatically or on request.

- **[security-and-hardening](./security-and-hardening/SKILL.md)**: Threat-first hardening, input validation, secrets protection, and zero customer PII in Git repositories.
- **[code-simplification](./code-simplification/SKILL.md)**: Clarity over cleverness: simplify code, eliminate cognitive debt, and maintain green tests.
- **[deprecation-and-migration](./deprecation-and-migration/SKILL.md)**: Safe deprecations and expand-contract migrations for schemas, APIs, and legacy contracts.
- **[constraint-driven-development](./constraint-driven-development/SKILL.md)**: Establish written quality bars and stop agents from silently lowering standards or removing checks.
- **[api-and-interface-design](./api-and-interface-design/SKILL.md)**: Design clean REST endpoints, webhooks, module boundaries, and type contracts.
- **[doubt-driven-development](./doubt-driven-development/SKILL.md)**: Fresh-context adversarial review for high-stakes decisions and security-sensitive logic.
- **[git-workflow-and-versioning](./git-workflow-and-versioning/SKILL.md)**: Atomic commits, short-lived `feat/tarea-*` branches, evidence commits, and PR discipline.
- **[prototype](./prototype/SKILL.md)**: Build a throwaway prototype on a `prototype/<name>` branch to answer design questions.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)**: Disciplined diagnosis loop for hard bugs: tight feedback loop, hypothesize, instrument, and regression-test.
- **[research](./research/SKILL.md)**: Investigate questions against primary sources and capture cited findings as Markdown.
- **[tdd](./tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop.
- **[domain-modeling](./domain-modeling/SKILL.md)**: Build and sharpen the domain model, updating `contexto/glosario.md` and bi-temporal decisions in `contexto/decisiones/`.
- **[codebase-design](./codebase-design/SKILL.md)**: Shared discipline for deep modules: small interfaces, clean seams, and high leverage.
- **[code-review](./code-review/SKILL.md)**: Multi-axis review of diffs against project standards, Sentina invariants, and specs.
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)**: Resolve git merge/rebase conflicts hunk by hunk by tracing original intent.
- **[wizard](./wizard/SKILL.md)**: Interactive bash scripts for human-in-the-loop tasks (credentials, secrets, infrastructure).
