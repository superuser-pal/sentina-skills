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
     - **Grafo:** ¿Se crean o superan nodos con sus IDs estables (`id: tipo:slug`), `valid_from` y aristas `relationships`?
     - **GHL:** Si toca CRM, ¿se definieron las 5 columnas de toda etiqueta en `esquema/etiquetas.md`, incluyendo "Quién la quita"?
     - **Seguridad:** ¿Se usan variables de entorno en vez de URLs reales de webhooks? ¿Se garantizó cero PII de clientes?
     - **Evidencia:** ¿El spec define qué evidencia se generará en `evidencia/<id>/meta.yaml` y su artefacto/log?

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
- **Nodos a crear:**
  - `id: tipo:slug` (`valid_from: YYYY-MM-DD`, `category: ...`, `relationships: [...]`)
- **Nodos a superar (bi-temporalidad):**
  - Nodo previo: `valid_until: YYYY-MM-DD`, `lifecycle: archived`, `superseded_by: "[[nuevo-stem]]"`
  - Nodo nuevo: `relationships: [{type: replaces, target: "[[viejo-stem]]"}]`
- **Aristas dependientes:**
  - `relationships: [{type: depende_de, target: "[[stem]]"}]`

## 4. Decisiones de Implementación y Contratos
- Módulos, interfaces o esquemas a crear o modificar.
- Contratos de payload (webhooks, APIs, modelos).
- Si toca GHL: detalle de etiquetas (Etiqueta, Propósito, Quién la pone, Quién la quita, Dependencias).
- Variables de entorno requeridas (sin incluir secretos ni URLs reales).

## 5. Casos de Prueba y Criterios de Aceptación
- **Criterios de Aceptación:** Lista numerada con condiciones verificables (Gherkin o checklist booleano).
- **Costuras de Prueba:** Qué pruebas automatizadas o de validación local se ejecutarán (e.g. `pytest`, `npm test`, guardian).
- **Plan de Evidencia:** Identificador del hecho técnico y archivo esperado en `evidencia/<id>/meta.yaml` + log/artefacto reproducible.

## 6. Fuera de Alcance (Out of Scope)
- Qué aspectos quedan expresamente excluidos de esta tarea.
```

Una vez redactado el spec, preséntalo al usuario para su aprobación antes de proceder a **/implement**.
