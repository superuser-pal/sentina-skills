# Sentina — Manifiesto de archivos por tipo de repositorio

**v2.3.** Sustituye a la v2.2, a la v2.1, a la v2, a la v1 y a §2 y §3 de `sentina-arquitectura-dual-v1.md`. Las reglas del cuerpo de ese documento —propiedad por hecho, commits, evidencia, puente, latido, apéndice A— siguen vigentes, con los cambios de ruta de §9 y las incorporaciones posteriores.

**Qué cambia en la v2.3 respecto a la v2.2:**

1. **Perfiles de repo explícitos:** `.sentina/manifiesto.yaml` usa `version_esquema: 2` y declara `repo.tipo`, `repo.id` y `repo.version_plantilla`. `cliente` y `producto` solo existen en el perfil `cliente`.
2. **Categorías puras:** toda carpeta de `OBSIDIAN_CATEGORIES` contiene exclusivamente nodos Markdown con el esquema completo. Skills, plantillas ejecutables, seguimiento, evidencia, código y archivos generados no se mezclan con esas categorías.
3. **Tipos por perfil:** el guardián valida las categorías exactas y los tipos permitidos dentro de cada una. Se incorporan `contenido`, `metodo`, `contrato` y `rol`.
4. **Stubs externos generalizados:** cualquier nodo poseído por otro repo puede tener un stub local; no solo los sistemas. El stub conserva `id` y `tipo`, usa `fuente_de_verdad: externo` y declara `repo_fuente`.
5. **Scaffold separado:** `python3 scaffold.py --tipo …` materializa el perfil una sola vez. `setup.sh` queda limitado al wiring de skills y aliases de agentes.
6. **Perfiles verificables:** cuatro repos fixture mínimos prueban en CI que `notion`, `web`, `ghl` y `cliente` satisfacen el mismo guardián.

**Qué cambia en la v2.2 respecto a la v2.1:**

1. **Frontmatter alineado con `obsidian-wiki` (§2, §3.1, §3.2, §9):** las claves core del frontmatter quedan en inglés porque las impone la herramienta (`lifecycle`, `valid_from`, `valid_until`, `superseded_by`, `relationships`…); las extensiones Sentina (`id`, `tipo`, `dueno`, `fuente_de_verdad`) siguen en español. `estado` → `lifecycle`, `vigente_desde/hasta` → `valid_from/valid_until`, `depende_de` → `relationships[type: depende_de]`, `supersede` → `superseded_by` en el nodo viejo + `replaces` en el nuevo. Nunca se escribe `null`: la clave se omite.
2. **`aliases` lleva el ID y los enlaces apuntan al nombre de archivo (§3.2):** `[[tipo:slug]]` funciona en Obsidian por el alias; el nombre del archivo es convención (`dec-<slug>.md`, `sistema-<slug>.md`; las páginas canónicas conservan su nombre). Prefijos nuevos: `glosario`, `neg`, `alcance`, `sintesis`.
3. **La raíz del repo es el Vault, no solo `contexto/` (§3.4, §13):** así `bases/`, `flujos/`, `agentes/` y `producto/` entran al grafo. Los archivos de contabilidad del vault (`index.md`, `log.md`, `hot.md`, `.manifest.json`, `_meta/`, `.env`) viven en la raíz.
4. **`decisiones.md` pasa a ser carpeta `decisiones/` (§4-§7, §12):** una decisión = un archivo = un nodo con su propio frontmatter.
5. **Nodos stub para sistemas de otro repo (§3.2 regla 4):** `contexto/sistemas/sistema-<x>.md` con `fuente_de_verdad: externo`, para que cada repo se valide solo.
6. **La plantilla de repo (`sentina-template`) nace del fork de `obsidian-wiki` (§13.4):** se conservan 20 skills adaptadas en `.skills/`; el CLI `obsidian-wiki` es opcional y se usa sin modificar. Las skills de desarrollo de §14 llegan de un repo aparte.

**Qué cambió en la v2.1 respecto a versiones anteriores:**

1. **Eliminación definitiva de la taxonomía centralizada (§1.1, §10):** El concepto de unificar la taxonomía de eventos queda oficialmente deprecado. Cada repositorio es responsable exclusiva y localmente de sus propios eventos en `seguimiento/eventos.json`, sin buscar reconciliación global.
2. **Sincronización bidireccional con Notion (§11):** Flujo formal entre Notion (interfaz/UI de gestión y backlog) y Git (fuente de verdad técnica). Reglas estrictas de entrada (inbound: ramas `feat/tarea-*`, asignación explícita para evitar colisiones) y salida (outbound: PRs, merge a `main`, workflow `.github/workflows/notion-publish-context.yml` y publicación automática de evidencia).
3. **Procesamiento de minutas con Notion AI (§12):** Estándar de actualización de contexto desde reuniones. Las minutas generadas con Notion AI se extraen y traducen a Markdown con frontmatter bi-temporal (`id`, `vigente_desde`, `supersede`) en `contexto/decisiones.md`, se actualiza `contexto/alcance.md`, se derivan tareas a Notion y el CI sincroniza el portal del cliente.
4. **Gestión de conocimiento con Obsidian-Wiki en `contexto/` (§3, §13):** La carpeta `contexto/` adopta los principios de `obsidian-wiki` (de Ar9av): el conocimiento no se acumula, se compila por deltas en un Vault compatible con Obsidian para visualización de grafos sin bases de datos externas.
5. **Sistema de habilidades de desarrollo híbrido (Pocock + Osmani) (§14):** Especificación para `.skills/` con habilidades basadas en texto (`/grill-me`, `/to-spec`, `/implement`) e inyección estricta de tablas anti-racionalización (protección del grafo, prevención de bucles en GHL, seguridad/privacidad de webhooks y regla de evidencia obligatoria).

---

## 1. Los cuatro repos

| Repo | Qué es | Contiene código |
|---|---|---|
| **`sentina-notion`** | El sistema interno de Notion, el core de negocio, el método, **y los workflows compartidos** | Solo los workflows |
| **`sentina-web`** | La landing y su instrumentación de analítica | Sí |
| **`sentina-ghl`** | Todo sobre el CRM | No |
| **`sentina-<cliente>`** | Por proyecto: núcleo fijo + módulo de producto | Según el módulo |

### 1.1 Dónde quedaron las dos funciones de `sentina-ops`

| Función | Nueva ubicación |
|---|---|
| Estándares y convenciones | `sentina-notion/metodo/estandares/` |
| Workflows reutilizables del puente, guardián, latido y publicación de contexto | `sentina-notion/.github/workflows/` |
| Plantillas de repo de cliente y de módulos | `sentina-notion/.sentina/plantillas/` |
| Taxonomía de eventos | **Oficialmente deprecada la unificación** (§10). Soberanía local exclusiva por repositorio (`seguimiento/eventos.json`). |

Los otros tres repos llaman los workflows con stubs de cuatro líneas (`notion-sync.yml`, `guardian.yml`, `latido.yml`, `notion-publish-context.yml`):

```yaml
# .github/workflows/notion-sync.yml
name: notion-sync
on:
  push:
    branches: [main]
jobs:
  sync:
    uses: sentina/sentina-notion/.github/workflows/notion-sync.yml@main
    secrets: inherit
```

