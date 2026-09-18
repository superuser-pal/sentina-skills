# Sentina mode vs. generic mode

A skill in this repo runs in one of two kinds of target repo: a real Sentina product repo, or an ordinary personal project with no Sentina infrastructure. The split is a passive file check, never a prompt.

- **Sentina mode**: `.sentina/manifiesto.yaml` exists at the target repo's root. `setup-sentina` writes this file once, on a freshly cloned Sentina repo; every skill below treats its presence as the signal that this repo follows the Notion-driven Sentina lifecycle (the vault under `contexto/`, `evidencia/<id>/`, GHL tag rules, the anti-rationalization tables).
- **Generic mode**: that file doesn't exist. This covers both an ordinary personal project and a Sentina repo that's been cloned but not yet profiled, and both cases want the same fallback: there's no vault to write into yet, so plain SDLC practice is the only thing that's actually safe to do.

Check once per session (a repo doesn't change mode mid-session), and never ask the user which mode they're in: the file check is the whole mechanism.

## Two patterns, matched to how a skill is reached

- **Model-invoked skills that auto-fire regardless of what the user typed** (`domain-modeling`, `git-workflow-and-versioning`, `code-review`, `security-and-hardening`) branch in place: Sentina-mode behavior stays exactly as documented, and generic mode gets a real fallback to plain SDLC practice, not a refusal.
- **User-invoked skills whose entire value is Sentina infrastructure with no generic equivalent** (`grill-me`, `to-spec`, `implement`, `acceptance-test`) stop and redirect instead: tell the user this skill assumes a Sentina repo, and point at `ask-sentina`'s generic path. This mirrors the stop-and-explain pattern `setup-sentina` already uses when it can't find `scaffold.py`.

`setup-sentina` itself needs no branch: it only ever runs in a repo the user already believes is a Sentina clone, and its own explore step already handles "not actually a Sentina repo" by stopping.
