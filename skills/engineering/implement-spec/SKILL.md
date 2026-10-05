---
name: implement-spec
description: "Implement an approved spec and its ticket graph on one integration branch, coordinating parallel ticket work and closing with review and evidence."
disable-model-invocation: true
---

# Implement Spec

Implement an approved spec whose tickets declare their blocking relationships. Treat the tickets as a **task graph**, not a sequential checklist: the **frontier** is every ticket whose blockers are complete.

The goal is one reviewed integration branch containing the whole spec. Communicate with subagents through context pointers to the spec, tickets, research notes, and commits instead of duplicating their contents.

## Detect the repo mode

Read `.sentina/manifiesto.yaml` once if it exists (see `.agents/sentina-mode.md`):

- **Sentina product repo** (`repo.tipo` is not `personal`): the integration branch must be `feat/tarea-<id>-<slug>` or `fix/tarea-<id>-<slug>`, using the task reference from the spec. Apply the evidence, vault-sync, guardian, acceptance-test, and PR gates below.
- **Personal or generic repo**: use the configured tracker and the generic branch convention from `git-workflow-and-versioning`. Skip Sentina-only evidence, vault, guardian, and Notion lifecycle rules.

If no spec or ticket graph is available, stop and tell the user what is missing. Do not invent tickets or blocking edges during implementation.

## Process

1. Read the spec and every ticket. Verify that each blocking edge resolves and identify the initial frontier.

2. Create or confirm the integration branch. In a Sentina product repo, confirm the Notion task is locked as **En curso** with an owner before implementation starts.

3. Use implementer subagents for frontier tickets when delegation is available and authorized. Each implementer works in its own worktree and branch, based on the current integration branch. Its brief points to the ticket and spec and requires it to:
   - call the Skill tool with `tdd` and work only at the pre-agreed seams;
   - follow the repository's standards and validation commands;
   - commit one atomic ticket implementation;
   - merge the latest integration-branch tip into its branch before reporting done;
   - report the commit, checks run, and any evidence or vault changes still required.

4. Merge each completed ticket branch into the integration branch only after its ticket-level checks pass. Use a merger subagent when available. Recompute the frontier after every merge and dispatch newly unblocked tickets.

5. In a Sentina product repo, finish the integration work using the same completion contract as `implement`:
   - run the repository guardian or equivalent, plus the full test and typecheck commands;
   - populate `tasks/<id>/meta.yaml` and anonymized artifacts when the change touches external systems or contracts;
   - sync vault accounting and `CHANGELOG.md` when the spec requires them;
   - verify all four anti-rationalization tables in `implement` against the integrated diff.

6. Call the Skill tool with `code-review` against the integration branch's merge-base. Fix every accepted finding in one focused implementation pass, then rerun the affected checks.

7. In a Sentina product repo, tell the user to run `acceptance-test`. Stop until `tasks/<id>/acceptance-tests.md` is complete, all cases pass, and no defect remains open. This user-invoked gate cannot be called by another skill.

8. When a pull request is requested or required by the tracker, open it only after the preceding gates pass. The model-invoked `pr` skill supplies its body. Otherwise resolve each ticket using the tracker's normal completion mechanism and report the integration branch.

9. Remove the ticket worktrees after their branches are safely integrated. Leave merging the pull request to a human.