> **Consecuencia que hay que tener presente: `sentina-notion` queda como pieza de la que depende el CI de los otros tres.** Renombrarlo o archivarlo rompe la sincronización de la landing, del CRM y de todos los repos de cliente al mismo tiempo, con un error que se lee como problema de permisos. Está escrito en su `CLAUDE.md`. Revertirlo es mover los stubs y cambiar las líneas `uses:`.

> **Configuración obligatoria, una vez:** en `sentina-notion` → Settings → Actions → General → Access, permitir el acceso desde repos de la organización. Sin eso, el `uses:` falla.

---

## 2. Convención de nombres de ruta

**Español, minúsculas, guiones medios, sin acentos ni ñ en las rutas.** El acento va en el contenido, nunca en el nombre del archivo: `metodo/`, no `método/`; `validacion/`, no `validación/`. Las rutas con acentos rompen scripts, URLs y herramientas en silencio, y este repo lo van a leer agentes que no perdonan.

**Lo que no se traduce, porque la herramienta lo impone:**

| Se queda en inglés | Por qué |
|---|---|
| `CLAUDE.md` · `.cursorrules` | Nombres fijos que los asistentes buscan literalmente |
| `.github/workflows/` y los `.yml` de dentro | Ruta fija de GitHub Actions |
| `SKILL.md` y la carpeta `skills/` | Nombre fijo del formato de skills |
| `README.md` | Convención universal |
| `src/` (solo en `sentina-web`) | Convención de build |
| `manifiesto.yaml` → sus **claves** | Ver la nota abajo |
| Claves core del frontmatter: `title` `category` `tags` `sources` `summary` `created` `updated` `valid_from` `valid_until` `superseded_by` `lifecycle` `lifecycle_changed` `relationships` `aliases` | Las lee `obsidian-wiki lint` y Obsidian. Las extensiones Sentina (`id`, `tipo`, `dueno`, `fuente_de_verdad`) sí van en español. §3.1 |

**Las claves del `manifiesto.yaml` van en español.** Las lee `yq` desde los workflows, así que son un contrato: se definen una vez y no se tocan. Consistencia por encima de costumbre.

**Jerga que se queda como está** porque traducirla confunde más de lo que aclara: `commits`, `webhooks`, `pipelines`, `fallbacks`, `runbook`, `rollups`, `prompt`, `layout`.

---

## 3. El frontmatter de grafo

Esta es la parte nueva. La idea: **quedarse con las prácticas de graph engineering sin comprar un runtime de grafos.** Las aristas viven en el frontmatter de archivos planos, y el grafo se *genera*; nunca es la fuente.

### 3.1 El bloque, completo

Todo archivo `.md` dentro de cualquiera de las carpetas declaradas en `OBSIDIAN_CATEGORIES` lo lleva. Una categoría es un espacio puro de nodos; no contiene skills, plantillas ejecutables, changelogs auxiliares ni documentación sin identidad:

```yaml
---
id: arq:dongsong                   # Extensión Sentina. Estable: no cambia nunca aunque el archivo se mueva
aliases: ["arq:dongsong"]          # Obsidian resuelve [[arq:dongsong]] gracias al alias
title: Arquitectura Dongsong
category: contexto                 # == carpeta de primer nivel donde vive el archivo
tipo: arquitectura                 # tipo fino. Su prefijo (arq) es el del id. §3.2
tags: [arquitectura, ghl]
dueno: israel
fuente_de_verdad: repo             # repo | notion | externo
lifecycle: vigente                 # vigente | borrador | archived (= superado)
lifecycle_changed: 2026-09-12
valid_from: 2026-09-12             # cuándo empezó a ser verdad (antes: vigente_desde)
# valid_until y superseded_by SOLO existen cuando el nodo fue superado. Nunca se escriben con null.
sources: []
summary: Una o dos frases, ≤200 caracteres, para entender el nodo sin abrirlo.
relationships:                     # las aristas tipadas (antes: depende_de)
  - type: depende_de
    target: "[[sistema-ghl]]"      # el stem del archivo destino, no su id
  - type: depende_de
    target: "[[base-contactos]]"
created: 2026-09-12T00:00:00Z      # cuándo lo supo el vault (tiempo de ingesta)
updated: 2026-09-12T00:00:00Z
---
```

Las claves en inglés las impone `obsidian-wiki` (§2): son las que valida `obsidian-wiki lint` y las que Obsidian entiende. Las cuatro en español —`id`, `tipo`, `dueno`, `fuente_de_verdad`— son extensiones Sentina: la herramienta las ignora y el guardián las valida. `created`/`updated` son tiempo de ingesta (cuándo lo supo el vault); `valid_from`/`valid_until` son tiempo del hecho (cuándo fue verdad). Los campos de confianza de `obsidian-wiki` (`base_confidence`, trust ledger) **no se adoptan**.

El perfil declarado en `.sentina/manifiesto.yaml → repo.tipo` fija las categorías y los tipos poseídos permitidos:

| Perfil | Categoría | `tipo` permitido para nodos propios |
|---|---|---|
| `notion` | `bases` · `vistas` · `flujos` · `agentes` · `negocio` · `metodo` | `base` · `vista` · `flujo` · `agente`/`prompt` · `negocio` · `metodo`/`contrato`/`decision` |
| `web` | `contenido` | `contenido` |
| `ghl` | `esquema` · `flujos` · `webhooks` | `etiqueta`/`contrato` · `flujo` · `contrato` |
| `cliente` | `producto` | `producto` · `prompt` · `flujo` · `base` · `vista` · `agente` · `contrato` |

`contexto` admite los tipos canónicos compartidos del perfil: arquitectura, decisiones, sistemas, glosario y síntesis; en clientes también `cliente` y `alcance`, y en Notion también `rol`. Un stub con `fuente_de_verdad: externo` conserva el tipo remoto y queda exento de la restricción de tipos de la categoría local.

### 3.2 Las cuatro reglas

**1 · Los IDs son estables; las rutas no.** El ID se asigna al crear el archivo y no cambia aunque el archivo se mueva de carpeta o cambie de repo. Obsidian no admite `:` en nombres de archivo y `obsidian-wiki` resuelve enlaces por **nombre de archivo (stem)**, así que: (a) `aliases` lleva siempre el `id`, y con eso `[[tipo:slug]]` funciona en Obsidian; (b) el enlace canónico que escriben los agentes es `[[stem]]`; (c) los stems son únicos en todo el vault (lo valida el lint). El nombre del archivo es **convención, no regla**: en carpetas de un solo tipo se nombra `tipo-slug.md` (`decisiones/dec-migrar-ghl.md`, `sistemas/sistema-ghl.md`); las páginas canónicas conservan su nombre (`arquitectura.md`, `glosario.md`, `alcance.md`, `cliente.md`). Para ir de un `id` a su archivo: `grep -rl "^id: dec:migrar-ghl" .` o el `grafo.json`.

Namespace `tipo:slug`, con estos prefijos:

`arq` · `dec` (decisión) · `base` · `vista` · `flujo` · `agente` · `prompt` · `evento` · `sistema` · `etiqueta` · `evidencia` · `cliente` · `producto` · `glosario` · `alcance` · `sintesis` (análisis transversal, `contexto/sintesis/`) · `neg` (negocio) · `contenido` · `metodo` · `contrato` · `rol`

