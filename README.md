# Sentina Skills

**Sistema híbrido de habilidades de desarrollo para agentes de IA (Pocock + Osmani).**

Este repositorio contiene las habilidades de desarrollo (`.skills/`) del ecosistema Sentina, adoptando la **ergonomía y foco de Matt Pocock** (habilidades de texto plano que guían el flujo de trabajo) y la **inyección anti-racionalización de Addy Osmani** (tablas de reglas inflexibles que bloquean atajos cognitivos del modelo de IA), en estricta conformidad con el [Manifiesto de Repositorios Sentina v2.3](./sentina-repos-manifiesto-v2.md) (§14).

---

## El Ciclo de Desarrollo Sentina

```
  NOTION          GRILL          SPEC           BUILD          REVIEW          SYNC
 ┌──────┐      ┌────────┐     ┌────────┐     ┌─────────┐    ┌─────────┐     ┌────────┐
 │Task /│ ───▶ │/grill- │ ──▶ │/to-spec│ ──▶ │/implement│ ─▶ │ /code-  │ ──▶ │ PR +   │
 │Minuta│      │   me   │     │ (Spec) │     │ (feat/*)│    │ review  │     │ Evid.  │
 └──────┘      └────────┘     └────────┘     └─────────┘    └─────────┘     └────────┘
```

1. **Inbound desde Notion:** Toda tarea técnica nace en Notion y se desarrolla en una rama aislada (`feat/tarea-*` o `fix/tarea-*`).
2. **Auditoría con el Vault (`/grill-me`):** El agente lee `contexto/`, `bases/`, `esquema/` y las aristas `relationships`, interrogando requerimientos y desafiando supuestos antes de codificar.
3. **De Minuta a Spec Atómico (`/to-spec`):** Transforma la minuta o conversación en especificación técnica formal, declarando archivos a tocar, IDs de grafo a crear o superar (`id: dec:<slug>`, `valid_from`, `replaces`), pruebas y cumplimiento anti-racionalización.
4. **Ejecución Disciplinada (`/implement`):** Desarrollo guiado por pruebas (`/tdd`), validación local (`guardian.py`) y generación obligatoria de evidencia en `evidencia/<id>/meta.yaml` y artefactos/logs.
5. **Revisión Multi-Eje (`/code-review`):** Auditoría previa al PR contra especificación, invariantes de seguridad y cero PII de clientes.
6. **Outbound hacia Notion:** Al fusionar el PR en `main`, GitHub Actions sincroniza automáticamente el contexto y la evidencia en Notion.

---

## Las 4 Tablas Anti-Racionalización (§14.2)

Inyectadas directamente en las skills nucleares para impedir atajos cognitivos del modelo:

1. **Protección del Grafo:** Todo cambio de comportamiento o arquitectura altera el estado de verdad del sistema y exige nodo bi-temporal en `contexto/decisiones/dec-<slug>.md`.
2. **Prevención de Bucles (GHL):** Prohibido generar código o YAML sin haber documentado la columna "Quién la quita" en `esquema/etiquetas.md` con sus 5 columnas completas.
3. **Seguridad, Privacidad y Secretos:** Jamás escribir URLs reales de webhooks en archivos de configuración; usar variables de entorno registradas en `webhooks/endpoints.md`. Cero datos reales de clientes en Git (anonimización total).
4. **Regla de Evidencia Obligatoria:** Todo cambio con impacto externo requiere forzosamente poblar `evidencia/<id>/meta.yaml` y su correspondiente artefacto o log antes de abrir el PR.

---

## Instalación y Enlace Local

Para vincular las habilidades en los directorios de agentes locales (`~/.claude/skills` y `~/.agents/skills`):

```bash
bash scripts/link-skills.sh
```

---

## Catálogo de Habilidades

### Engineering

**User-invoked (`disable-model-invocation: true`):**

