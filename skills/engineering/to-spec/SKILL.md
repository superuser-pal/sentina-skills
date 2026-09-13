---
name: to-spec
description: Transforma una minuta de Notion AI, conversación o requerimiento en una especificación técnica formal atómica para repositorios Sentina.
disable-model-invocation: true
---

# To Spec (De Minuta a Especificación Atómica)

Transforma las minutas de Notion AI, requerimientos acordados en `/grill-me` o solicitudes del usuario en una especificación técnica formal y atómica.

No vuelvas a entrevistar al usuario; sintetiza con rigor técnico lo acordado y validado contra el contexto del repositorio.

---

## Proceso

1. **Lectura y fundamentación en el contexto local:**
   - Lee `.sentina/manifiesto.yaml` (tipo de perfil, categorías y tipos permitidos).
   - Consulta los nodos canónicos en `contexto/` (`arquitectura.md`, `decisiones/`, `alcance.md`, `glosario.md`).
   - Usa exclusivamente la terminología del glosario y respeta los contratos y decisiones vigentes.

2. **Definición de costuras (seams) y estrategia de prueba:**
   - Define las costuras en las que se probará la funcionalidad. Prioriza costuras existentes de alto nivel (comportamiento observable, contratos de endpoints, esquemas) en lugar de crear mocks o costuras frágiles internas.

3. **Verificación preventiva de las Tablas Anti-Racionalización (§14.2):**
   - Antes de cerrar el spec, valida que cumpla estrictamente con:
     - **Grafo:** ¿Se crean o superan nodos con sus IDs estables (`id: tipo:slug`), `valid_from` y aristas `relationships`? ¿Cada nodo nuevo declara el set completo de claves requeridas (§3.1 del manifiesto): `title`, `category`, `tags`, `sources`, `summary`, `dueno`, `fuente_de_verdad`, `lifecycle`, `lifecycle_changed`, `aliases` (con el `id` incluido), `created`, `updated`?
     - **Stubs externos:** ¿Alguna arista `relationships` apunta a un nodo propiedad de otro repo? Si es así, el spec debe declarar el stub local resoluble (`contexto/sistemas/sistema-<x>.md` o `contexto/referencias/<tipo>-<slug>.md`, con `fuente_de_verdad: externo` y `repo_fuente`) o confirmar que ya existe (§3.2 regla 4, §8.2).
     - **GHL:** Si toca CRM, ¿se definieron las 5 columnas de toda etiqueta en `esquema/etiquetas.md`, incluyendo "Quién la quita"?
     - **Seguridad:** ¿Se usan variables de entorno en vez de URLs reales de webhooks? ¿Se garantizó cero PII de clientes? ¿Se identificaron secretos no obvios (IDs de base de Notion, enlaces de Loom/Drive sin restricción, IDs de sesión en payloads de ejemplo, §8.3)?
     - **Evidencia:** ¿El spec define qué evidencia se generará en `evidencia/<id>/meta.yaml` con su schema completo (§9) y su artefacto/log?
   - **Si el spec proviene de una minuta de Notion AI (§12.2):** además de la decisión bi-temporal, declara si corresponde actualizar `contexto/alcance.md` (paso 3) y qué tareas atómicas se derivan al backlog de Notion, enlazadas al ID de la decisión (paso 4).

4. **Redacción del spec usando la plantilla Sentina:**
   Escribe la especificación usando la siguiente estructura formal:

---

## Plantilla de Especificación Sentina

```markdown
# [ID o Nombre de la Tarea] - Especificación Técnica

## 1. Problema y Objetivo
- **Contexto:** Qué situación o necesidad origina este cambio.
- **Objetivo técnico:** Qué estado final medible alcanzará el sistema.

## 2. Archivos a Tocar
Lista exhaustiva de rutas relativas desde la raíz del repositorio:
- `[NUEVO|MODIFICAR|SUPERAR]` `<ruta/al/archivo>`, Justificación breve del cambio.

## 3. Impacto en el Grafo de Conocimiento
Declaración explícita de nodos y aristas para `contexto/` o categorías puras:
- **Nodos a crear:** frontmatter completo, no solo el id, `valid_from` y `relationships` (§3.1 del manifiesto):
  - `id: tipo:slug`, `aliases: ["tipo:slug"]`, `title`, `category`, `tags: [...]`, `dueno`, `fuente_de_verdad`, `lifecycle: vigente|borrador`, `lifecycle_changed: YYYY-MM-DD`, `valid_from: YYYY-MM-DD`, `sources: [...]`, `summary` (≤200 caracteres), `relationships: [...]`, `created`/`updated` (ISO 8601).
- **Nodos a superar (bi-temporalidad):**
  - Nodo previo: `valid_until: YYYY-MM-DD`, `lifecycle: archived`, `lifecycle_changed: YYYY-MM-DD`, `superseded_by: "[[nuevo-stem]]"`
  - Nodo nuevo: `relationships: [{type: replaces, target: "[[viejo-stem]]"}]`
- **Aristas dependientes:**
  - `relationships: [{type: depende_de, target: "[[stem]]"}]`
- **Stubs externos requeridos:** si algún `target` referencia un nodo propiedad de otro repo, declara el stub local a crear o verificar: ruta (`contexto/sistemas/sistema-<x>.md` o `contexto/referencias/<tipo>-<slug>.md`), `id`/`tipo` heredados del propietario, `fuente_de_verdad: externo`, `repo_fuente: <repo>`.
- **Contabilidad del vault:** recuerda a `/implement` que, tras escribir estos nodos, debe sincronizar `index.md`, `log.md` y `hot.md` (vía la skill `wiki-update` del repo de destino, §13.3), no solo el guardián.

## 4. Decisiones de Implementación y Contratos
- Módulos, interfaces o esquemas a crear o modificar.
- Contratos de payload (webhooks, APIs, modelos).
- Si toca GHL: detalle de etiquetas (Etiqueta, Propósito, Quién la pone, Quién la quita, Dependencias).
- Variables de entorno requeridas (sin incluir secretos ni URLs reales).

## 5. Casos de Prueba y Criterios de Aceptación
- **Criterios de Aceptación:** Lista numerada con condiciones verificables (Gherkin o checklist booleano).
- **Costuras de Prueba:** Qué pruebas automatizadas o de validación local se ejecutarán (e.g. `pytest`, `npm test`, guardian).
- **Plan de Evidencia:** Identificador del hecho técnico y archivo esperado en `evidencia/<id>/meta.yaml`, poblando el schema completo de §9: `id`, `fecha`, `autor`, `tipo`, `sistema`, `afirmacion`, `resultado`, `tarea_notion`, `artefactos`, `decision_relacionada`; más el log/artefacto reproducible que referencia.

## 6. Fuera de Alcance (Out of Scope)
- Qué aspectos quedan expresamente excluidos de esta tarea.
```

Una vez redactado el spec, preséntalo al usuario para su aprobación antes de proceder a **/implement**.