**2 · Las aristas viven en `relationships` y reemplazan prosa.** En vez de un párrafo diciendo "este agente consume campos de GHL", se declara `- type: depende_de` / `target: "[[sistema-ghl]]"`. `depende_de` es el tipo de arista Sentina; `replaces` (§3.2 regla 3) es el otro que se usa. La diferencia práctica: `dependencias.md` deja de escribirse a mano y pasa a **generarse**. Un archivo menos que se desactualiza.

**3 · Bi-temporalidad: los hechos se superan, no se sobrescriben.** `valid_from` es cuándo empezó a ser verdad; el commit (y `created`) registran cuándo se supo. Superar un nodo son cuatro escrituras: en el nodo **viejo**, `lifecycle: archived`, `lifecycle_changed`, `valid_until` (último día en que fue verdad) y `superseded_by: "[[nuevo-stem]]"`; en el nodo **nuevo**, `relationships: [{type: replaces, target: "[[viejo-stem]]"}]`. Se usa `archived` y no `superado` porque `obsidian-wiki lint` ancla su máquina de estados a ese valor. Es la idea buena de Graphiti aplicada a archivos, y formaliza lo que la regla append-only de las decisiones ya hacía a medias. `obsidian-wiki query --as-of <fecha>` responde "qué era verdad ese día".

**4 · Una arista solo puede apuntar a un nodo que exista.** El guardián falla si un `target` de `relationships` o un `superseded_by` no resuelve a un archivo, si un `id` se repite, si dos archivos comparten stem, o si `aliases` no contiene el `id`. Es la parte que convierte esto en un grafo de verdad y no en frontmatter decorativo: un enlace roto es un check en rojo hoy, no un descubrimiento en seis meses.

Los nodos que viven en **otro repo** se representan con un **stub local** que conserva el `id` y el `tipo` del propietario, declara `fuente_de_verdad: externo` y añade `repo_fuente: <repo>`. Los sistemas viven en `contexto/sistemas/`; cualquier otro tipo externo vive en `contexto/referencias/`. Por ejemplo, `sistema:ghl` usa `contexto/sistemas/sistema-ghl.md` y `neg:matriz-de-oferta` usa `contexto/referencias/neg-matriz-de-oferta.md`. Así cada repo se valida solo, y `grafo.json` (§3.3) reconcilia stubs con propietarios después.

### 3.3 `grafo.json` es derivado, nunca fuente

Cada repo emite su fragmento con `python3 .github/scripts/guardian.py --emit-grafo`; el workflow del guardián de `sentina-notion` los agrega y escribe `.sentina/grafo.json`. Se consulta; no se mantiene y queda fuera de las categorías.

```json
{
  "generado": "2026-09-12T14:02:00Z",
  "nodos": [
    { "id": "arq:dongsong", "tipo": "arquitectura", "repo": "sentina-dongsong",
      "ruta": "contexto/arquitectura.md", "lifecycle": "vigente", "fuente_de_verdad": "repo" }
  ],
  "aristas": [
    { "desde": "arq:dongsong", "hacia": "sistema:ghl", "relacion": "depende_de" },
    { "desde": "dec:migrar-ghl", "hacia": "dec:usar-hubspot", "relacion": "replaces" }
  ]
}
```

**Y aquí está la puerta abierta, por si algún día se quiere el grafo de verdad:** este archivo es el input de ingesta. Graphiti —o lo que haya entonces— se conecta **río abajo** del repo, consumiendo `grafo.json`. Nunca al revés. Mientras el grafo sea derivado, git sigue siendo la fuente de verdad, con sus ramas y sus diffs; y las ramas son la razón por la que el plano técnico es git y no una base de datos.

**Disparador para reconsiderarlo:** el día que *"¿qué proyectos usan la etiqueta X de GHL?"* deje de ser contestable con un `grep` sobre los cuatro repos.

### 3.4 Integración con el framework Obsidian-Wiki: la raíz del repo como Vault

Los archivos con frontmatter de grafo adoptan los principios del framework `obsidian-wiki` (Ar9av): el conocimiento no se acumula, se compila por deltas. **La raíz del repositorio es el Vault** —no solo `contexto/`— para que `bases/`, `flujos/`, `agentes/` y `producto/` entren al grafo; `category` es la carpeta de primer nivel. `.obsidian/app.json` excluye lo que no es conocimiento (`.github/`, `src/`, `evidencia/`, `.sentina/`, `.skills/`). Eso habilita la navegación visual del grafo de dependencias y de la bi-temporalidad (`[[wikilinks]]`, backlinks, etiquetas) directamente en Obsidian, sin bases de datos externas como Graphiti o Neo4j (ver §13).

---

## 4. `sentina-notion`

```
sentina-notion/
├── CLAUDE.md
├── README.md
├── .sentina/
│   ├── manifiesto.yaml
│   ├── bitacora-sync.md            # la escribe el puente. Nadie la edita
│   ├── plantillas/                 # activos copiables, fuera del vault lógico
│   │   ├── repo-cliente/
│   │   └── modulos-producto/
│   └── grafo.json                  # ⚙️ GENERADO. §3.3
│
├── contexto/
│   ├── arquitectura.md             # Espacios, navegación de dos tiers, páginas backend
│   ├── modelo-de-acceso.md         # plan, asientos, invitados, quién ve qué
│   ├── personas.md                 # ROL y responsabilidad, no persona. Ver §4.3
│   ├── decisiones/                 # una decisión = un archivo dec-<slug>.md. §12
│   ├── sistemas/                   # stubs de sistemas externos. §3.2 regla 4
│   └── glosario.md
│
├── bases/
│   ├── <base>.md                   # propiedades, tipos, opciones, grupos de Status
│   ├── relaciones.md               # tabla con el límite POR LADO
│   ├── formulas.md                 # una por bloque, en orden de dependencia
│   └── rollups.md                  # base origen, propiedad, tipo de cálculo
│
├── vistas/
│   └── vistas.md                   # vista → la pregunta que responde → filtro → orden
│
├── flujos/
│   ├── comercial.md
│   ├── produccion.md
│   ├── onboarding-cliente.md
│   ├── automatizaciones.md         # nativas: disparador + CONDICIÓN + acción
│   └── dependencias.md             # ⚙️ GENERADO desde depende_de. No se edita
│
├── agentes/
│   └── <agente>/
│       ├── prompt.md
│       ├── tools.json
│       └── cadencia.md             # disparadores, permisos de escritura, créditos
│
├── .skills/                        # habilidades ejecutables; nunca viven en metodo/. §14
│   ├── grill-me/SKILL.md
│   ├── to-spec/SKILL.md
│   └── implement/SKILL.md
│
├── negocio/                        # ⛔ NUNCA se copia a un repo de cliente
│   ├── matriz-de-oferta.md         # oferta y pricing — FUENTE DE VERDAD
│   ├── cliente-ideal.md
│   ├── posicionamiento.md
│   └── decisiones/                 # dec-<slug>.md, prefijo neg: para lo que es oferta
│
├── metodo/                         # conocimiento canónico de cómo construye Sentina
│   ├── arquitectura-de-espacios.md # tipo: metodo
│   ├── diseno-de-pagina.md         # tipo: metodo
│   ├── estandares/
│   │   ├── commits.md              # tipo: metodo
│   │   ├── archivos-de-contexto.md # tipo: metodo; frontmatter de §3
│   │   ├── evidencia.md            # tipo: metodo
│   │   ├── secretos.md             # tipo: metodo; QUÉ cuenta como credencial. §8.3
│   │   ├── nombres.md              # tipo: metodo; incluye §2
│   │   └── entrada-y-salida.md     # tipo: metodo
│   ├── contratos/
│   │   ├── notion-api.md           # tipo: contrato
│   │   └── registro-de-cambios.md  # tipo: contrato
│   └── decisiones/                 # tipo: decision cuando cambia el método
│
├── evidencia/
└── .github/workflows/              # los cuatro reutilizables (sync, guardián, latido, notion-publish-context) + los propios
```

