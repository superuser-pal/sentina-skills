# Guía Práctica del Sistema de Habilidades Sentina (Pocock + Osmani)

Esta guía explica cómo funciona y cómo utilizar el sistema de habilidades (**skills**) del ecosistema **Sentina**, fundamentado en la arquitectura del [sentina-repos-manifiesto-v2.md](./sentina-repos-manifiesto-v2.md) (§14).

---

## 1. ¿Qué es este sistema y cuál es su filosofía?

En Sentina no creemos en el *"vibe coding"* ni en dejar que la inteligencia artificial escriba código sin control. Para garantizar calidad de grado de producción, fusionamos dos metodologías probadas:

1. **La ergonomía y ritmo de Matt Pocock:** Flujos de trabajo guiados por texto plano y preguntas estructuradas que conducen al agente desde una idea hasta un código verificado.
2. **Las tablas anti-racionalización de Addy Osmani:** Reglas estrictas e inflexibles que bloquean los atajos cognitivos típicos de los modelos de lenguaje (como inventar excusas para saltarse pruebas, no documentar decisiones o comitear datos de clientes).

### La Raíz del Repo como Vault de Obsidian
Todos los repositorios Sentina (`sentina-notion`, `sentina-web`, `sentina-ghl`, `sentina-<cliente>`) operan como un **Vault nativo de Obsidian**. El conocimiento técnico vive en carpetas puras (`contexto/`, `bases/`, `esquema/`, `flujos/`, `producto/`) mediante archivos Markdown con encabezados estandarizados (`id: tipo:slug`, `valid_from`, `relationships`). 

Las habilidades aquí reunidas están diseñadas para interactuar directamente con ese grafo de conocimiento, respetando la **bi-temporalidad** (los hechos obsoletos no se borran; se superan formalmente) y la soberanía de cada repositorio.

---

## 2. El Flujo de Trabajo Sentina: De Notion a Producción (Paso a Paso)

**Antes de empezar en un repo recién clonado:** ejecuta `$setup-sentina` una sola vez para confirmar el perfil, correr `scaffold.py` y registrar la conexión con Notion en `.sentina/manifiesto.yaml`. Si ese archivo ya existe, el repo ya está perfilado y puedes saltar directo al Paso 1.

Todo ciclo de desarrollo en Sentina sigue un flujo disciplinado de 8 pasos:

```
  NOTION         LOCK         GRILL          SPEC           BUILD          REVIEW          VERIFY           SYNC
 ┌──────┐     ┌───────┐     ┌───────┐     ┌────────┐     ┌──────────┐     ┌──────┐     ┌────────────┐     ┌─────┐
 │Task /│ ──▶ │Bloqueo│ ──▶ │$grill-│ ──▶ │$to-spec│ ──▶ │$implement│ ──▶ │$code-│ ──▶ │$acceptance-│ ──▶ │ PR +│
 │Minuta│     │ Notion│     │   me  │     │ (Spec) │     │ (feat/*) │     │review│     │    test    │     │Evid.│
 └──────┘     └───────┘     └───────┘     └────────┘     └──────────┘     └──────┘     └────────────┘     └─────┘
```

### Paso 1: Inbound desde Notion y rama aislada
Las tareas se originan en Notion (la interfaz de gestión del negocio, §11.1).
- Abre tu terminal o agente y crea tu rama de trabajo siguiendo la convención obligatoria:
  ```bash
  git checkout -b feat/tarea-<id-de-notion>
  ```

### Paso 2: Bloqueo de Concurrencia en Notion (§11.1.4)
Antes de escribir una sola línea de código o spec, actualiza el estado de la tarea en Notion a "En curso" y asigna el responsable. Este bloqueo lo hace el agente, no un workflow; sin él, dos sesiones pueden tomar la misma tarea en paralelo.

### Paso 3: Interrogatorio con el Vault (`$grill-me` en Codex)
Antes de tocar una sola línea de código, invoca:
```text
$grill-me
```
- **Qué hace:** El agente lee obligatoriamente `.sentina/manifiesto.yaml`, `contexto/`, `bases/`, `esquema/` y las relaciones existentes.
- **Cómo actúa:** Inicia una entrevista por rondas. El agente busca hechos en el repo por su cuenta y te presenta únicamente las decisiones abiertas, cada una con su respuesta sugerida (`➡️`). Cuestiona supuestos tácitos, dependencias ocultas y riesgos de seguridad.

