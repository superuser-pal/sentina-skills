---
name: pr
description: "Shape a pull request body with a compact visual summary, before-and-after evidence, and an explicit merge-risk assessment. Use when drafting or updating a PR description."
metadata:
  credits:
    skill: show-me
    author: Dex Horthy
    organisation: Humanlayer
    url: "https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md"
---

# Pull Request Body

Use the project's domain language from `GLOSSARY.md`, or `wiki/context/glossary.md` in a Sentina product repo. Keep prose brief and use the smallest visual that makes the change clear.

```markdown
## Summary

<diagram, diff sketch, pseudocode, call tree, component tree, or shallow file tree>

## Evidence

- **Before:** <screenshot, output, or failing test>
  **After:** <screenshot, output, or passing test>

## Merge Danger

**Door:** <one-way or two-way>

<optional explanation>

**Blast Radius:** <short description>

<optional ramifications>
```

## Summary

Choose visuals by what changed:

- Logic or algorithms: short pseudocode.
- Runtime interaction: call tree or Mermaid sequence diagram.
- UI ownership: component tree with relevant state and module boundaries.
- Responsibility changes: shallow file tree.
- A small change to an existing shape: `diff` block.
- A mostly new target shape: the complete, copyable block.

Include only the calls, files, states, and boundaries needed to understand the change. Place each visual beside the sentence it supports.

## Evidence

Show a concrete before-and-after pair. Prefer screenshots for visual work and exact test or command results for executable work. State what the check exercised, not only that a suite passed.

In a Sentina product repo, do not draft or open the PR until the required `tasks/<id>/meta.yaml` artifacts exist and `tasks/<id>/acceptance-tests.md` records a passing human verdict. Link those artifacts in this section when they materially support the change.

## Merge danger

Classify the change as:

- **Two-way door**: cheap and safe to revert.
- **One-way door**: destructive, externally visible, migratory, or otherwise difficult to reverse.

Name the blast radius in domain terms, then mention concrete ramifications such as consumer breakage, data migration risk, layout shift, mobile behavior, webhook delivery, or downstream automation.