### 4.1 `negocio/` y `metodo/`, en una línea

**`negocio/` es qué vende Sentina. `metodo/` es el conocimiento mantenido sobre cómo construye:** estándares, principios reutilizables, contratos operativos y decisiones del método. La prueba: *¿esto sería distinto si Sentina tuviera otros clientes?* Si no, es método.

Los activos que se ejecutan o copian no son conocimiento: las skills viven en `.skills/`, las plantillas en `.sentina/plantillas/`, los workflows en `.github/` y el grafo generado en `.sentina/grafo.json`. La separación evita que el guardián interprete un `SKILL.md` o una plantilla como nodo. "Nunca copies nada de `negocio/`" sigue siendo una instrucción literal.

### 4.2 Este repo es la implementación de referencia del producto "workspace"

`producto/workspace/` en un repo de cliente (§7.2.4) tiene la misma forma que `bases/`, `vistas/` y `flujos/` de aquí. Deliberado: cuando mejoran su propio Notion, mejora la plantilla del producto.

Corolario útil: si algo de este repo no cabe en esa forma, o la forma está mal o eso es negocio.

### 4.3 `contexto/personas.md`

Guarda **rol y responsabilidad**, no persona. "El titular del asiento aprueba cambios de esquema" sí; correos, teléfonos o cualquier dato identificable, no. Un historial de git no se puede limpiar ni atender una solicitud de borrado. Los datos de las personas viven en Notion, que sí tiene granularidad.

---

## 5. `sentina-web`

El único repo con una aplicación corriendo: `src/` es el contenido principal y `contexto/` es soporte.

```
sentina-web/
├── CLAUDE.md
├── .sentina/manifiesto.yaml
│
├── contexto/
│   ├── arquitectura.md             # stack, hosting, dominio, pipeline de build
│   ├── analitica.md                # qué se mide, con qué herramienta, dónde caen los datos
│   ├── decisiones/                 # dec-<slug>.md
│   ├── sistemas/                   # stubs: sistema-notion.md (precios), sistema-<analitica>.md
│   └── glosario.md
│
├── contenido/                      # el copy vigente, una sección por archivo
│   ├── hero.md
│   ├── caracteristicas.md
│   ├── precios.md                  # espejo. fuente_de_verdad: notion
│   ├── preguntas-frecuentes.md
│   ├── llamados-a-la-accion.md
│   ├── legal/
│   │   ├── privacidad.md
│   │   └── cookies.md
│
├── src/
│   ├── components/
│   └── analytics/
│       ├── eventos.ts              # implementa seguimiento/eventos.json
│       ├── consentimiento.ts       # la compuerta. Ver §5.1
│       └── README.md               # cómo se agrega un evento, en cinco pasos
│
├── seguimiento/
│   ├── eventos.json                # los eventos de la landing. §10
│   ├── embudos.md                  # embudo → paso → evento que lo marca
│   ├── tableros.md                 # tablero → la pregunta que responde
│   └── validacion/
│       └── humo.md                 # cómo comprobar que un evento llega de verdad
│
├── evidencia/
└── .github/workflows/
```

### 5.1 Las tres reglas de este repo

**1 · `seguimiento/` guarda definiciones, nunca datos.** Ni un export de sesiones, ni un CSV, ni "un pedacito para probar el tablero". Los datos de interacción tienen dueño legal y el historial de git no se limpia.

**2 · `contenido/precios.md` es espejo y lo declara** (`fuente_de_verdad: notion`, `relationships: [{type: depende_de, target: "[[neg-matriz-de-oferta]]"}]`). El target resuelve mediante `contexto/referencias/neg-matriz-de-oferta.md`, stub externo con `repo_fuente: sentina-notion`. Publicar un precio es renderizar una decisión, no tomarla. Los márgenes nunca cruzan a este repo.

Los cambios de copy se explican con git y nodos `dec:` cuando existe una decisión; no se mantiene un `CHANGELOG.md` auxiliar dentro de `contenido/`.

**3 · `consentimiento.ts` es compuerta, no adorno.** Con tráfico europeo, la analítica no esencial exige consentimiento previo. Cada evento en `eventos.json` lleva `consentimiento_requerido: true|false`, y la implementación decide programáticamente qué dispara antes del consentimiento. Es la diferencia entre una regla y una buena intención.

---

## 6. `sentina-ghl`

Documentación y esquemas, sin código. Y **el repo con más riesgo de fuga de credenciales de los cuatro**, porque en GHL la URL de un webhook lleva el secreto dentro.

```
sentina-ghl/
├── CLAUDE.md
├── .sentina/manifiesto.yaml
│
├── contexto/
│   ├── arquitectura.md             # subcuentas, ubicaciones, qué vive en GHL y qué no
│   ├── decisiones/                 # dec-<slug>.md
│   ├── sistemas/                   # stubs de lo que GHL toca fuera: sistema-notion.md, sistema-n8n.md
│   └── glosario.md                 # vocabulario de GHL ↔ vocabulario de Sentina
│
├── esquema/
│   ├── campos-personalizados.json  # nombre, key, tipo, objeto, quién lo escribe
│   ├── etiquetas.md                # el diccionario. §6.1
│   ├── pipelines.json              # etapas, con criterio de entrada Y de salida
│   └── calendarios.json
│
├── flujos/
│   ├── <flujo>.md                  # disparador, condición, acciones, qué rompe si falla
│   └── dependencias.md             # ⚙️ GENERADO desde depende_de
│
├── webhooks/
│   ├── payloads/
│   │   └── <evento>.json           # forma del payload, ejemplos ANONIMIZADOS
│   └── endpoints.md                # tipo: contrato; nombre de variable. NUNCA la URL
│
├── evidencia/
└── .github/workflows/
```

### 6.1 `esquema/etiquetas.md` — cinco columnas, no dos

| Etiqueta | Significado | Quién la pone | Quién la lee | **Quién la quita** |
|---|---|---|---|---|

**La última columna es la que importa.** Un diccionario que solo dice qué significa cada etiqueta no previene nada. El bucle de etiquetas que ya encontraste en la auditoría —un cliente atrapado permanentemente— es exactamente lo que se vuelve visible cuando "quién la quita" queda vacío. **Una etiqueta sin salida documentada es un bucle esperando a ocurrir.**

### 6.2 Las URLs de webhook son credenciales

Una URL de webhook entrante **es** un secreto: quien la tiene dispara el flujo. `endpoints.md` guarda nombre del evento, nombre de la variable de entorno y qué flujo la consume. Nunca el valor. Y `metodo/estandares/secretos.md` lo dice explícitamente, porque no es obvio y un agente no lo va a inferir.

---

## 7. `sentina-<cliente>`

