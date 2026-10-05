# GLOSSARY.md Format

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences max. Define what it is, not what it does.
- **Only include terms specific to this project's context.** General programming concepts do not belong. Before adding a term, ask whether it is unique to this domain or a general programming concept.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to one cohesive area, a flat list is fine.

## Single-context and multi-context repos

**Single context (most repos):** one `GLOSSARY.md` at the repo root.

**Multiple contexts:** a `GLOSSARY-MAP.md` at the repo root lists the contexts, where they live, and how they relate:

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md): manages warehouse picking and shipping

## Relationships

- **Ordering to Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment to Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering and Billing**: Shared types for `CustomerId` and `Money`
```

Infer the structure:

- If `GLOSSARY-MAP.md` exists, read it to find contexts.
- If only a root `GLOSSARY.md` exists, use the single context.
- If neither exists, create a root `GLOSSARY.md` lazily when the first term is resolved.

When multiple contexts exist, infer which one the topic belongs to. Ask only when the target remains ambiguous.
