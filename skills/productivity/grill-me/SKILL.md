---
name: grill-me
description: Auditoría previa e interrogatorio implacable sobre un requerimiento, minuta o idea antes de planificar o escribir código. Lee el contexto local de Sentina y desafía supuestos.
disable-model-invocation: true
---

# Grill Me (Auditoría previa e interrogatorio)

Audita y cuestiona activamente los requerimientos, minutas de Notion AI o solicitudes de usuario antes de generar cualquier propuesta de código o especificación técnica.

## Prerrequisito

Si la tarea viene de Notion, confirma que ya se hizo el bloqueo de concurrencia (§11.1.4): estado "En curso" y responsable asignado en la tarea de Notion. Si no se ha hecho, adviértelo antes de continuar: interrogar y planear sobre una tarea sin bloquear invita a que otra sesión tome el mismo trabajo en paralelo.

## Proceso

### 1. Lectura obligatoria del contexto local
Antes de formular cualquier pregunta, lee el contexto del repositorio:
- `.sentina/manifiesto.yaml`: tipo de perfil (`notion`, `web`, `ghl`, `cliente`) y módulos activos.
- `contexto/`: revisa `arquitectura.md`, `decisiones/`, `alcance.md` y `glosario.md`.
- Carpetas de dominio según el perfil: `bases/`, `flujos/`, `esquema/etiquetas.md`, `webhooks/endpoints.md`, o `producto/`.
- Las aristas existentes en el frontmatter (`relationships`: `depende_de`, `replaces`).

### 2. Identificar el punto de partida
- Si existe una tarea de Notion (rama `feat/tarea-*`) o una minuta de reunión, tómala como entrada inicial.
- Si no, toma la idea o solicitud expresada por el usuario en la conversación.

### 3. Interrogatorio por rondas (Patrón Frontera / Grilling)
Aplica la disciplina de `/grilling`:
- Mapea el problema como un **árbol de diseño**.
- La **frontera** son las preguntas cuyos prerrequisitos ya están claros: formula todas las preguntas de la frontera en una sola ronda numerada, proponiendo siempre tu **respuesta recomendada** (`➡️`).
- **Encontrar hechos en el repositorio es tu trabajo, nunca del usuario.** Inspecciona archivos, tipos, relaciones y esquemas por tu cuenta; no preguntes lo que puedes leer en el vault. Las decisiones de negocio, diseño y alcance son del usuario.
- Cuestiona activamente:
  - ¿Qué dependencias ocultas o efectos colaterales existen con otros nodos (`depende_de`)?
  - ¿Alguna dependencia pertenece a otro repo? Si es así, ¿existe ya su stub local (`contexto/sistemas/` o `contexto/referencias/`, §3.2 regla 4) o hay que crearlo?
  - Si toca `sentina-ghl`, ¿se han definido las 5 columnas de toda etiqueta y quién la retira?
  - ¿Hay credenciales, webhooks o datos de clientes involucrados que deban protegerse o anonimizarse? Recuerda que un ID de base de Notion compartida o un enlace de Loom/Drive sin restricción también cuentan como credencial (§8.3).
  - ¿Requiere crear o superar una decisión (`contexto/decisiones/dec-<slug>.md`)?

### 4. Cierre
La sesión concluye cuando la frontera está vacía y se ha alcanzado un entendimiento compartido sin supuestos tácitos. No generes código en esta etapa. Ofrece continuar con **/to-spec** para formalizar la especificación atómica.

