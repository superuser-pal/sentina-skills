# Sentina Skills

Colección de habilidades de desarrollo y productividad de agentes para el ecosistema Sentina, combinando la ergonomía y foco en flujos de Matt Pocock con las tablas anti-racionalización y disciplina de Addy Osmani (Manifiesto Sentina v2.3 §14).

## Conceptos Nucleares

**Vault / Grafo de Conocimiento:**
La raíz del repositorio Sentina funciona como Vault de Obsidian. Las categorías puras (`contexto`, `bases`, `flujos`, `agentes`, `producto`, `esquema`, `webhooks`) contienen exclusivamente nodos Markdown con frontmatter estandarizado (`id: tipo:slug`, `valid_from`, `relationships`).

**Flujo Inbound / Outbound:**
- **Inbound:** El trabajo proviene de Notion (tareas, minutas procesadas con Notion AI) y se desarrolla en ramas aisladas `feat/tarea-*` o `fix/tarea-*`.
- **Outbound:** El desarrollo produce especificaciones atómicas, pruebas, validación local (`guardian.py`) y evidencia obligatoria (`evidencia/<id>/meta.yaml`). Al fusionar en `main`, GitHub Actions sincroniza el estado con Notion.

**Tablas Anti-Racionalización (§14.2):**
Inyecciones normativas inflexibles que bloquean atajos cognitivos del modelo de IA:
1. *Protección del Grafo:* todo cambio de comportamiento exige nodo en `contexto/decisiones/` con bi-temporalidad (`valid_from`, `replaces`, `superseded_by`).
2. *Prevención de Bucles (GHL):* prohibido generar código o YAML sin las 5 columnas en `esquema/etiquetas.md` y 'Quién la quita'.
3. *Seguridad y Privacidad:* cero PII en repositorios; nunca URLs reales de webhooks en configs o JSONs.
4. *Regla de Evidencia Obligatoria:* todo PR con integraciones o contratos requiere evidencia reproducible commiteada en la rama.