### Paso 4: De Minuta a Spec Atómico (`$to-spec` en Codex)
Una vez consensuados los requerimientos en el interrogatorio o a partir de una minuta de reunión con Notion AI, ejecuta:
```text
$to-spec
```
- **Qué hace:** Sintetiza la discusión en una especificación técnica formal.
- **Qué define obligatoriamente:**
  - Archivos exactos a tocar.
  - Nodos del grafo a crear o superar (`id: dec:<slug>`, `valid_from`, `replaces`).
  - Aristas tipadas (`relationships: [{type: depende_de, target: "[[stem]]"}]`).
  - Costuras de prueba y criterios de aceptación verificables.
  - La entrada de `CHANGELOG.md` que corresponda si el cambio es visible para el usuario final.
  - Validación preventiva de las 4 tablas anti-racionalización.

### Paso 5: Construcción Disciplinada y Evidencia Obligatoria (`$implement` en Codex, §8.1, §9 y §14.2)
Con el spec aprobado por ti, lanza:
```text
$implement
```
- **Qué hace:** Trabaja dentro de la rama `feat/tarea-*` apegándose al spec. Conduce la implementación mediante pruebas test-first ([`tdd`](./skills/engineering/tdd/SKILL.md)) y ejecuta validaciones locales (`python3 .github/scripts/guardian.py` y tests de la suite).
- Si tu cambio interactúa con sistemas externos (APIs, CRM, Notion, webhooks) o altera contratos, se genera obligatoriamente el archivo `evidencia/<id>/meta.yaml` con el schema fijo de §9: `id`, `fecha`, `autor`, `tipo`, `sistema`, `afirmacion`, `resultado`, `tarea_notion`, `artefactos`, `decision_relacionada`; acompañado del log o artefacto técnico reproducible. **La evidencia se comitea en la rama antes de abrir el Pull Request.**
- Tras escribir o superar nodos del grafo, sincroniza `index.md`, `log.md` y `hot.md` del vault (§13.3), y añade la entrada correspondiente a `CHANGELOG.md` cuando el cambio sea visible para el usuario final.

### Paso 6: Revisión Multi-Eje (`$code-review` en Codex)
Se corre [`code-review`](./skills/engineering/code-review/SKILL.md) para auditar el diff completo contra la especificación (estándares, cero PII de clientes, sin URLs reales de webhooks).

### Paso 7: Verificación Funcional en Vivo (`$acceptance-test` en Codex)
Puerta manual y obligatoria antes del PR:
```text
$acceptance-test
```
- **Qué hace:** Genera `evidencia/<id>/acceptance-tests.md` a partir de los criterios de aceptación del spec, con los prompts o entradas literales para disparar cada flujo contra el sistema real.
- **Qué haces tú:** Corres cada caso contra el sistema real en funcionamiento (no simulado) y registras lo observado. Sin este documento completo y sin defectos abiertos, no se abre el Pull Request (§14.2, tabla de evidencia).

### Paso 8: Pull Request y Sincronización Outbound
- Se abre el Pull Request hacia `main`.
- Al fusionarse, GitHub Actions ejecuta `.github/workflows/notion-publish-context.yml`, publicando automáticamente el contexto y la evidencia en Notion (§11.2).

---

## 3. Las 4 Tablas Anti-Racionalización (§14.2)

Los agentes suelen inventar pretextos para saltarse reglas bajo la excusa de que *"es un cambio pequeño"*. Las skills de Sentina bloquean estos atajos cognitivos con las siguientes cuatro tablas:

### 1. Protección del Grafo
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Es solo un cambio menor de configuración o copy, no requiere tocar `contexto/`"* | Todo cambio de comportamiento o arquitectura altera el estado de verdad del sistema | Crear `contexto/decisiones/dec-<slug>.md` con su `id: dec:<slug>`, declarar `valid_from` y actualizar `relationships` en los nodos afectados. |
| *"Sobrescribo la decisión anterior directamente porque la nueva la reemplaza"* | Los hechos se superan, no se destruyen (bi-temporalidad) | En el nodo previo: `lifecycle: archived`, `valid_until: <fecha>`, `superseded_by: "[[dec-nuevo]]"`. En el nuevo: `relationships: [{type: replaces, target: "[[dec-previo]]"}]`. |