```
sentina-<cliente>/
├── CLAUDE.md → AGENTS.md           # FIJO. GEMINI.md también apunta a AGENTS.md
├── README.md
├── .env                            # FIJO. Config del vault, SIN secretos. Se commitea. §13.3
├── index.md · log.md · hot.md      # FIJO. Contabilidad del vault. §13.3
├── .manifest.json                  # FIJO. Ledger de ingestas de obsidian-wiki
├── _meta/taxonomy.md               # FIJO. Vocabulario de tags
├── .obsidian/                      # FIJO. app.json excluye lo que no es conocimiento
├── .skills/                        # FIJO. 20 skills wiki-* adaptadas. §13.4
├── .sentina/
│   ├── manifiesto.yaml             # declara el tipo de producto
│   └── bitacora-sync.md
│
├── contexto/                       # FIJO
│   ├── cliente.md                  # id cliente:<id>
│   ├── arquitectura.md             # id arq:<id>
│   ├── alcance.md                  # espejo del SOW de Notion, actualizado con minutas Notion AI (§12)
│   ├── decisiones/                 # dec-<slug>.md, frontmatter bi-temporal. §12
│   ├── sistemas/                   # sistema-<x>.md, stubs con fuente_de_verdad: externo. §3.2
│   └── glosario.md                 # id glosario:<id>
│
├── seguimiento/                    # FIJO — igual en los cuatro tipos de producto
│   ├── eventos.json
│   ├── destinos.md                 # a dónde se mandan y con qué identidad
│   ├── tableros.md                 # tablero → pregunta → para quién
│   └── validacion/humo.md
│
├── producto/                       # VARIABLE — uno o dos de los cuatro
│   └── <chatbot | agente-ia | automatizacion | workspace>/
│
├── evidencia/                      # FIJO. Fuera del vault de Obsidian
└── .github/workflows/              # FIJO — stubs a sentina-notion
```

Los archivos `.md` de `contexto/` y `producto/` llevan el frontmatter de §3.1. `seguimiento/` completo queda fuera de `OBSIDIAN_CATEGORIES`: contiene contratos operativos y pruebas, no nodos. Los archivos Markdown sueltos que no son nodos (`README.md`, `evidencia/INDICE.md`, `seguimiento/**/*.md`) tampoco se lint-ean como páginas (§13.3).

### 7.1 `manifiesto.yaml`

```yaml
version_esquema: 2

repo:
  tipo: cliente                    # template | notion | web | ghl | cliente
  id: sentina-dongsong
  version_plantilla: 2

cliente:
  id: dongsong
  nombre: Dongsong
  pagina_notion: "2ef49566-0000-0000-0000-000000000000"
  estado: activo                    # prospecto | activo | mantenimiento | cerrado

producto:
  tipo: [chatbot]                   # uno o varios: chatbot, agente-ia, automatizacion, workspace

sistemas:
  - id: ghl
    rol: crm
    dueno: israel
  - id: tiendanube
    rol: ecommerce
    dueno: israel
    acceso: solo_api

seguimiento:
  destino: <herramienta>

notion:
  registro_de_cambios: "32049566-0000-0000-0000-000000000000"
  tareas: "32849566-0000-0000-0000-000000000000"

secretos:
  # SOLO nombres. Ningún valor, nunca.
  requeridos: [GHL_API_KEY, TIENDANUBE_TOKEN]
  gestionados_en: github-actions-secrets
```

`repo.tipo` selecciona las categorías y los tipos permitidos. `producto.tipo` solo existe en repos de cliente: un agente sabe qué módulo esperar y el guardián falla si el directorio declarado no existe. `repo.version_plantilla` permite migrar cualquier perfil, no solo clientes.

En los perfiles `template`, `notion`, `web` y `ghl` se omiten por completo las secciones `cliente` y `producto`.

### 7.2 Los cuatro módulos

#### 7.2.1 `producto/chatbot/`

```
producto/chatbot/
├── prompt.md                       # el vigente, con marcadores BEGIN/END PROMPT
├── tools.json
├── intenciones.md                  # intención → cómo se detecta → respuesta esperada
├── conversacion/
│   └── <flujo>.md                  # árbol de conversación, uno por flujo
├── fallbacks.md                    # qué pasa cuando NO entiende
├── escalamiento.md                 # cuándo pasa a humano, a quién, con qué contexto
├── canales.md                      # WhatsApp / Messenger / web: formato y límites
└── pruebas/
    └── casos.jsonl
```

**`intenciones.md` y `fallbacks.md` son los dos archivos que nadie escribe y donde viven todos los bugs.** Los dos hallazgos de tu auditoría de GHL —la palabra clave de prueba que impedía la entrada de un cliente real, y la pregunta equivocada enviada siempre sin importar la intención detectada— son fallas de esos dos archivos. Existen porque ya los pagaste una vez.

#### 7.2.2 `producto/agente-ia/`

```
producto/agente-ia/
├── prompt.md
├── tools.json
├── permisos.md                     # qué puede escribir y DÓNDE. Lista concreta
├── memoria.md                      # qué recuerda, por cuánto, dónde vive
├── guardarrailes.md                # qué nunca hace, y qué contesta si se lo piden
├── cadencia.md                     # disparadores y costo por corrida
└── pruebas/casos.jsonl
```

La diferencia con `chatbot` no es cosmética: **un chatbot responde, un agente actúa.** `permisos.md` y `guardarrailes.md` no tienen equivalente allá, y son lo que se revisa antes de cada release — como lista de "puede escribir en X, no puede tocar Y", no como párrafo de buenas intenciones.

#### 7.2.3 `producto/automatizacion/`

```
producto/automatizacion/
├── flujos/
│   └── <flujo>.json                # export limpio: sin credenciales, sin datos reales
├── disparadores.md                 # disparador + CONDICIÓN. Nunca solo disparador
├── idempotencia.md                 # cómo se evita ejecutar dos veces lo mismo
├── manejo-de-errores.md            # qué pasa si falla un paso intermedio
├── runbook.md                      # cómo lo reinicia alguien a las 2 AM sin contexto
└── pruebas/
```

`disparadores.md` exige la condición al lado porque es el principio que ya escribiste: *una automatización rellena lo vacío, nunca sobrescribe lo que escribió una persona.* Un disparador sin condición documentada va a pisar trabajo humano.

`runbook.md` es lo que distingue una automatización entregada de una mantenible.

#### 7.2.4 `producto/workspace/`

```
producto/workspace/
├── modelo-de-acceso.md
├── bases/
│   ├── <base>.md
│   ├── relaciones.md
│   ├── formulas.md
│   └── rollups.md
├── vistas.md
├── navegacion.md                   # tiers, bloques sincronizados, dónde viven los maestros
├── plantillas.md
├── diseno-de-pagina.md             # Layout Builder por base
└── verificacion.md                 # checklist de prueba, incluida la cuenta externa
```

Misma forma que `sentina-notion` (§4.2). El módulo más pesado y el que más gana con la plantilla.

### 7.3 Dos tipos de producto en un repo

Un workspace con chatbot encima es frecuente. **Dos módulos hermanos, no un módulo híbrido**, y `producto.tipo: [workspace, chatbot]` en el manifiesto. Un híbrido es un módulo que no se puede comparar con ningún otro proyecto, y comparar es la razón entera de tener plantillas.

---

## 8. Reglas transversales

### 8.1 Ningún dato de usuario, en ningún repo

Ni exports de analítica, ni payloads con datos reales, ni CSV de contactos, ni capturas con nombres visibles. Los ejemplos van anonimizados. El historial de git no se filtra y un borrado solicitado no se puede atender.

### 8.2 Un hecho, un dueño

