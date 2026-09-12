---
name: domain-modeling
description: Construye y afila el modelo de dominio y glosario del repositorio. Se usa al discutir terminología, editar contexto/glosario.md o registrar decisiones bi-temporales en contexto/decisiones/.
---

# Domain Modeling (Modelado de Dominio)

Construye y afila activamente el modelo de dominio y la terminología del proyecto mientras diseñas. Desafía términos ambiguos, propone nombres canónicos y actualiza el glosario y las decisiones del Vault en el momento en que se cristalizan.

---

## Estructura en Repositorios Sentina

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

## Durante la Sesión

### 1. Desafiar contra el glosario
Cuando el usuario o el agente use un término que entre en conflicto con el glosario en `contexto/glosario.md`, señálalo de inmediato: *"El glosario define 'contacto' como X, pero aquí parece utilizarse como 'lead cualificado'. ¿Cuál es la distinción precisa?"*

### 2. Afilar lenguaje ambiguo
Cuando se usen términos sobrecargados, propón un término canónico exacto. Evita sinónimos o polisemia en conceptos nucleares del negocio.

### 3. Discutir escenarios concretos
Prueba los límites de los conceptos con escenarios reales y casos extremos. No aceptes abstracciones vagas sin validar cómo interactúan con las bases de datos y flujos de automatización.

### 4. Contrastar con el código y esquemas
Verifica si el código real o los esquemas (`bases/`, `esquema/etiquetas.md`, `webhooks/`) concuerdan con la terminología descrita. Si hay discrepancia, resuélvela antes de avanzar.

### 5. Actualizar el glosario inline
Cuando se acuerde un término nuevo o se clarifique uno existente, actualiza `contexto/glosario.md` inmediatamente. Mantén el glosario libre de detalles efímeros de implementación; es un vocabulario semántico del dominio.

### 6. Registrar Decisiones Arquitectónicas (Decisiones en `contexto/decisiones/`)
Crea un nuevo nodo de decisión en `contexto/decisiones/dec-<slug>.md` únicamente cuando la decisión cumpla:
1. **Difícil de revertir:** el costo de cambiar de opinión más adelante es significativo.
2. **Impacto estructural:** altera cómo se estructuran bases, flujos, contratos o responsabilidades.
3. **No obvia:** existían alternativas reales y hubo que sopesar compensaciones (trade-offs).
Incluye siempre su frontmatter con `id: dec:<slug>`, `valid_from`, y las aristas `relationships` correspondientes.