### 2. Prevención de Bucles en CRM (GHL)
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Solo necesitamos etiquetar el contacto al dispararse la automatización"* | Una etiqueta sin salida documentada es un bucle permanente y atrapa contactos | Si el cambio toca `sentina-ghl`, **prohibido generar código, JSON o YAML sin haber documentado la columna 'Quién la quita' en `esquema/etiquetas.md`**. |
| *"Luego agregamos la condición de salida cuando probemos el flujo en vivo"* | La seguridad de esquemas es previa a la ejecución | Exigir en `to-spec` y validar en `implement` que toda etiqueta referenciada tenga sus 5 columnas completas (§6.1). |

### 3. Seguridad, Privacidad y Secretos
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Pongo la URL completa del webhook en el JSON de prueba para validar que funcione"* | Una URL de webhook entrante **es** una credencial ejecutable (§6.2, §8.3) | **Jamás escribir URLs reales de webhook en archivos JSON o de configuración.** Usar siempre la variable de entorno y registrarla en `webhooks/endpoints.md`. |
| *"Uso un payload de cliente real como ejemplo porque es más realista"* | Cero datos de cliente en repositorios Git (§8.1) | Anonimizar estrictamente todo nombre, correo, teléfono, identificador y monto antes de guardarlo en el repositorio. |

### 4. Regla de Evidencia Obligatoria
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"El cambio fue una llamada API que dio 200, no hace falta guardar evidencia formal"* | Si no hay evidencia reproducible, el hecho no existe técnicamente | Todo PR que toque o interactúe con sistemas externos (Notion, GHL, webhooks, APIs) **requiere forzosamente poblar `evidencia/<id>/meta.yaml` y su correspondiente artefacto o log**. |
| *"La evidencia se puede subir en un commit posterior tras el merge"* | El merge en `main` dispara el workflow automático a Notion | La evidencia debe estar commiteada en la rama antes de abrir el PR para que el CI la publique al fusionar. |
| *"Los tests automatizados ya pasaron, no hace falta que alguien lo pruebe a mano"* | Un test automatizado prueba lo que el código cree que hace; solo un humano ejecutando el flujo real contra el sistema en vivo confirma que hace lo que el negocio pidió | Todo PR requiere `evidencia/<id>/acceptance-tests.md` completo (generado por `/acceptance-test`), con la sección "Observations" llena en cada caso y sin defectos abiertos, antes de abrir el Pull Request. |

---

## 4. Catálogo Detallado: ¿Para qué sirve cada Skill?

### A. El Enrutador Central

* [`ask-sentina`](./skills/engineering/ask-sentina/SKILL.md): **¿No sabes qué skill usar? Ejecuta `$ask-sentina` en Codex.** Te guía exactamente por qué camino ir según en qué fase de tu tarea te encuentres (desde la idea inicial hasta el PR).

---

### B. Habilidades de Ingeniería: Flujo de Trabajo (User-Invoked)
*Invocadas manualmente por ti. En Codex utiliza `$nombre-del-skill`; en Claude Code utiliza `/nombre-del-skill`.*

* [`setup-sentina`](./skills/engineering/setup-sentina/SKILL.md): Scaffolding de un repo recién clonado: confirma el perfil, corre `scaffold.py` y registra la conexión con Notion en `.sentina/manifiesto.yaml`. Ejecútalo una sola vez, antes de todo lo demás.
* [`to-spec`](./skills/engineering/to-spec/SKILL.md): Transforma la conversación, minuta de Notion AI o requerimiento en una especificación técnica formal atómica. Obliga a definir archivos, nodos de grafo, pruebas y cumplimiento de las 4 tablas.
* [`implement`](./skills/engineering/implement/SKILL.md): Conduce el desarrollo estricto en la rama `feat/tarea-*`. Hace cumplir las pruebas locales, la generación de evidencia y bloquea atajos mediante las tablas anti-racionalización.
* [`acceptance-test`](./skills/engineering/acceptance-test/SKILL.md): Genera el documento de pruebas de aceptación a partir de los criterios del spec y bloquea el PR hasta que un humano lo complete contra el sistema real.
* [`to-tickets`](./skills/engineering/to-tickets/SKILL.md): Desglosa un plan grande en rebanadas verticales (*tracer bullets*) independientes con dependencias de bloqueo explícitas.
* [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md): Sesión de interrogatorio que además aterriza el modelo de dominio en repositorios que mantienen documentación de contexto.
* [`triage`](./skills/engineering/triage/SKILL.md): Gestiona el triaje de incidencias o requerimientos externos pasando por estados formales (`needs-triage`, `ready-for-agent`, etc.).
* [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md): Analiza el código en busca de módulos superficiales que deban rediseñarse como módulos profundos y presenta un reporte visual.
* [`wayfinder`](./skills/engineering/wayfinder/SKILL.md): Para proyectos gigantes o difusos ("en la niebla"). Mapea un árbol de tickets de decisión que se van resolviendo uno a uno antes de intentar programar.