- **[ask-sentina](./skills/engineering/ask-sentina/SKILL.md)**: Enrutador oficial del flujo de desarrollo de Sentina.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Convierte minutas y acuerdos en especificaciones técnicas atómicas con IDs de grafo y validación de invariantes.
- **[implement](./skills/engineering/implement/SKILL.md)**: Ejecución aislada en `feat/tarea-*` con validaciones locales, evidencia obligatoria y tablas anti-racionalización.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Desglosa un plan en rebanadas verticales (tracer bullets) con dependencias explícitas.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Sesión de interrogatorio que refina el modelo de dominio en repositorios con documentación.
- **[triage](./skills/engineering/triage/SKILL.md)**: Máquina de estados para clasificación y triaje de incidencias.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Diagnóstico de oportunidades de profundización y arquitectura de módulos.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Mapeo colaborativo de decisiones en iniciativas difusas o exploratorias.

**Model-invoked (Reactivas / Auto-activables):**

- **[security-and-hardening](./skills/engineering/security-and-hardening/SKILL.md)**: Hardening contra vulnerabilidades, sanitización, gestión de secretos y protección de privacidad (cero PII).
- **[code-simplification](./skills/engineering/code-simplification/SKILL.md)**: Claridad sobre astucia: simplificación de código y refactorización sin alterar comportamiento.
- **[deprecation-and-migration](./skills/engineering/deprecation-and-migration/SKILL.md)**: Retiro de sistemas y migraciones seguras expand-contract para esquemas y APIs.
- **[constraint-driven-development](./skills/engineering/constraint-driven-development/SKILL.md)**: Barras de calidad contractuales y prevención de atajos cognitivos.
- **[api-and-interface-design](./skills/engineering/api-and-interface-design/SKILL.md)**: Diseño de APIs REST, webhooks, contratos tipados y límites entre módulos.
- **[doubt-driven-development](./skills/engineering/doubt-driven-development/SKILL.md)**: Revisión adversarial de supuestos para decisiones de alto riesgo.
- **[git-workflow-and-versioning](./skills/engineering/git-workflow-and-versioning/SKILL.md)**: Commits atómicos, ramas de corta duración, control de versiones y PRs limpios.
- **[prototype](./skills/engineering/prototype/SKILL.md)**: Prototipos desechables en ramas `prototype/<nombre>` para responder preguntas de diseño.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Bucle disciplinado para aislamiento, diagnóstico y prueba de regresión de fallas.
- **[research](./skills/engineering/research/SKILL.md)**: Investigación en segundo plano contrastada con fuentes primarias confiables.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Desarrollo guiado por pruebas (red-green-refactor) por costuras.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Modelado activo del dominio en `contexto/glosario.md` y decisiones en `contexto/decisiones/`.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Principios de diseño para módulos profundos con interfaces limpias.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Revisión de diffs contra estándares de código, invariantes Sentina y la especificación.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: Resolución metódica de conflictos git por intención en fuentes primarias.
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Asistentes interactivos en bash para pasos que requieren intervención humana.

### Productivity

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Auditoría previa e interrogatorio implacable sobre requerimientos e ideas, fundamentado en el Vault.
- **[grilling](./skills/productivity/grilling/SKILL.md)**: Motor primitivo de entrevistas por rondas (frontera del árbol de diseño).
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Traspaso portable entre sesiones o contextos de trabajo.
- **[teach](./skills/productivity/teach/SKILL.md)**: Espacio de aprendizaje estructurado y lecciones interactivas.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Generación de cuestionarios asíncronos para recabar información externa.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Re-explicación contextualizada de mensajes o términos confusos.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Guía de estilo y directrices para redacción de documentos consumidos por agentes.

### In Progress

- **[writing-beats](./skills/in-progress/writing-beats/SKILL.md)**, **[writing-fragments](./skills/in-progress/writing-fragments/SKILL.md)**, **[writing-shape](./skills/in-progress/writing-shape/SKILL.md)**: Herramientas para articulación y estructuración de contenidos complejos.
- **[loop-me](./skills/in-progress/loop-me/SKILL.md)**: Sesiones multi-paso de afilado de especificaciones.
- **[retro](./skills/in-progress/retro/SKILL.md)**: Retrospectivas del entorno de desarrollo y rendimiento del agente.