Una arista entre repos nunca apunta directamente a una ruta remota: apunta a un stub local resoluble. Los sistemas usan `contexto/sistemas/`; los demás tipos usan `contexto/referencias/`. El stub repite identidad y resumen para navegación, pero declara `fuente_de_verdad: externo` y `repo_fuente`, de modo que no compite con el nodo propietario.

| Hecho | Dueño | El otro guarda |
|---|---|---|
| Pricing y oferta | `sentina-notion/negocio/matriz-de-oferta.md` | `sentina-web/contenido/precios.md`, espejo declarado |
| Significado de una etiqueta de GHL | `sentina-ghl/esquema/etiquetas.md` | Los repos de cliente la referencian por ID, no la redefinen |
| El método de instalación | `sentina-notion/metodo/` | Los repos de cliente nacen de la plantilla y divergen a propósito |
| Convención de commits | `sentina-notion/metodo/estandares/commits.md` | Cada `CLAUDE.md` la resume, con enlace |
| Nombres de eventos | Cada repo localmente (`seguimiento/eventos.json`). Unificación global **deprecada** | Sin reconciliación ni dueño global (§10) |

### 8.3 Qué cuenta como credencial

Va en `metodo/estandares/secretos.md`. Más amplio de lo que parece:

- Tokens, API keys, client secrets — obvio
- **URLs de webhook entrante** — GHL, n8n, Make: la URL *es* la llave
- **IDs de base de Notion**, cuando la integración está compartida con esa base
- Enlaces de Loom o Drive sin restricción de acceso
- IDs de sesión o de usuario dentro de un payload de ejemplo

### 8.4 Los archivos marcados ⚙️ GENERADO no se editan

`dependencias.md`, `grafo.json`, `evidencia/INDICE.md` y `bitacora-sync.md`. Cada uno lleva `generado: true` en el frontmatter y una primera línea que lo dice. Los que viven dentro de una carpeta del vault (`flujos/dependencias.md`) llevan además el frontmatter core de §3.1 para que el lint no los rechace. El guardián falla un PR que toque a mano un archivo con `generado: true`, salvo que lo haya escrito un workflow (`GUARDIAN_ALLOW_GENERATED=1`). Editar uno a mano se pierde en la siguiente corrida, silenciosamente.

### 8.5 Los workflows se llaman, no se copian

Cuatro stubs por repo (`notion-sync.yml`, `guardian.yml`, `latido.yml`, `notion-publish-context.yml`). La lógica vive en `sentina-notion`. Un arreglo es un commit.

---

## 9. Qué hay que corregir en el spec v1

Las rutas en español rompen los YAML de `sentina-arquitectura-dual-v1.md`, que llevan rutas en inglés dentro. Sustituciones:

| En el spec v1 | Ahora |
|---|---|
| `.sentina/manifest.yaml` | `.sentina/manifiesto.yaml` |
| `.sentina/sync.log.md` | `.sentina/bitacora-sync.md` |
| `evidence/$EV/meta.yaml` | `evidencia/$EV/meta.yaml` |
| `yq '.claim'` · `yq '.result'` | `yq '.afirmacion'` · `yq '.resultado'` |
| `yq '.notion.registro_de_cambios_db'` | `yq '.notion.registro_de_cambios'` |
| `evidence/INDEX.md` | `evidencia/INDICE.md` |
| `grep -qE '^(agents\|integrations)/'` | `grep -qE '^(agentes\|producto\|esquema\|src)/'` |
| `grep -qE '^context/'` | `grep -qE '^contexto/'` |
| `uses: sentina/sentina-ops/...` | `uses: <org>/sentina-notion/...` |
| `estado: vigente \| borrador \| superado` | `lifecycle: vigente \| borrador \| archived` |
| `vigente_desde` · `vigente_hasta` | `valid_from` · `valid_until` |
| `supersede: <id-previo>` | `superseded_by: "[[nuevo-stem]]"` en el viejo + `relationships: [{type: replaces}]` en el nuevo |
| `depende_de: [ids]` | `relationships: [{type: depende_de, target: "[[stem]]"}]` |
| `contexto/decisiones.md` | `contexto/decisiones/dec-<slug>.md` |

Y el guardián gana pasos nuevos: **validar que toda arista (`relationships`, `superseded_by`) apunte a un nodo que exista, que los `id` y los stems sean únicos y que `aliases` contenga el `id`** (§3.2, regla 4). Lo implementa `.github/scripts/guardian.py`, que además llama a `obsidian-wiki lint` sobre las carpetas del vault.

Los campos de `meta.yaml` de evidencia quedan: `id`, `fecha`, `autor`, `tipo`, `sistema`, `afirmacion`, `resultado`, `tarea_notion`, `artefactos`, `decision_relacionada`.

---

## 10. Diferido y Deprecado

| Qué | Por qué | Cómo entra después |
|---|---|---|
| **Grafo con runtime (Graphiti)** | El grafo derivado cubre la necesidad y git conserva las ramas | `grafo.json` es el input de ingesta. §3.3 |
| **Repo aparte para `negocio/`** | Con dos socios, la carpeta basta | Cuando entre un tercero con asiento de Notion |

### 10.1 Deprecación definitiva de la taxonomía centralizada (Soberanía local de eventos)

El concepto de unificar la taxonomía de eventos o forzar una reconciliación global entre repositorios queda **oficialmente deprecado**. Cada repositorio (`sentina-web`, `sentina-<cliente>`, etc.) es responsable exclusiva y localmente de sus propios eventos en `seguimiento/eventos.json`, sin buscar reconciliación global ni pretender una centralización posterior.

Cada repo guarda sus eventos en **un solo archivo**, `seguimiento/eventos.json`, con la misma forma estándar en todos y nunca dispersos dentro del código:

```json
{
  "version_esquema": 1,
  "eventos": [
    {
      "id": "evento:cta_click",
      "nombre": "cta_click",
      "descripcion": "El usuario hace clic en un CTA primario",
      "estado": "activo",
      "consentimiento_requerido": true,
      "propiedades": [
        { "nombre": "cta_id", "tipo": "string", "requerida": true },
        { "nombre": "seccion", "tipo": "string", "requerida": true }
      ]
    }
  ]
}
```

Dos reglas locales obligatorias que se respetan en cada repositorio:

1. **Un evento se deprecia, nunca se renombra.** `estado: deprecado` más un evento nuevo. Renombrar rompe el histórico en la herramienta de analítica sin dejar rastro, y eso no se arregla nunca.
2. **Los nombres de evento en `snake_case` y en inglés.** Es la única excepción a §2, y no es capricho: los nombres de evento son claves que viajan a la herramienta de analítica y a sus tableros, donde acentos y mayúsculas causan problemas reales.

---

## 11. Sincronización bidireccional con Notion (Project Management)

El sistema opera bajo un modelo de dos planos claramente delimitados: **Notion actúa como la interfaz de usuario (UI), backlog y gestión operativa**, mientras que **Git es la única fuente de verdad técnica e inmutable**. La sincronización bidireccional garantiza alineación constante y previene colisiones de concurrencia entre agentes y humanos.

### 11.1 Regla de entrada (Inbound)

