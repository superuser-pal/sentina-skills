# Sentina Skills

**Sistema híbrido de habilidades de desarrollo para agentes de inteligencia artificial (Pocock + Osmani).**

Este repositorio contiene las habilidades de desarrollo (`skills`) del ecosistema Sentina. Combina la **ergonomía y foco de Matt Pocock** (habilidades en texto plano que estructuran los flujos de trabajo sin fricción) con la **inyección anti-racionalización de Addy Osmani** (tablas de reglas inflexibles que bloquean los atajos cognitivos del modelo de IA), en estricta conformidad con el [Manifiesto de Repositorios Sentina v2.3](./sentina-repos-manifiesto-v2.md) (§14).

---

## Filosofía y Arquitectura

En Sentina el desarrollo asistido por IA se rige por tres pilares fundamentales:

1. **Cero "vibe coding":** Todo cambio técnico responde a una tarea formal, cuenta con especificación técnica previa y produce evidencia verificable y reproducible.
2. **El repositorio como Vault de Obsidian:** La raíz de cada repositorio Sentina (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`) opera como un vault con categorías puras (`contexto/`, `bases/`, `esquema/`, `flujos/`, `producto/`). El conocimiento técnico se gestiona mediante nodos Markdown con frontmatter estructurado (`id: tipo:slug`, `valid_from`, `relationships`) y respeta el principio de bi-temporalidad (el conocimiento no se destruye ni se sobreescribe; se supera formalmente).
3. **Tablas anti-racionalización:** Los modelos de IA tienden a justificar atajos bajo excusas de conveniencia o rapidez. Las habilidades inyectan reglas inflexibles que impiden saltarse pruebas, omitir documentación de decisiones o exponer credenciales y datos privados.

---

## El Ciclo de Desarrollo Sentina

**Antes de empezar en un repo Sentina recién clonado:** ejecuta `$setup-sentina` una sola vez para confirmar el perfil del repositorio, correr `scaffold.py` y registrar la conexión con Notion en `.sentina/manifiesto.yaml`. Si el repo ya está perfilado (el archivo ya existe), el resto de las habilidades de este ciclo asumen esa configuración y no necesitas repetirlo.

Todo ciclo de desarrollo en el ecosistema sigue un flujo disciplinado de ocho etapas:

```
  NOTION         LOCK         GRILL          SPEC           BUILD          REVIEW          VERIFY           SYNC
 ┌──────┐     ┌───────┐     ┌───────┐     ┌────────┐     ┌──────────┐     ┌──────┐     ┌────────────┐     ┌─────┐
 │Task /│ ──▶ │Bloqueo│ ──▶ │$grill-│ ──▶ │$to-spec│ ──▶ │$implement│ ──▶ │$code-│ ──▶ │$acceptance-│ ──▶ │ PR +│
 │Minuta│     │ Notion│     │   me  │     │ (Spec) │     │ (feat/*) │     │review│     │    test    │     │Evid.│
 └──────┘     └───────┘     └───────┘     └────────┘     └──────────┘     └──────┘     └────────────┘     └─────┘
```

### 1. Inbound desde Notion y rama aislada
Toda tarea técnica nace en Notion (la interfaz de gestión de negocio, §11.1).
- Se crea y cambia a la rama de trabajo aislada según la convención obligatoria (§11.1.3):
  ```bash
  git checkout -b feat/tarea-<id-o-slug>
  # o para correcciones de errores:
  git checkout -b fix/tarea-<id-o-slug>
  ```

### 2. Bloqueo de concurrencia en Notion (§11.1.4)
Antes de escribir especificaciones o código, el agente actualiza el estado de la tarea en Notion a **"En curso"** y asigna el responsable directo. Este bloqueo previene colisiones con otras sesiones o agentes en paralelo.

### 3. Auditoría con el Vault (`$grill-me` en Codex)
El agente inspecciona el contexto local (`contexto/`, `bases/`, `esquema/` y aristas `relationships` existentes) y abre una sesión de interrogatorio estructurado:
- Desafía supuestos tácitos, dependencias ocultas y riesgos de arquitectura.
- Aplica el patrón frontera: presenta opciones concretas con respuestas recomendadas (`➡️`).
- Encuentra hechos en el repositorio de forma autónoma; nunca le pregunta al usuario lo que puede leer en el vault.

### 4. De Minuta o Acuerdo a Especificación Atómica (`$to-spec` en Codex)
Sintetiza la sesión de preguntas o la minuta de Notion AI en una especificación técnica formal:
- Declara la lista exhaustiva de archivos a modificar o crear.
- Define el impacto en el grafo de conocimiento: nodos a crear con frontmatter completo (§3.1), nodos a superar (`superseded_by`, `replaces`), aristas tipadas (`depende_de`) y stubs externos (`fuente_de_verdad: externo`).
- Establece costuras de prueba, criterios de aceptación verificables y el plan de evidencia.
- Valida preventivamente el cumplimiento de las 4 tablas anti-racionalización. El usuario debe aprobar la especificación antes de pasar a la implementación.

### 5. Construcción Disciplinada (`$implement` en Codex)
El agente ejecuta el trabajo en la rama aislada siguiendo la especificación aprobada:
- Conduce el desarrollo mediante pruebas ([`tdd`](./skills/engineering/tdd/SKILL.md)).
- Ejecuta las validaciones locales del proyecto y el guardián del repositorio (`python3 .github/scripts/guardian.py`).
- Genera obligatoriamente el registro de evidencia en `evidencia/<id>/meta.yaml` acompañado de su log o artefacto técnico reproducible (§9).
- Actualiza la contabilidad del vault (`index.md`, `log.md` y `hot.md`, §13.3) tras crear o superar nodos del grafo, y añade la entrada correspondiente a `CHANGELOG.md` cuando el cambio sea visible para el usuario final.

### 6. Revisión Multi-Eje previa al Pull Request (`$code-review` en Codex)
Audita el diff completo contra la especificación técnica, los estándares de código, la ausencia total de datos personales de clientes (cero PII) y la ausencia de URLs reales de webhooks o secretos no obvios.

### 7. Verificación Funcional en Vivo (`$acceptance-test` en Codex)
Puerta manual y obligatoria antes del PR: un humano ejecuta cada caso de la sección "Casos de Prueba y Criterios de Aceptación" del spec contra el sistema real en funcionamiento (no simulado), usando los prompts o entradas literales que la habilidad genera en `evidencia/<id>/acceptance-tests.md`, y registra lo observado.
- Sin este documento completo y sin defectos abiertos, no se abre el Pull Request (§14.2, tabla de evidencia).

### 8. Pull Request y Sincronización Outbound hacia Notion
- La evidencia se incluye en el commit dentro de la rama antes de abrir el Pull Request.
- Al fusionar la rama en `main`, los flujos automatizados de GitHub Actions actualizan la tarea en Notion a "Completada" y publican el contexto y la evidencia técnica (§11.2).

---

## Las 4 Tablas Anti-Racionalización (§14.2)

Inyectadas en las habilidades centrales para bloquear atajos cognitivos del modelo:

### 1. Protección del Grafo de Conocimiento
| Pretexto habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Es solo un cambio menor de configuración o copy, no requiere tocar `contexto/`"* | Todo cambio de comportamiento o arquitectura altera el estado de verdad del sistema | Crear `contexto/decisiones/dec-<slug>.md` con su `id: dec:<slug>`, declarar `valid_from` y actualizar `relationships` en los nodos afectados. |
| *"Sobrescribo la decisión anterior directamente porque la nueva la reemplaza"* | Los hechos se superan, no se destruyen (principio de bi-temporalidad) | En el nodo previo: `lifecycle: archived`, `valid_until: <fecha>`, `superseded_by: "[[dec-nuevo]]"`. En el nuevo: `relationships: [{type: replaces, target: "[[dec-previo]]"}]`. |

### 2. Prevención de Bucles en CRM (GoHighLevel)
| Pretexto habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Solo necesitamos etiquetar el contacto al dispararse la automatización"* | Una etiqueta sin salida documentada genera un bucle permanente y retiene contactos de forma indefinida | Si el cambio toca `sentina-ghl`, está prohibido generar código, JSON o YAML sin haber documentado la columna 'Quién la quita' en `esquema/etiquetas.md`. |
| *"Luego agregamos la condición de salida cuando probemos el flujo en vivo"* | La consistencia de esquemas precede a la ejecución | Exigir en `to-spec` y validar en `implement` que toda etiqueta referenciada cuente con sus cinco columnas completas (§6.1). |

### 3. Seguridad, Privacidad y Secretos
| Pretexto habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Pongo la URL completa del webhook en el JSON de prueba para validar que funcione"* | Una URL de webhook entrante constituye una credencial ejecutable (§6.2, §8.3) | Jamás escribir URLs reales de webhooks en archivos JSON o de configuración. Usar siempre variables de entorno y documentarlas en `webhooks/endpoints.md`. |
| *"Uso un payload de cliente real como ejemplo porque es más realista"* | Cero datos personales de clientes en repositorios Git (§8.1) | Anonimizar estrictamente nombres, correos, teléfonos, identificadores y montos antes de guardarlos en el repositorio. Identificadores de bases de datos de Notion o enlaces de Drive/Loom sin restricción también se tratan como credenciales. |

### 4. Regla de Evidencia Obligatoria
| Pretexto habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"El cambio fue una llamada API que dio 200, no hace falta guardar evidencia formal"* | Si no hay evidencia reproducible, el hecho técnico no existe | Todo Pull Request que toque sistemas externos (Notion, GHL, webhooks, APIs) requiere forzosamente poblar `evidencia/<id>/meta.yaml` con el esquema completo de §9 y su log o artefacto correspondiente. |
| *"La evidencia se puede subir en un commit posterior tras el merge"* | El merge en `main` dispara el flujo automático hacia Notion | La evidencia debe quedar guardada en la rama antes de abrir el Pull Request para que el sistema de integración continua la publique al fusionar. |
| *"Los tests automatizados ya pasaron, no hace falta que alguien lo pruebe a mano"* | Un test automatizado prueba lo que el código cree que hace; solo un humano ejecutando el flujo real contra el sistema en vivo confirma que hace lo que el negocio pidió | Todo PR requiere `evidencia/<id>/acceptance-tests.md` completo (generado por `/acceptance-test`), con la sección "Observations" llena en cada caso y sin defectos abiertos, antes de abrir el Pull Request. |

---

## Instalación y Configuración

### 1. Vinculación Local Automática (Recomendado)

Para enlazar las habilidades estables de `engineering/` y `productivity/` en los directorios de agentes locales de tu máquina:

```bash
bash scripts/link-skills.sh
```

Este script genera enlaces simbólicos (*symlinks*) en:
- `~/.claude/skills`: Para Claude Code.
- `~/.agents/skills`: Para Codex y entornos compatibles con el estándar de Agent Skills.

Al trabajar mediante enlaces simbólicos, basta con ejecutar `git pull` en este repositorio para que todas tus herramientas locales queden sincronizadas al instante.

Las habilidades beta de `skills/in-progress/` son opcionales:

```bash
bash scripts/link-skills.sh --include-in-progress
```

Una ejecución posterior sin esa opción vuelve a la instalación estable y retira únicamente los enlaces beta creados desde este repositorio. Las habilidades en `misc/` y `deprecated/` nunca se instalan.

### 2. Soporte para Múltiples Entornos de Agente

El repositorio cuenta con compatibilidad dual nativa:
- **Claude Code:** Configurado a través de [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json). Las habilidades manuales declaran `disable-model-invocation: true` en su encabezado YAML.
- **Codex (OpenAI):** Configurado a través de [`.codex-plugin/plugin.json`](./.codex-plugin/plugin.json). Cada habilidad incluye su archivo complementario `agents/openai.yaml` con metadatos de interfaz y políticas de invocación (`policy.allow_implicit_invocation: false` para habilidades manuales).
- **Antigravity, Gemini y Cursor:** Compatibles conectando la carpeta de habilidades a sus rutas de configuración global (`~/.gemini/config/skills/`, `.agents/skills` o reglas del espacio de trabajo).

---

## Modos de Uso

Las habilidades se clasifican según su forma de ejecución:

1. **User-invoked (Manuales):** Herramientas de proceso invocadas directamente por el usuario para guiar fases clave del ciclo de desarrollo. En Codex se mencionan con `$`, por ejemplo `$ask-sentina`, `$grill-me`, `$to-spec` y `$implement`. En Claude Code se invocan con `/`, por ejemplo `/ask-sentina`. Tienen la invocación autónoma del modelo desactivada para evitar ejecuciones accidentales.
2. **Model-invoked (Reactivas / Autónomas):** Habilidades que el agente activa de forma autónoma según las necesidades técnicas de la tarea (por ejemplo: diseño de APIs, TDD, simplificación de código, análisis de seguridad, resolución de conflictos de git). También pueden ser invocadas explícitamente por el usuario si se desea forzar su uso.

---

## Catálogo de Habilidades

### Enrutador Principal

- **[ask-sentina](./skills/engineering/ask-sentina/SKILL.md)**: El mapa oficial del ciclo de desarrollo Sentina. Si tienes dudas sobre qué habilidad o paso sigue, ejecuta `$ask-sentina` en Codex para recibir la ruta exacta.

---

### Ingeniería: Flujo de Desarrollo (User-Invoked)

Habilidades de proceso guiado, ejecutadas por el desarrollador mediante comando:

- **[setup-sentina](./skills/engineering/setup-sentina/SKILL.md)**: Scaffolding de un repo Sentina recién clonado: confirma su perfil, corre `scaffold.py` y registra la conexión con Notion en `.sentina/manifiesto.yaml`. Ejecútalo una sola vez antes del primer flujo de ingeniería.
- **[ask-sentina](./skills/engineering/ask-sentina/SKILL.md)**: Enrutador y orquestador del flujo de trabajo de desarrollo en repositorios Sentina.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Transforma acuerdos o minutas de reunión en especificaciones técnicas atómicas con frontmatter de grafo completo, aristas y validación de invariantes.
- **[implement](./skills/engineering/implement/SKILL.md)**: Conduce la implementación técnica en la rama `feat/tarea-*` con pruebas locales, evidencia obligatoria y apego al esquema del vault.
- **[acceptance-test](./skills/engineering/acceptance-test/SKILL.md)**: Genera el documento de pruebas de aceptación a partir de los criterios del spec y bloquea el PR hasta que un humano lo complete contra el sistema real.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Divide un plan grande en rebanadas verticales (*tracer bullets*) independientes con orden de dependencias claro.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Sesión de interrogatorio que aterriza y sincroniza el modelo de dominio en repositorios con documentación formal.
- **[triage](./skills/engineering/triage/SKILL.md)**: Clasificación metódica y máquina de estados para el procesamiento de incidencias técnicas.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Diagnóstico de módulos superficiales y propuesta de reestructuración hacia módulos profundos con interfaces limpias.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Mapeo y navegación estructurada para iniciativas técnicas de alta incertidumbre o alcance difuso.

---

### Ingeniería: Calidad, Arquitectura y Hardening (Model-Invoked)

Habilidades técnicas reactivas que el agente invoca de manera autónoma o que puedes solicitar expresamente:

- **[security-and-hardening](./skills/engineering/security-and-hardening/SKILL.md)**: Protección contra vulnerabilidades OWASP, modelado de amenazas, gestión estricta de secretos y anonimización obligatoria de datos personales.
- **[code-simplification](./skills/engineering/code-simplification/SKILL.md)**: Simplificación de código y refactorización orientada a la claridad, reduciendo deuda técnica sin alterar comportamiento externo.
- **[deprecation-and-migration](./skills/engineering/deprecation-and-migration/SKILL.md)**: Retiro controlado de sistemas y migraciones seguras mediante el patrón *expand/contract*, alineado con la bi-temporalidad del grafo.
- **[constraint-driven-development](./skills/engineering/constraint-driven-development/SKILL.md)**: Definición de restricciones contractuales de calidad que impiden desactivar pruebas, silenciar linters o reducir umbrales de cobertura.
- **[api-and-interface-design](./skills/engineering/api-and-interface-design/SKILL.md)**: Diseño robusto de contratos de datos, endpoints REST, webhooks e interfaces entre módulos internos e integraciones externas.
- **[doubt-driven-development](./skills/engineering/doubt-driven-development/SKILL.md)**: Evaluación adversarial de supuestos para decisiones técnicas de alto riesgo o cambios críticos en infraestructura.
- **[git-workflow-and-versioning](./skills/engineering/git-workflow-and-versioning/SKILL.md)**: Estructuración de commits atómicos, control de versiones y uso obligatorio de ramas cortas `feat/tarea-*` o `fix/tarea-*`.
- **[prototype](./skills/engineering/prototype/SKILL.md)**: Creación de prototipos desechables en ramas `prototype/<nombre>` para responder dudas de diseño antes de escribir código definitivo.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Aislamiento metódico de fallas complejas mediante pruebas de regresión reproducibles antes de aplicar soluciones.
- **[research](./skills/engineering/research/SKILL.md)**: Investigación técnica en segundo plano contrastada con fuentes primarias y documentación oficial.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Ciclo estricto de desarrollo guiado por pruebas (rojo, verde, refactorización) a través de costuras bien definidas.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Modelado conceptual del negocio en `contexto/glosario.md` con identificadores estables y registro de decisiones en `contexto/decisiones/`.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Principios de diseño para módulos profundos con interfaces reducidas y alto encapsulamiento interno.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Auditoría minuciosa de diffs contra la especificación técnica, lineamientos de arquitectura y ausencia total de credenciales y PII.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: Resolución sistemática de conflictos de integración rastreando la intención en el historial de git.
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generación de asistentes interactivos en terminal para procedimientos que requieren intervención humana forzosa.

---

### Productividad y Flujo de Trabajo

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Interrogatorio inicial implacable. Cuestiona requerimientos y desafía supuestos apoyándose en el conocimiento previo del vault antes de planear.
- **[grilling](./skills/productivity/grilling/SKILL.md)**: Motor interactivo de entrevistas por rondas basado en la frontera de decisiones abiertas.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Generación de resúmenes de sesión estructurados y portables para transferir contexto entre agentes o ventanas de trabajo.
- **[teach](./skills/productivity/teach/SKILL.md)**: Módulo de aprendizaje guiado para explicar conceptos complejos o recorrer el funcionamiento interno de un componente.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Creación de cuestionarios asíncronos estructurados para recopilar información clave de usuarios o partes interesadas externas.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Explicación sencilla y en lenguaje natural cuando un término o decisión del agente resulta confuso.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Directrices y patrones de redacción de documentos técnicos para optimizar la comprensión por parte de modelos de lenguaje.

---

### Habilidades en Evaluación y Auxiliares

- **En Progreso (`skills/in-progress/`):**
  - **[writing-beats](./skills/in-progress/writing-beats/SKILL.md)**, **[writing-fragments](./skills/in-progress/writing-fragments/SKILL.md)** y **[writing-shape](./skills/in-progress/writing-shape/SKILL.md)**: Herramientas para la redacción y estructuración de textos técnicos complejos.
  - **[loop-me](./skills/in-progress/loop-me/SKILL.md)**: Ciclos de retroalimentación e iteración continua para refinar especificaciones.
  - **[retro](./skills/in-progress/retro/SKILL.md)**: Retrospectivas del rendimiento del agente y del entorno de desarrollo para enriquecer las instrucciones base.
- **Auxiliares (`skills/misc/`):**
  - **[git-guardrails-claude-code](./skills/misc/git-guardrails-claude-code/SKILL.md)**: Reglas de protección para evitar comandos git potencialmente destructivos en sesiones automatizadas.
  - **[setup-pre-commit](./skills/misc/setup-pre-commit/SKILL.md)**: Configuración inicial de ganchos de verificación previa al commit para validación de formato y tipos.

---

## Guía Rápida de Uso Práctico

### Escenario 1: Iniciar una nueva tarea técnica desde Notion

1. Abre tu terminal en el repositorio correspondiente (`sentina-notion`, `sentina-web`, etc.).
2. Crea la rama de trabajo:
   ```bash
   git checkout -b feat/tarea-migracion-webhooks
   ```
3. Ejecuta el enrutador o inicia la sesión de preguntas:
   ```text
   $grill-me
   ```
4. Responde las rondas de preguntas seleccionando las opciones propuestas o refinando los puntos abiertos.
5. Genera la especificación técnica formal:
   ```text
   $to-spec
   ```
6. Revisa el documento generado en la terminal. Cuando estés conforme, autoriza el inicio de la construcción:
   ```text
   $implement
   ```
7. El agente desarrollará el código con pruebas, validará el guardián local y registrará la evidencia en `evidencia/<id>/meta.yaml`.
8. Ejecuta la revisión de calidad antes de publicar tu rama:
   ```text
   $code-review
   ```
9. Ejecuta la verificación funcional en vivo: responde a `$acceptance-test`, corre cada caso contra el sistema real y completa las observaciones.
   ```text
   $acceptance-test
   ```
10. Abre el Pull Request. Al fusionarse con `main`, la tarea se actualizará automáticamente en Notion.

### Escenario 2: Resolver un bug complejo en producción

1. Crea la rama correctiva:
   ```bash
   git checkout -b fix/tarea-webhook-timeout
   ```
2. Invoca el diagnóstico de fallas:
   ```bash
   diagnosing-bugs
   ```
3. El agente construirá una prueba automatizada mínima que reproduzca la falla de forma confiable antes de intentar modificar el código productivo.
4. Aplica la solución mediante TDD, ejecuta el guardián y genera la evidencia correspondiente.

---

## Reglas de Contribución al Repositorio de Skills

Para mantener la integridad y consistencia del sistema de habilidades:

1. **Estructura estricta de carpetas:** Las habilidades promovidas deben residir en `skills/engineering/` o `skills/productivity/`. Cada una debe contar con su archivo `SKILL.md` y su descriptor `agents/openai.yaml`.
2. **Sincronización del enrutador:** Cualquier cambio en el catálogo o en el flujo de trabajo debe reflejarse en [`skills/engineering/ask-sentina/SKILL.md`](./skills/engineering/ask-sentina/SKILL.md).
3. **Regla de estilo:** Queda estrictamente prohibido el uso de guiones largos (*em-dashes*). Utiliza en su lugar comas, dos puntos, puntos, guiones estándar o paréntesis según corresponda.
4. **Documentación bilingüe clara:** Este archivo `README.md` y la [`GUIA.md`](./GUIA.md) mantienen explicaciones directas y detalladas en español latinoamericano para todo el equipo y agentes colaboradores.

---

## Licencia

Distribuido bajo la Licencia MIT. Consulta el archivo [LICENSE](./LICENSE) para más detalles.
