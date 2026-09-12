---
name: ask-sentina
description: Enrutador del flujo de desarrollo de Sentina. Guía qué skill utilizar según la fase del trabajo (desde Notion/minutas hasta el PR verificado con evidencia).
disable-model-invocation: true
---

# Ask Sentina

Enrutador oficial sobre las habilidades de desarrollo en el ecosistema Sentina. Te orienta sobre qué habilidad o flujo corresponde a cada momento de tu trabajo.

---

## 1. El Flujo Principal: Tarea Notion → PR con Evidencia

Este es el camino estándar para todo desarrollo en repositorios Sentina (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`):

1. **Inbound desde Notion:**
   - La tarea nace en Notion (§11.1).
   - Crea y cambia a la rama de trabajo aislada: `git checkout -b feat/tarea-<id-o-slug>`.

2. **Auditoría e Interrogatorio con el Vault → `/grill-me`:**
   - El agente lee el contexto del Vault (`contexto/`, `bases/`, `esquema/`, aristas `relationships`).
   - Cuestiona activamente los requerimientos, supuestos tácitos, dependencias ocultas y riesgos de seguridad mediante rondas de preguntas con respuestas sugeridas (patrón frontera).
   - No se escribe código en esta fase.

3. **De Minuta / Requerimiento a Spec Atómico → `/to-spec`:**
   - Formaliza el acuerdo en una especificación técnica.
   - Declara: archivos a tocar, nodos de grafo a crear o superar (`id: dec:<slug>`, `valid_from`, `replaces`), aristas tipadas (`depende_de`), casos de prueba y las 4 tablas anti-racionalización.
   - El usuario aprueba el spec antes de proceder.

4. **Ejecución Disciplinada y Validada → `/implement`:**
   - Implementa los cambios en la rama `feat/tarea-*` siguiendo rigurosamente el spec.
   - Conduce el desarrollo mediante pruebas (`/tdd`).
   - Ejecuta validaciones locales (`python3 .github/scripts/guardian.py` y tests del proyecto).
   - Genera evidencia en `evidencia/<id>/meta.yaml` y adjunta logs/artefactos reproducibles.
   - Respeta de forma inflexible las 4 Tablas Anti-Racionalización.

5. **Revisión de Calidad y Seguridad → `/code-review` (o `/code-review-and-quality`):**
   - Audita el diff contra la especificación, estándares de arquitectura, ausencia total de PII de clientes y cumplimiento de esquemas.

6. **Pull Request y Sincronización Outbound:**
   - Comitea la evidencia en la rama antes de abrir el PR.
   - Al fusionar a `main`, los workflows de GitHub Actions publican el contexto y la evidencia en Notion (§11.2).

---

## 2. Habilidades de Dominio y Arquitectura

- **Vocabulario y conceptos del negocio:** Usa `/domain-modeling` para afinar términos en `contexto/glosario.md` con identificadores estables `id: glosario:<slug>`.
- **Diseño de módulos profundos e interfaces:** Usa `/codebase-design` para estructurar módulos con interfaces pequeñas y costuras limpias.
- **Diseño de APIs y contratos:** Usa `/api-and-interface-design` para endpoints REST, webhooks o contratos de esquemas entre Notion, GHL y módulos cliente.
- **Iniciativas grandes o difusas (exploración en niebla):** Usa `/wayfinder` para mapear decisiones complejas y registrarlas como nodos bi-temporales en `contexto/decisiones/dec-<slug>.md`.
- **Prototipos desechables:** Usa `/prototype` para responder preguntas de diseño en ramas `prototype/<nombre>`.

---

## 3. Guardianes de Calidad y Seguridad

- **Seguridad y privacidad:** Usa `/security-and-hardening` para auditar código contra vulnerabilidades, proteger secretos y asegurar anonimización de datos (§8.1).
- **Control de atajos del agente:** Usa `/constraint-driven-development` para establecer barras de calidad inflexibles y evitar que un agente relaje comprobaciones o desactive lints/tests.
- **Simplificación y deuda técnica:** Usa `/code-simplification` para limpiar complejidad accidental ("claridad sobre astucia") manteniendo las pruebas en verde.
- **Deprecaciones y migraciones:** Usa `/deprecation-and-migration` para retirar esquemas, endpoints o contratos viejos aplicando el patrón expand/contract alineado con la bi-temporalidad (§3.2, §10).
- **Dudas en decisiones críticas:** Usa `/doubt-driven-development` para someter cambios de alto impacto a un análisis adversarial de riesgos antes de implementarlos.

---

## 4. Diagnóstico y Soporte

- **Bugs difíciles o regresiones:** Usa `/diagnosing-bugs` para aislar un bucle de retroalimentación estrecho antes de teorizar soluciones.
- **Conflictos de Git:** Usa `/resolving-merge-conflicts` para resolver hunks de conflicto rastreando la intención en las fuentes primarias.
- **Credenciales y acciones humanas en dashboards:** Usa `/wizard` para generar scripts interactivos en tareas que requieren intervención humana en portales o variables de entorno.
- **Traspaso entre sesiones o agentes:** Usa `/handoff` para sintetizar el estado de trabajo en un documento portátil antes de reiniciar o cambiar de contexto.
- **Redacción y estructura de contenido:** Usa `/writing-beats`, `/writing-fragments` y `/writing-shape` para articular síntesis, guías y documentos extensos.
