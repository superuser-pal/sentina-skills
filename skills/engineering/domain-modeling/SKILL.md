---
name: domain-modeling
description: Construye y afila el modelo de dominio y glosario del repositorio (contexto/glosario.md en repos Sentina, CONTEXT.md en proyectos genéricos). Se usa al discutir terminología o registrar decisiones de arquitectura notables.
---

# Domain Modeling (Modelado de Dominio)

Construye y afila activamente el modelo de dominio y la terminología del proyecto mientras diseñas. Desafía términos ambiguos, propone nombres canónicos y actualiza el glosario y las decisiones en el momento en que se cristalizan, en el vault o en `CONTEXT.md` según el repo.

---

## Detectar el Modo del Repo

Confirma si existe `.sentina/manifiesto.yaml` en la raíz del repo (ver `.agents/sentina-mode.md`):

- **Presente (modo Sentina):** el dominio vive en el grafo de conocimiento bajo `contexto/`, como se describe abajo.
- **Ausente (modo genérico):** no hay vault. El dominio vive en el `CONTEXT.md` de la raíz del repo (créalo si no existe): un glosario plano, sin frontmatter ni grafo. Las decisiones arquitectónicas notables e irreversibles se registran como entradas fechadas dentro del mismo `CONTEXT.md`, no como nodos separados.

---

## Estructura en Repositorios Sentina (modo Sentina)

En el ecosistema Sentina, el dominio y las decisiones se modelan dentro del grafo de conocimiento:

```
/
├── contexto/
│   ├── glosario.md                   ← Vocabulario controlado (id: glosario:*)
│   ├── arquitectura.md               ← Arquitectura y sistemas (id: arq:*)
│   ├── alcance.md                    ← Alcance del producto o sistema
│   └── decisiones/                   ← Decisiones arquitectónicas bi-temporales
│       ├── dec-001-modelo-eventos.md ← id: dec:001-modelo-eventos
│       └── dec-002-migrar-ghl.md
```

- Cada término del glosario o decisión es un nodo del grafo con identificador estable (`id: glosario:<slug>`, `id: dec:<slug>`).
- En carpetas de decisiones, se sigue la regla bi-temporal: una decisión superada no se sobreescribe; se archiva (`lifecycle: archived`, `valid_until`) y se enlaza mediante `replaces` / `superseded_by`.

---

## Estructura en Proyectos Genéricos (modo genérico)

Sin vault, el dominio vive en un único archivo, el `CONTEXT.md` de la raíz:

```
/
└── CONTEXT.md   ← Glosario y decisiones notables, texto plano, sin frontmatter
```

- Cada término ambiguo que se resuelva se documenta como una entrada corta en `CONTEXT.md`.
- Una decisión arquitectónica notable (los mismos tres criterios de la sección 6 más abajo) se agrega como una entrada fechada, sin bi-temporalidad ni identificadores estables: cuando se supera, se reemplaza en el mismo archivo, no se archiva por separado.

---

## Durante la Sesión

### 1. Desafiar contra el glosario
Cuando el usuario o el agente use un término que entre en conflicto con el glosario (`contexto/glosario.md` en modo Sentina, `CONTEXT.md` en modo genérico), señálalo de inmediato: *"El glosario define 'contacto' como X, pero aquí parece utilizarse como 'lead cualificado'. ¿Cuál es la distinción precisa?"*

### 2. Afilar lenguaje ambiguo
Cuando se usen términos sobrecargados, propón un término canónico exacto. Evita sinónimos o polisemia en conceptos nucleares del negocio.

### 3. Discutir escenarios concretos
Prueba los límites de los conceptos con escenarios reales y casos extremos. No aceptes abstracciones vagas sin validar cómo interactúan con las bases de datos y flujos de automatización.

### 4. Contrastar con el código y esquemas
Verifica si el código real y los esquemas concuerdan con la terminología descrita: en modo Sentina, `bases/`, `esquema/etiquetas.md`, `webhooks/`; en modo genérico, los tipos y esquemas propios del proyecto. Si hay discrepancia, resuélvela antes de avanzar.

### 5. Actualizar el glosario inline
Cuando se acuerde un término nuevo o se clarifique uno existente, actualiza el glosario inmediatamente (`contexto/glosario.md` en modo Sentina, `CONTEXT.md` en modo genérico). Mantén el glosario libre de detalles efímeros de implementación; es un vocabulario semántico del dominio.

### 6. Registrar Decisiones Arquitectónicas
Crea un nuevo registro de decisión (`contexto/decisiones/dec-<slug>.md` en modo Sentina, una entrada fechada en `CONTEXT.md` en modo genérico) únicamente cuando la decisión cumpla:
1. **Difícil de revertir:** el costo de cambiar de opinión más adelante es significativo.
2. **Impacto estructural:** altera cómo se estructuran bases, flujos, contratos o responsabilidades.
3. **No obvia:** existían alternativas reales y hubo que sopesar compensaciones (trade-offs).
En modo Sentina, incluye siempre su frontmatter con `id: dec:<slug>`, `valid_from`, y las aristas `relationships` correspondientes.
