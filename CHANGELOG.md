# Changelog

## Unreleased

- Replaced `excalidraw`'s mechanism: it no longer drives a live canvas via `mcp-excalidraw-server` (MCP/CLI/REST), and instead generates `.excalidraw` JSON files directly from a diagram-type decision matrix and eight templates, adapted from `tech-leads-club/agent-skills`' `excalidraw-studio` (CC-BY-4.0, Felipe Rodrigues). Set `disable-model-invocation: true` so it only fires when the user names it, keeping it from competing with `diagram-design`'s broader auto-invoked triggers for generic "draw me a diagram" requests.
- Added five skills from `tech-leads-club/agent-skills` to `misc/`, all `disable-model-invocation: true` since each overlaps with an existing auto-invoked skill's territory: `skill-architect` (guided skill-building conversation, alongside `writing-for-agents`), `subagent-creator` (agent-agnostic subagent/persona definitions, no existing equivalent), `the-fool` (single-agent devil's-advocate critique, alongside `doubt-driven-development` and `grilling`), `the-jury` (multi-agent panel verdict, alongside `doubt-driven-development`), and `playwright-skill` (general-purpose Playwright browser automation, the first skill in this repo with a real npm/browser-binary install step).
- Document Codex skill invocation with `$skill-name` and `/skills`, while preserving `/skill-name` for Claude Code.
- Promote `scripts/link-skills.sh` to a supported installer that refuses to replace user-owned files, directories, or links.
- Install only promoted `engineering/` and `productivity/` skills by default. Add `--include-in-progress` for beta skills and remove repository-owned beta links when returning to the stable default.

## 2.1.0

Closed gaps found by an architecture-vs-implementation audit against `sentina-repos-manifiesto-v2.md` (v2.3):

- **`to-spec`**: node-creation template now lists the full required frontmatter key set (§3.1), not just `id`/`valid_from`/`relationships`; added a check for external-repo stubs (`contexto/sistemas/` or `contexto/referencias/`, §3.2 regla 4); the evidence plan now points at the exact §9 schema; added a note for §12.2 steps 3-4 (updating `contexto/alcance.md` and deriving Notion backlog tasks) when the spec originates from a Notion AI minuta.
- **`implement`**: evidence step now includes the literal `evidencia/<id>/meta.yaml` schema from §9 (`id, fecha, autor, tipo, sistema, afirmacion, resultado, tarea_notion, artefactos, decision_relacionada`) instead of only naming the file; added a step to sync `index.md`, `log.md`, and `hot.md` (via `wiki-update`) after writing or superseding vault nodes, and to verify/create external stubs before closing the task, whereas previously the dev-lifecycle skills never touched the vault's own accounting files.
- **`ask-sentina`**: inserted the missing Notion concurrency-lock step (§11.1.4, agent sets task to "En curso" + assigns owner) between branch creation and `/grill-me`; clarified that the inbound lock is the agent's job while the outbound status transition is the CI workflow's job.
- **`grill-me`**: added a prerequisite check for the concurrency lock, a question about external-system stubs, and a reminder that Notion base IDs and unrestricted Loom/Drive links count as credentials (§8.3), not just webhook URLs.
- **`security-and-hardening`**: added a "Sentina Secrets" section (§8.3) covering webhook URLs, Notion base/page IDs, unrestricted Loom/Drive links, and session IDs in example payloads, none of which were covered by the generic OWASP secrets guidance imported from `addyosmani/agent-skills`; extended the Red Flags and Verification checklists accordingly.
- **`git-workflow-and-versioning`**: fixed a real contradiction, this skill (imported unmodified from `addyosmani/agent-skills`) still taught generic `feature/<description>` branch naming, conflicting with the mandatory `feat/tarea-<id>` / `fix/tarea-<id>` convention (§11.1.3) that `ask-sentina`, `grill-me`, and `implement` all assume. Added an explicit Sentina override at the top of the Branching section and fixed the examples.

Not fixed in this pass (flagged, needs a design decision rather than a mechanical edit): there is still no skill that performs the Notion API write for the concurrency lock or the outbound status transitions, only the manual/reminder text added above; and GHL's "5 columns, quién la quita" rule remains discipline-only, with no automated linter equivalent to `guardian.py` for `esquema/etiquetas.md`.

## 2.0.0

- Fork and adaptation for the Sentina ecosystem conforming to `sentina-repos-manifiesto-v2.md` (§14).
- Adopted hybrid model: Matt Pocock workflow ergonomics + Addy Osmani anti-rationalization tables.
- Adapted core development skills (`/grill-me`, `/to-spec`, `/implement`, `ask-sentina`, `domain-modeling`, `code-review`, `to-tickets`, `wayfinder`) for Obsidian Vault architecture, Notion tasks, bi-temporality, and local validation.
- Injected strict anti-rationalization tables: Graph Protection, GHL Loop Prevention, Security/Secrets/Privacy, and Mandatory Evidence.
- Imported 7 production skills from `addyosmani/agent-skills`: `security-and-hardening`, `code-simplification`, `deprecation-and-migration`, `constraint-driven-development`, `api-and-interface-design`, `doubt-driven-development`, and `git-workflow-and-versioning`.
- Added native Codex integration with `.codex-plugin/plugin.json` and `agents/openai.yaml` metadata across all skills.
- Added native Claude Code integration with `.claude-plugin/plugin.json`.
- Removed unused courseware, obsolete documentation, and setup files.
