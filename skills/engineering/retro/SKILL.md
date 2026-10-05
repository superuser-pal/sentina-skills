---
name: retro
description: "Review a coding session and propose improvements to the agent environment, most severe first."
disable-model-invocation: true
---

# Retrospective

Suggest improvements to the coding agent's **environment**, not another round of product-code changes.

## Process

1. Call the Skill tool with `writing-for-agents`.

2. Read the primary sources for the session the user names. If none is named, use the current session. Include the diff, commands and failures, review findings, and relevant session logs when available.

3. Find candidates in these categories:

- **Navigation**: hidden dependencies, hard-to-find files, or a missing navigation pointer.
- **Automated checks**: mistakes a linter, typecheck, test, filesystem rule, pre-commit hook, or CI job could catch. Read the repository's existing check commands and workflows first. An existing check that is unwired or silently broken is the finding. A repository with no guardrail running its checks is also a finding.
- **Coding standards**: judgement calls the reviewer should enforce. Classify the violation first. A mechanical pattern, banned API, import shape, or file-location rule gets a deterministic check in the repository's existing guardrail. Reserve `CODING_STANDARDS.md` for genuine judgement calls that tooling cannot decide.
- **Steering files**: instructions in `AGENTS.md` or `CLAUDE.md` that should instead be a pointer, an automated check, or a review standard.
- **Tool economy**: expensive or noisy tool calls that a narrower command or helper could replace.
- **No-ops**: instructions that did not change behavior and only consumed context.
- **Information access**: missing logs, read-only integrations, or other unavailable evidence that blocked progress.

4. Present candidates in severity order. For each, name the observed session evidence, the proposed environmental change, and why that change would prevent or shorten a future failure. Do not implement the proposals unless the user asks.

## Implementation versus review

Implementation carries the greatest context pressure because it combines exploration, coding, and debugging. Review starts from a diff and has more room for judgement-heavy standards. Put deterministic rules in tooling, put genuine judgement calls in review standards, and keep implementation instructions focused on the work itself.

## File roles

- `AGENTS.md` and `CLAUDE.md`: sparse navigation and steering pointers loaded during implementation.
- `CODING_STANDARDS.md`: judgement calls read during review. Add navigation pointers if it becomes large.
- Repository docs: reference material reached through pointers.
- Skills: reusable workflows or model-invoked reference. Follow `writing-for-agents` when proposing changes to them.
