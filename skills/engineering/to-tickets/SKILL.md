---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (edges as text in one file per ticket locally, or native blocking links on a real tracker).
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it.

The tracker comes from the repo, never from a guess: if `.sentina/manifiesto.yaml` names a task database (see [Notion tracker](#notion-tracker)), publish there, in both Sentina mode and personal mode. Otherwise use the tracker the user names, or local files.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a column, retype a shared symbol) whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand-contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket; green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets

Publish the approved tickets. The tickets are the same either way, only the shape of the blocking edges changes:

- **Local files** → write one file per ticket under `tasks/<id>/tickets/<NN>-<slug>.md` in a Sentina or personal repo (`.agents/sentina-mode.md` § Output routing), or `.scratch/<feature-slug>/issues/<NN>-<slug>.md` in a generic repo, numbered from `01` in dependency order (blockers first). Each file's "Blocked by" lists the numbers/titles it depends on. Use the per-ticket file template below: one ticket per file, never a single combined file.
- **Notion** (the manifest names a task database) → follow [Notion tracker](#notion-tracker) below.
- **A real issue tracker (GitHub, Linear, …)** → publish one issue per ticket in dependency order (blockers first) so each ticket's blocking edges can reference real identifiers. Use the platform's native blocking / sub-issue relationship where it has one; otherwise set each ticket's "Blocked by" to the blocking issues. Apply the `ready-for-agent` triage label unless instructed otherwise; the tickets are agent-grabbable by construction.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means top to bottom.

Do NOT close or modify any parent issue.

<local-ticket-template>

# <NN>: <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective, not a layer-by-layer implementation list.

**Blocked by:** the numbers/titles of the tickets that gate this one, or "None (can start immediately)".

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

</local-ticket-template>

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit this section).

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Blocked by

- A reference to each blocking ticket, or "None (can start immediately)".

</issue-template>

In either form, avoid specific file paths or code snippets: they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.

## Notion tracker

Use this when `.sentina/manifiesto.yaml` has a `notion` block naming a task database. All writes go through the Notion API connection available in the session; if there is none, publish local files instead and say so.

### Resolve the database

Read the task database key: `notion.tareas`, or `notion.tareas_<entorno_activo>` when `notion.entorno_activo` is set.

- A UUID or a Notion URL: retrieve it and use its data source. A URL's `v=` parameter is a view, never a data source.
- A name of the form `"<Parent page>/<Database>"` (personal repos keep Notion IDs out of git): search data sources by the database title and keep those whose parent page has that title.

Exactly one data source must match. With zero or several, stop and report the candidates; never pick one.

Then retrieve the data source schema and map the ticket onto it by type, not by a hardcoded name:

- **Title**: the property of type `title`.
- **Status**: the property named in `notion.estados.propiedad` (default `Status`), set to `notion.estados.inicial`. It may be a `select` or a `status` property; write the value in the shape its type expects. If `notion.estados` is absent, ask the user for the initial value once and suggest recording it in the manifest.
- **Project**: when `notion.proyecto` is set, it is a canonical project ID (for example `proyecto:ai-investment-framework`). Find the relation property that points at a projects database, query that database for the record whose `Canonical Project ID` equals the value, and link it. Zero or several matches: stop and report.
- **Blocked by**: if the schema has a self-relation named `Blocked by`, link each ticket to its blockers. Otherwise write the blockers as text in the page body.
- **Source Repo**: if a select property with that name exists, set it to `repo.id`.

### Publish

Create one page per ticket in dependency order (blockers first), so the blocking edges can reference pages that already exist. The page body carries the issue template above, without the "Blocked by" section when the relation holds it. Do not set any other property, and never change existing pages.

Report each created page's title and link.