1. **Origen en Notion:** Toda iniciativa, tarea técnica o modificación de alcance se origina en la base de datos de tareas de Notion.
2. **Consulta por el Agente:** El agente consulta la API de Notion para identificar la tarea a ejecutar.
3. **Aislamiento en Git:** El agente clona o actualiza el repositorio correspondiente y crea una rama descriptiva de desarrollo:
   ```bash
   git checkout -b feat/tarea-<id-o-slug>
   ```
4. **Bloqueo de concurrencia en Notion:** Antes de escribir una sola línea de código, el agente actualiza el estado de la tarea en Notion a **"En curso"** y asigna explícitamente el responsable (Israel o el Usuario que ejecuta). Esto bloquea la tarea y previene que otros agentes o sesiones tomen el mismo trabajo en paralelo.

### 11.2 Regla de salida (Outbound)

1. **Apertura de Pull Request:** Al finalizar la implementación en la rama, se abre un Pull Request hacia `main`. El estado de la tarea en Notion cambia de inmediato a **"En revisión"**, asociando la URL del PR.
2. **Merge a `main` y ejecución de CI:** Al aprobarse y fusionarse (merge) el Pull Request en `main`, GitHub Actions dispara el workflow:
   ```yaml
   .github/workflows/notion-publish-context.yml
   ```
3. **Cierre y publicación de evidencias:**
   - Transiciona el estado de la tarea en Notion a **"Completada"**.
   - Lee la carpeta `evidencia/` del commit de merge (`meta.yaml`, resultados de validación, logs y artefactos).
   - Publica directamente en la página de la tarea en Notion el resumen del cambio y el bloque estructurado de evidencias, garantizando trazabilidad total sin fricción manual.

---

## 12. Procesamiento de minutas con Notion AI

Define el estándar para la actualización de contexto a partir de reuniones periódicas y sesiones de alineación técnica o de negocio.

### 12.1 Captura con Notion AI en el portal del cliente
Las minutas, acuerdos y transcripciones de llamadas se capturan inicialmente utilizando las capacidades de **Notion AI** directamente dentro del portal del cliente en Notion, produciendo un resumen ejecutivo, puntos acordados y tareas derivadas.

### 12.2 Flujo de destilación y compilación técnica hacia Git
A petición del usuario (o mediante trigger automatizado):
1. **Extracción directa:** El agente extrae las minutas procesadas desde Notion a través de la API.
2. **Registro de decisiones bi-temporales:** Traduce cada acuerdo a un archivo Markdown `contexto/decisiones/dec-<slug>.md`, con el frontmatter de §3.1:
   ```yaml
   ---
   id: dec:<slug-decision>
   aliases: ["dec:<slug-decision>"]
   title: <Decisión en una frase>
   category: contexto
   tipo: decision
   tags: [decision, <dominio>]
   dueno: israel
   fuente_de_verdad: notion
   lifecycle: vigente
   lifecycle_changed: YYYY-MM-DD
   valid_from: YYYY-MM-DD
   sources: ["notion:<id-de-la-minuta>"]
   summary: <≤200 caracteres>
   relationships:
     - type: depende_de
       target: "[[<stem>]]"
     - type: replaces                  # solo si supera una decisión anterior
       target: "[[dec-<slug-previo>]]"
   created: YYYY-MM-DDTHH:MM:SSZ
   updated: YYYY-MM-DDTHH:MM:SSZ
   ---
   ```
   Si supera una decisión previa, en esa se escribe `lifecycle: archived`, `lifecycle_changed`, `valid_until` y `superseded_by: "[[dec-<slug-nuevo>]]"` (§3.2 regla 3).
3. **Actualización de `contexto/alcance.md`:** Actualiza el espejo del Scope of Work (SOW), delimitando con precisión los límites del entregable y los requerimientos vigentes.
4. **Derivación de tareas al backlog:** Desglosa los acuerdos en tareas atómicas y las da de alta en la base de datos de tareas de Notion, enlazadas al ID de la decisión.
5. **Retroalimentación por CI:** Tras hacer merge en `main` del commit de contexto, el pipeline de CI actualiza el portal del cliente en Notion con el contexto digerido y consolidado.

---

## 13. Gestión de conocimiento local: Framework Obsidian-Wiki en el repo

La carpeta `contexto/` en todos los repositorios implementa los principios del framework **`obsidian-wiki` (creado por Ar9av)**.

### 13.1 El principio: "El conocimiento no se acumula, se compila por deltas"
Un repositorio no debe convertirse en un cementerio de notas desordenadas ni de transcripciones raw acumuladas. El conocimiento se **compila**:
- Cada nuevo dato, reunión o decisión actualiza y sintetiza las páginas canónicas (`arquitectura.md`, `decisiones/`, `alcance.md`, `glosario.md`).
- Los hechos obsoletos no se borran; se superan mediante bi-temporalidad (`superseded_by`, `valid_until`, `replaces`).
- Lo crudo no se commitea. `_raw/` existe solo como borrador local (está en `.gitignore`) para `/wiki-capture --quick`; lo que vale se compila a una página y el resto se descarta.

### 13.2 La raíz del repo como Vault nativo de Obsidian
El repositorio se abre directamente como un **Vault en Obsidian** (§3.4). `.obsidian/app.json` viene en la plantilla con `userIgnoreFilters` para `.github/`, `src/`, `evidencia/`, `.sentina/`, `.skills/`, `.claude/`, `.agents/`, `.gemini/`, `_raw/`:
- **Navegación visual del grafo:** Permite recorrer interactivamente los nodos (`arq:*`, `dec:*`, `sistema:*`, `base:*`) y visualizar sus aristas (`depende_de`, `replaces`, `superseded_by`) mediante la vista de grafo de Obsidian, sin depender de software pesado ni bases de datos de grafos externas como Graphiti o Neo4j. `/graph-colorize` tiñe por `tipo` y apaga los `archived`.
- **Enlaces tipados y wikilinks:** Uso fluido de enlaces internos (`[[wikilinks]]`; `OBSIDIAN_LINK_FORMAT` en `.env`) con retroenlaces automáticos que facilitan la navegación humana y el rastreo por agentes.
- **Auditoría de consistencia:** `/wiki-lint` y `/wiki-status` (modo insights) detectan huérfanos, islas y contradicciones antes de someter cambios al guardián de CI.

### 13.3 Archivos de contabilidad del vault (raíz del repo)

| Archivo | Qué es | Quién lo escribe |
|---|---|---|
| `.env` | Config del vault: `OBSIDIAN_VAULT_PATH=.`, `OBSIDIAN_CATEGORIES`, `OBSIDIAN_ALLOWED_LIFECYCLES=vigente,borrador`, `OBSIDIAN_ALLOWED_RELATIONSHIP_TYPES=depende_de`… **Se commitea y nunca lleva secretos**; el guardián falla si aparece una clave fuera de `OBSIDIAN_*` / `WIKI_*`. | `scaffold.py` selecciona `OBSIDIAN_CATEGORIES` una vez |
| `index.md` | Índice de todas las páginas, por categoría | Las skills, en cada escritura |
| `log.md` | Bitácora append-only de operaciones (`INGESTA`, `CONSULTA`, `AUDITORIA`…) | Las skills |
| `hot.md` | Snapshot de ~500 palabras de la actividad reciente, para que la siguiente sesión arranque sin recorrer el vault | Las skills |
| `.manifest.json` | Ledger de fuentes ingeridas (hash, fecha, páginas producidas); permite procesar solo el delta | `obsidian-wiki cache-update` o la skill |
| `_meta/taxonomy.md` | Vocabulario controlado de tags; mapea `negocio/**` → `visibility/internal`; prohíbe `visibility/pii` (§8.1) | `/tag-taxonomy` |