---

### C. Habilidades de Calidad, Arquitectura y Hardening (Model-Invoked)
*El agente las activa de forma autónoma cuando la tarea lo requiere, o las puedes llamar tú.*

* [`security-and-hardening`](./skills/engineering/security-and-hardening/SKILL.md): Auditoría preventiva contra vulnerabilidades OWASP, modelo STRIDE, control riguroso de secretos y anonimización de PII de clientes.
* [`code-simplification`](./skills/engineering/code-simplification/SKILL.md): "Claridad sobre astucia". Limpia complejidad innecesaria y deuda técnica en el código sin cambiar su comportamiento externo.
* [`deprecation-and-migration`](./skills/engineering/deprecation-and-migration/SKILL.md): Retiro seguro de código, APIs y esquemas de base de datos usando el patrón *expand/contract*, alineado con la bi-temporalidad de Sentina.
* [`constraint-driven-development`](./skills/engineering/constraint-driven-development/SKILL.md): Fija estándares de calidad en piedra e impide que el agente desactive pruebas, silencie linters o baje umbrales de cobertura.
* [`api-and-interface-design`](./skills/engineering/api-and-interface-design/SKILL.md): Diseño sólido de contratos de datos, endpoints REST, webhooks e interfaces entre módulos de cliente y plataformas externas.
* [`doubt-driven-development`](./skills/engineering/doubt-driven-development/SKILL.md): Somete cambios críticos (como webhooks de pago o automatizaciones de CRM) a una revisión adversarial para detectar puntos ciegos antes de aplicarlos.
* [`git-workflow-and-versioning`](./skills/engineering/git-workflow-and-versioning/SKILL.md): Estructura commits atómicos, ramas cortas (`feat/tarea-*`) y buenas prácticas de control de versiones.
* [`tdd`](./skills/engineering/tdd/SKILL.md): Bucle estricto de desarrollo guiado por pruebas (rojo-verde-refactor) a través de costuras bien definidas.
* [`code-review`](./skills/engineering/code-review/SKILL.md): Audita el diff antes de un PR contrastando con los estándares de Sentina (cero PII, esquemas de etiquetas, evidencias) y el spec.
* [`domain-modeling`](./skills/engineering/domain-modeling/SKILL.md): Modela el vocabulario del negocio actualizando `contexto/glosario.md` (`id: glosario:*`) y registrando decisiones bi-temporales en `contexto/decisiones/`.
* [`codebase-design`](./skills/engineering/codebase-design/SKILL.md): Principios para construir módulos profundos: interfaces pequeñas, costuras limpias y mucho comportamiento interno.
* [`diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md): Bucle metódico para bugs difíciles: obliga a crear una prueba que falle reproduciblemente antes de teorizar soluciones.
* [`prototype`](./skills/engineering/prototype/SKILL.md): Crea código desechable en ramas `prototype/<nombre>` para responder dudas de diseño que no se pueden resolver en papel.
* [`research`](./skills/engineering/research/SKILL.md): Despacha a un sub-agente a investigar documentación y fuentes primarias en segundo plano, dejando un archivo Markdown con citas.
* [`resolving-merge-conflicts`](./skills/engineering/resolving-merge-conflicts/SKILL.md): Resuelve conflictos de merge bloque a bloque rastreando la intención en las fuentes primarias; jamás corre `--abort`.
* [`wizard`](./skills/engineering/wizard/SKILL.md): Genera scripts interactivos en Bash para pasos que forzosamente requieren acción humana (como ingresar credenciales en dashboards o crear llaves API).

---

### D. Habilidades de Productividad

* [`grill-me`](./skills/productivity/grill-me/SKILL.md): Interrogatorio implacable inicial. Lee el contexto del Vault de Sentina y desafía cualquier requerimiento o idea antes de planear.
* [`grilling`](./skills/productivity/grilling/SKILL.md): El motor interno de entrevistas por rondas basado en la frontera del árbol de diseño.
* [`handoff`](./skills/productivity/handoff/SKILL.md): Resume el estado actual en un documento Markdown portable para continuar la sesión en otro agente o ventana.
* [`to-questionnaire`](./skills/productivity/to-questionnaire/SKILL.md): Cuando una decisión depende de alguien fuera del equipo técnico, genera un cuestionario formal para enviárselo a ese tercero.
* [`wait-what`](./skills/productivity/wait-what/SKILL.md): Si el agente usó un término confuso o no entendiste una respuesta, invócalo para que te vuelva a explicar la idea en lenguaje llano usando el glosario.
* [`writing-for-agents`](./skills/productivity/writing-for-agents/SKILL.md): Guía de referencia sobre cómo redactar instrucciones, reglas y documentos técnicos para que sean consumidos eficazmente por agentes.
* [`teach`](./skills/productivity/teach/SKILL.md): Modo de aprendizaje interactivo multi-sesión dentro del espacio de trabajo.

---

### E. Habilidades Auxiliares y en Progreso (In-Progress & Misc)

* [`writing-beats`](./skills/in-progress/writing-beats/SKILL.md), [`writing-fragments`](./skills/in-progress/writing-fragments/SKILL.md) y [`writing-shape`](./skills/in-progress/writing-shape/SKILL.md): Tríada de habilidades de redacción estructurada. Útiles para redactar manifiestos, síntesis estratégicas o guías metodológicas largas a partir de material disperso.
* [`retro`](./skills/in-progress/retro/SKILL.md): Realiza una retrospectiva de la sesión del agente para identificar mejoras en el `AGENTS.md`, linters o reglas.
* [`loop-me`](./skills/in-progress/loop-me/SKILL.md): Afilado continuo de flujos a lo largo de varias sesiones.
* [`git-guardrails-claude-code`](./skills/misc/git-guardrails-claude-code/SKILL.md): Configura ganchos para bloquear comandos destructivos de git (`push --force`, `reset --hard`).
* [`setup-pre-commit`](./skills/misc/setup-pre-commit/SKILL.md): Configuración de pre-commit para linter y chequeo de tipos.

---

## 5. Configuración e Instalación Rápida

El repositorio está listo para funcionar automáticamente en los entornos de trabajo principales:

### 1. Enlace Local Automático (Recomendado)
Para vincular las habilidades estables de `engineering/` y `productivity/` en tu máquina tanto para **Claude Code** como para **Codex** y otros agentes:
```bash
bash scripts/link-skills.sh
```
Esto crea enlaces simbólicos en `~/.claude/skills` y `~/.agents/skills`. Cada vez que hagas `git pull` en este repo, tus herramientas se actualizarán inmediatamente.

Para incluir también las habilidades beta de `skills/in-progress/`:

```bash
bash scripts/link-skills.sh --include-in-progress
```

Al ejecutar después el instalador sin esa opción, se retiran únicamente los enlaces beta creados desde este repositorio. `misc/` y `deprecated/` nunca se instalan.

En Codex, ejecuta `/skills` para abrir el selector y escribe `$nombre-del-skill` para invocar una habilidad. En Claude Code, utiliza `/nombre-del-skill`.

### 2. Uso como Plugin Nativo
- **Claude Code:** Configurado mediante el manifiesto [`.claude-plugin/plugin.json`](./.claude-plugin/plugin.json).
- **Codex:** Configurado mediante [`.codex-plugin/plugin.json`](./.codex-plugin/plugin.json), con metadatos completos en `agents/openai.yaml` en cada habilidad.

---

## 6. Tres Consejos de Oro para Desarrollar en Sentina

1. **Nunca dejes que el agente empiece a programar sin un spec:** En Codex, pasa siempre por `$grill-me` y `$to-spec`. Diez minutos de preguntas previas ahorran horas de refactorizaciones.
2. **Exige la evidencia en la rama:** El merge en `main` dispara la publicación automática hacia Notion. Si la evidencia no está en `evidencia/<id>/meta.yaml` antes de abrir el PR, el workflow no tendrá nada que reportar.
3. **Consulta al enrutador cuando tengas dudas:** Escribe `$ask-sentina` en Codex y deja que el sistema te indique qué habilidad te conviene ejecutar a continuación.
