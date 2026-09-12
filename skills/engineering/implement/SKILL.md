---
name: implement
description: "Ejecución aislada y disciplinada de una tarea en la rama feat/tarea-* siguiendo rigurosamente una especificación técnica, con validación local y tablas anti-racionalización."
disable-model-invocation: true
---

# Implement (Ejecución Aislada y Disciplinada)

Implementa el trabajo especificado en una especificación técnica formal o tarea aprobada. Conduce el desarrollo en una rama de trabajo aislada, ejecuta validaciones locales rigurosas, genera evidencia obligatoria y prepara el Pull Request.

---

## Reglas de Ejecución

1. **Rama de trabajo aislada:**
   - Todo trabajo se realiza en una rama con prefijo `feat/tarea-*` (o `fix/tarea-*`), donde `tarea-*` corresponde al identificador de la tarea en Notion.
   - Jamás comitear directamente en `main`.

2. **Apego estricto a la especificación:**
   - Desarrolla exclusivamente los archivos y alcances declarados en el spec.
   - Utiliza desarrollo guiado por pruebas (`/tdd`) en las costuras preacordadas.

3. **Validación local continua:**
   - Ejecuta pruebas y comprobaciones de tipos frecuentemente.
   - Ejecuta las herramientas de validación de Sentina antes de comitear:
     - Guardian / linter del repositorio: e.g. `python3 .github/scripts/guardian.py` o scripts equivalentes del proyecto.
     - Suite de tests completa del proyecto (`pytest`, `npm test`, etc.).

4. **Generación obligatoria de evidencia:**
   - Todo PR que interactúe con sistemas externos (Notion, GHL, webhooks, APIs) o modifique contratos **requiere forzosamente poblar `evidencia/<id>/meta.yaml` y su artefacto o log reproducible**.
   - La evidencia debe estar commiteada en la rama antes de abrir el PR para que `.github/workflows/notion-publish-context.yml` la publique al fusionar en `main`.

5. **Revisión final antes de PR:**
   - Antes de abrir el PR, ejecuta una revisión de código (`/code-review` o `/code-review-and-quality`) para verificar estándares, ausencia de PII y apego a la especificación.

---

## Inyección Anti-Racionalización (Inflexible)

Como agente de IA, estás programado para tender a justificar atajos bajo el pretexto de que los cambios son "pequeños", "temporales" o "meramente internos". **Estas justificaciones están explícitamente prohibidas.** Debes adherirte sin excepciones a las siguientes cuatro tablas:

### 1. Protección del Grafo
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Es solo un cambio menor de configuración o copy, no requiere tocar `contexto/`"* | Todo cambio de comportamiento o arquitectura altera el estado de verdad del sistema | Crear `contexto/decisiones/dec-<slug>.md` con su `id: dec:<slug>`, declarar `valid_from` y actualizar `relationships` en los nodos afectados. |
| *"Sobrescribo la decisión anterior directamente porque la nueva la reemplaza"* | Los hechos se superan, no se destruyen (bi-temporalidad) | En el nodo previo: `lifecycle: archived`, `lifecycle_changed`, `valid_until: <fecha>`, `superseded_by: "[[dec-<slug-nuevo>]]"`. En el nuevo: `relationships: [{type: replaces, target: "[[dec-<slug-previo>]]"}]`. |

### 2. Prevención de Bucles (GHL)
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Solo necesitamos etiquetar el contacto al dispararse la automatización"* | Una etiqueta sin salida documentada es un bucle permanente y atrapa contactos | Si el spec toca `sentina-ghl`, **prohibido generar código, JSON o YAML sin haber documentado la columna 'Quién la quita' en `esquema/etiquetas.md`**. |
| *"Luego agregamos la condición de salida cuando probemos el flujo en vivo"* | La seguridad de esquemas es previa a la ejecución | Exigir en `/to-spec` y validar en `/implement` que toda etiqueta referenciada tenga sus 5 columnas completas (§6.1). |

### 3. Seguridad, Privacidad y Secretos
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Pongo la URL completa del webhook en el JSON de prueba para validar que funcione"* | Una URL de webhook entrante **es** una credencial ejecutable (§6.2, §8.3) | **Jamás escribir URLs reales de webhook en archivos JSON o de configuración.** Usar siempre la variable de entorno y registrarla en `webhooks/endpoints.md`. |
| *"Uso un payload de cliente real como ejemplo porque es más realista"* | Cero datos de cliente en repositorios Git (§8.1) | Anonimizar estrictamente todo nombre, correo, teléfono, identificador y monto antes de guardarlo en el repositorio. |

### 4. Regla de Evidencia Obligatoria
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"El cambio fue una llamada API que dio 200, no hace falta guardar evidencia formal"* | Si no hay evidencia reproducible, el hecho no existe técnicamente | Todo PR que toque o interactúe con sistemas externos (Notion, GHL, webhooks, APIs) **requiere forzosamente poblar `evidencia/<id>/meta.yaml` y su correspondiente artefacto o log**. |
| *"La evidencia se puede subir en un commit posterior tras el merge"* | El merge en `main` dispara el workflow automático a Notion | La evidencia debe estar commiteada en la rama antes de abrir el PR para que `.github/workflows/notion-publish-context.yml` la publique al fusionar. |