`OBSIDIAN_CATEGORIES` declara qué carpetas de primer nivel son vault. Lo que está fuera de esas carpetas (`README.md`, `evidencia/`, `.github/`) no se lint-ea como página.

### 13.4 Herramienta: `obsidian-wiki` sin modificar, skills adaptadas

- La plantilla lleva en `.skills/` 20 skills derivadas de `obsidian-wiki` (MIT), adaptadas al esquema de §3.1 y al idioma: los cuerpos de `SKILL.md` siguen en inglés (los lee el agente); todo lo que se escribe en el vault —páginas, encabezados, secciones del índice, verbos de la bitácora— va en español. `AGENTS.md` en la raíz es la fuente de esas convenciones.
- El CLI `pip install obsidian-wiki` es **opcional** y se usa tal cual sale de upstream: `lint`, `query --as-of`, `graph-analyse`, `context-pack`. **Nunca `obsidian-wiki setup`** en un repo Sentina: instalaría las skills upstream en `~/.claude/skills` por encima de las adaptadas.
- Sin el CLI, todas las skills funcionan con sus rutas manuales (grep/glob); se pierde `--as-of` y la validación estricta de fechas, que el guardián de CI sí ejecuta.

### 13.5 Scaffold de perfiles

`setup.sh` solo repara los symlinks de skills y los aliases `CLAUDE.md`/`GEMINI.md`. La materialización del repo es un comando separado, ejecutado una sola vez sobre un clon que aún declare `repo.tipo: template`:

```bash
python3 scaffold.py --tipo notion
python3 scaffold.py --tipo web
python3 scaffold.py --tipo ghl
python3 scaffold.py --tipo cliente --id <slug> --nombre "<Nombre>" --producto chatbot
```

En clientes, `--producto` se repite para declarar hasta dos módulos. El comando cambia `.env`, escribe el manifiesto discriminado, crea categorías y módulos, reidentifica los nodos semilla, reinicia la contabilidad y ejecuta el guardián. Se niega a operar sobre un repo ya perfilado o sobre nodos semilla modificados.

El CI valida además cuatro repos mínimos en `.github/fixtures/profiles/` mediante `python3 .github/scripts/guardian.py --profile-selftest --no-cli`. Esos fixtures son pruebas del contrato de perfiles, no plantillas para copiar.

---

## 14. Sistema de Habilidades (Skills Híbridos Pocock + Osmani)

El comportamiento de los agentes al desarrollar sobre los repositorios de Sentina se rige por especificaciones en texto plano almacenadas en `.skills/`. `metodo/` puede documentar el propósito y las reglas de esas capacidades como conocimiento, pero nunca contiene copias ejecutables de `SKILL.md`. Las skills de mantenimiento del vault (`wiki-*`, §13.4) ya viven en `.skills/`; las tres de desarrollo de esta sección **llegan de un repo aparte** cuando estén listas.

El sistema adopta la **ergonomía y foco de Matt Pocock** (habilidades basadas en texto que guían el flujo de trabajo) y la **inyección anti-racionalización de Addy Osmani** (tablas de reglas inflexibles que bloquean atajos cognitivos del modelo).

### 14.1 Habilidades base de desarrollo (Patrón Pocock)

1. **`/grill-me` (Auditoría previa e interrogatorio):**
   - El agente lee el contexto local (`contexto/`, `bases/`, `esquema/`, las aristas `relationships`).
   - Cuestiona activamente los requerimientos, detecta ambigüedades, asunciones no documentadas y dependencias antes de generar cualquier propuesta de código.
2. **`/to-spec` (De minuta a especificación atómica):**
   - Transforma las minutas de Notion AI y solicitudes del usuario en especificaciones técnicas formales.
   - Define archivos a tocar, IDs de grafo a crear o superar, aristas `depende_de`/`replaces`, casos de prueba y criterios de aceptación.
3. **`/implement` (Ejecución aislada y disciplinada):**
   - Conduce el desarrollo en la rama `feat/tarea-*` siguiendo rigurosamente el spec.
   - Ejecuta validaciones locales, genera evidencias y prepara el Pull Request.

### 14.2 Inyección Anti-Racionalización (Patrón Addy Osmani)

Los agentes tienden a justificar la omisión de estándares metodológicos bajo el pretexto de que los cambios son "pequeños" o "meramente internos". Para erradicar esto, las skills inyectan las siguientes cuatro tablas estrictas:

#### 1. Protección del Grafo
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Es solo un cambio menor de configuración o copy, no requiere tocar `contexto/`"* | Todo cambio de comportamiento o arquitectura altera el estado de verdad del sistema | Crear `contexto/decisiones/dec-<slug>.md` con su `id: dec:<slug>`, declarar `valid_from` y actualizar `relationships` en los nodos afectados. |
| *"Sobrescribo la decisión anterior directamente porque la nueva la reemplaza"* | Los hechos se superan, no se destruyen (bi-temporalidad) | En el nodo previo: `lifecycle: archived`, `lifecycle_changed`, `valid_until: <fecha>`, `superseded_by: "[[dec-<slug-nuevo>]]"`. En el nuevo: `relationships: [{type: replaces, target: "[[dec-<slug-previo>]]"}]`. |

#### 2. Prevención de Bucles (GHL)
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Solo necesitamos etiquetar el contacto al dispararse la automatización"* | Una etiqueta sin salida documentada es un bucle permanente y atrapa contactos | Si el spec toca `sentina-ghl`, **prohibido generar código, JSON o YAML sin haber documentado la columna 'Quién la quita' en `esquema/etiquetas.md`**. |
| *"Luego agregamos la condición de salida cuando probemos el flujo en vivo"* | La seguridad de esquemas es previa a la ejecución | Exigir en `/to-spec` y validar en `/implement` que toda etiqueta referenciada tenga sus 5 columnas completas (§6.1). |

#### 3. Seguridad, Privacidad y Secretos
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"Pongo la URL completa del webhook en el JSON de prueba para validar que funcione"* | Una URL de webhook entrante **es** una credencial ejecutable (§6.2, §8.3) | **Jamás escribir URLs reales de webhook en archivos JSON o de configuración.** Usar siempre la variable de entorno y registrarla en `webhooks/endpoints.md`. |
| *"Uso un payload de cliente real como ejemplo porque es más realista"* | Cero datos de cliente en repositorios Git (§8.1) | Anonimizar estrictamente todo nombre, correo, teléfono, identificador y monto antes de guardarlo en el repositorio. |

#### 4. Regla de Evidencia Obligatoria
| Excusa habitual del agente | Invariante Sentina | Acción obligatoria |
|---|---|---|
| *"El cambio fue una llamada API que dio 200, no hace falta guardar evidencia formal"* | Si no hay evidencia reproducible, el hecho no existe técnicamente | Todo PR que toque o interactúe con sistemas externos (Notion, GHL, webhooks, APIs) **requiere forzosamente poblar `evidencia/<id>/meta.yaml` y su correspondiente artefacto o log**. |
| *"La evidencia se puede subir en un commit posterior tras el merge"* | El merge en `main` dispara el workflow automático a Notion | La evidencia debe estar commiteada en la rama antes de abrir el PR para que `.github/workflows/notion-publish-context.yml` la publique al fusionar. |
