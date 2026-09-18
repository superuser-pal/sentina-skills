---
name: acceptance-test
description: "Generates the manual acceptance-test document against the real running system, from the criteria declared in the spec, and confirms a human completed it before the Pull Request opens."
disable-model-invocation: true
---

# Acceptance Test (Live Functional Verification)

A mandatory manual gate between `/code-review` and opening the Pull Request. Generates a test document from the spec's acceptance criteria, and a human runs it against the real, live system before continuing.

## Process

1. **Locate the spec and the evidence `<id>`:**
   - Same lookup as `/code-review`: the branch name (`feat/tarea-<id-or-slug>`), a path the user supplies, or the Notion task description.
   - Use the same `<id>` `/implement` already used for `evidencia/<id>/meta.yaml` on this task. If it isn't obvious (more than one possible `<id>`, or `/implement` hasn't run yet), ask the user instead of guessing.

2. **Read the acceptance criteria:**
   - Read the spec's "Test Cases and Acceptance Criteria" section (the `to-spec` template's §5), specifically the "Acceptance Criteria" list.
   - If the spec doesn't declare this section, stop: ask the user for the spec or the criteria before generating anything.

3. **Generate `evidencia/<id>/acceptance-tests.md` (if it doesn't exist yet):**
   - One case per acceptance criterion, using the fixed template below.
   - Each case includes the literal prompts or inputs needed to trigger the flow end-to-end against the real system (not a mock, not a simulated environment): if the criterion says "the chatbot escalates to a human after 2 failed attempts", the prompts are the literal messages to send, in order.
   - Write the criterion text, prompts, and any example content in the same language the spec itself uses.
   - Leave each case's "Observations" section blank. The human fills it in.

4. **Hand off the document and stop there:**
   - Tell the user, explicitly: "Run every case against the real, live system, fill in 'Observations' on each one and the overall verdict, then re-run `/acceptance-test` when you're done."
   - Do not continue to opening the PR in this same invocation: this is a mandatory pause point, not a suggestion.

5. **On resume: validate completeness before letting the flow continue:**
   - Re-read `evidencia/<id>/acceptance-tests.md`.
   - If any case has an empty or unchecked "Observations" section, tell the user exactly which one is missing and stop there.
   - If the overall verdict shows observed defects, don't continue: tell the user "There are observed defects in the acceptance test; go back to `/implement` to fix them, then repeat `/acceptance-test`." (An instruction for the human to act on, never a direct call to the `implement` skill: it's user-invoked, see `.agents/invocation.md`.)
   - If every case is complete and the verdict shows everything passed, confirm the document is ready as evidence and that work can continue to opening the Pull Request.

## Template for `evidencia/<id>/acceptance-tests.md`

```markdown
# Acceptance Tests (<id>)

Generated from the spec's Test Cases and Acceptance Criteria section. Run
each case against the real, running system, not a simulated environment,
and record what you observe before continuing to the Pull Request.

## Case 1: <acceptance criterion, one line>
**Acceptance criterion:** <literal text, as it appears in the spec>

**How to test it:** literal prompts/inputs, in order:
```
<literal prompt or input 1>
<literal prompt or input 2>
```

**Observations:** _(fill this in after running the test)_
- Observed result:
- Matches the acceptance criterion? [ ] Yes  [ ] No
- Additional evidence (screenshot, log, link):

---

## Case 2: ...
(repeat this structure for every criterion in the spec)

---

## Overall verdict
- [ ] All cases passed
- [ ] Defects observed (detail below, go back to `/implement`)

Defects observed (if any):
-
```
