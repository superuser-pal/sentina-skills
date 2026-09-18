---
name: excalidraw
description: Generate Excalidraw diagrams from a natural-language description and save them as .excalidraw files openable in Excalidraw, VS Code, or Obsidian.
disable-model-invocation: true
license: CC-BY-4.0
argument-hint: "what to draw, e.g. a flowchart, an ER diagram, or a system architecture"
metadata:
  author: "Felipe Rodrigues (github.com/felipfr), adapted for Sentina from tech-leads-club/agent-skills"
  version: "1.0.1"
---

# Excalidraw

Generate Excalidraw-format diagrams from natural language descriptions. Outputs a `.excalidraw` JSON file that opens directly in Excalidraw (web, VS Code extension, or Obsidian plugin), no live canvas or MCP server required.

This skill is user-invoked on purpose: the repo also has `diagram-design` for branded HTML/SVG/PNG diagrams, and the two would otherwise compete for the same "draw me a diagram" requests. Only reach for this skill when the user names it directly (e.g. "use excalidraw", "make an Excalidraw file for this") or explicitly asks for an editable `.excalidraw` output.

## Workflow

```
UNDERSTAND -> CHOOSE TYPE -> EXTRACT -> GENERATE -> SAVE
```

### Step 1: Understand the request

Analyze the user's description to determine:

1. **Diagram type**: use the decision matrix below.
2. **Key elements**: entities, steps, concepts, actors.
3. **Relationships**: flow direction, connections, hierarchy.
4. **Complexity**: number of elements (target under 20 for clarity).

### Step 2: Choose the diagram type and visual mode

**Diagram type:**

| User intent                | Diagram type          | Keywords                                       |
| --------------------------- | ---------------------- | ----------------------------------------------- |
| Process flow, steps         | **Flowchart**           | "workflow", "process", "steps"                  |
| Connections, dependencies   | **Relationship**        | "relationship", "connections", "dependencies"   |
| Concept hierarchy           | **Mind map**            | "mind map", "concepts", "breakdown"             |
| System design               | **Architecture**        | "architecture", "system", "components"          |
| Data movement               | **Data flow (DFD)**     | "data flow", "data processing"                  |
| Cross-functional processes  | **Swimlane**            | "business process", "swimlane", "actors"        |
| Object-oriented design      | **Class diagram**       | "class", "inheritance", "OOP"                   |
| Interaction sequences       | **Sequence diagram**    | "sequence", "interaction", "messages"           |
| Database design             | **ER diagram**          | "database", "entity", "data model"              |

**Visual mode**: decide upfront and apply it consistently to every element.

| Mode       | `roughness`             | `fontFamily` | When to use                                                |
| ---------- | ------------------------ | ------------ | ----------------------------------------------------------- |
| **Sketch** | `1`                      | `5`          | Default: informal, approachable, Excalidraw-native.          |
| **Clean**  | `0`                      | `2`          | Executive presentations, formal specs.                       |
| **Mixed**  | zones `0`, shapes `1`    | `5`          | Architecture diagrams (structural zones + sketchy shapes).   |

### Step 3: Extract structured information

Extract the key components for the chosen diagram type:

- **Nodes/entities**: what are the boxes/shapes?
- **Connections**: what connects to what, and with what label?
- **Hierarchy**: what contains what, what comes before what?
- **Decision points**: where does the flow branch?

For detailed extraction guidelines per diagram type, read [`references/element-types.md`](references/element-types.md).

### Step 4: Generate the Excalidraw JSON

**Critical: read [`references/excalidraw-schema.md`](references/excalidraw-schema.md) before generating your first diagram.** It has the correct element format, the text-container model, and the binding system.

Key rules for generation:

1. **Text inside shapes**: use `boundElements` on the shape and a separate text element with `containerId`. Never use a `label` shorthand:

   ```json
   [
     {
       "id": "step-1",
       "type": "rectangle",
       "x": 100, "y": 100, "width": 200, "height": 80,
       "boundElements": [{ "type": "text", "id": "text-step-1" }]
     },
     {
       "id": "text-step-1",
       "type": "text",
       "x": 130, "y": 128, "width": 140, "height": 24,
       "text": "My Step", "originalText": "My Step",
       "fontSize": 20, "fontFamily": 5,
       "textAlign": "center", "verticalAlign": "middle",
       "containerId": "step-1", "lineHeight": 1.25, "roundness": null
     }
   ]
   ```

2. **Arrow labels**: also use `boundElements` plus a separate text element with `containerId`. Never use a `label` shorthand on arrows:

   ```json
   [
     {
       "id": "arrow-1",
       "type": "arrow",
       "x": 100, "y": 150,
       "points": [[0, 0], [200, 0]],
       "boundElements": [{ "type": "text", "id": "text-arrow-1" }]
     },
     {
       "id": "text-arrow-1",
       "type": "text",
       "x": 160, "y": 132, "width": 80, "height": 18,
       "text": "sends data", "originalText": "sends data",
       "fontSize": 14, "fontFamily": 5,
       "textAlign": "center", "verticalAlign": "middle",
       "containerId": "arrow-1", "lineHeight": 1.25, "roundness": null
     }
   ]
   ```

3. **Arrow bindings**: use `startBinding`/`endBinding`, not `start`/`end`. Connected shapes must list the arrow in their `boundElements`:

   ```json
   {
     "id": "shape-1",
     "boundElements": [
       { "type": "text", "id": "text-shape-1" },
       { "type": "arrow", "id": "arrow-1" }
     ]
   }
   ```
   ```json
   {
     "id": "arrow-1",
     "type": "arrow",
     "startBinding": { "elementId": "shape-1", "focus": 0, "gap": 1 },
     "endBinding": { "elementId": "shape-2", "focus": 0, "gap": 1 }
   }
   ```

4. **Element order for z-index**: declare shapes first, arrows second, text elements last. This guarantees text renders on top and is never obscured by arrows or other shapes.

5. **Positioning**: use grid-aligned coordinates (multiples of 20px when `gridSize: 20`). Leave a 200-300px horizontal gap and a 100-150px vertical gap between elements.

6. **Unique IDs**: every element needs a unique `id`. Use descriptive IDs like `"step-1"`, `"decision-valid"`, `"arrow-1-to-2"`, `"text-step-1"`.

7. **Colors**: use a consistent palette.

   | Role                | Color       | Hex       |
   | -------------------- | ----------- | --------- |
   | Primary entities     | Light blue  | `#a5d8ff` |
   | Process steps        | Light green | `#b2f2bb` |
   | Important/central    | Yellow      | `#ffd43b` |
   | Warnings/errors      | Light red   | `#ffc9c9` |
   | Secondary            | Cyan        | `#96f2d7` |
   | Default stroke       | Dark        | `#1e1e1e` |

### Step 5: Save and present

1. Save as `<descriptive-name>.excalidraw`.
2. Provide a summary:

   ```
   Created: user-workflow.excalidraw
   Type: Flowchart
   Elements: 7 shapes, 6 arrows, 1 title
   Total: 14 elements

   To view:
   1. Visit https://excalidraw.com, then Open, then drag and drop the file.
   2. Or use the Excalidraw VS Code extension.
   3. Or open it in Obsidian with the Excalidraw plugin.
   ```

## Templates

Pre-built templates live in `assets/` as starting points. Use one when the diagram type matches; it provides correct structure and styling, so read it before generating that type for the first time and then modify it to match the user's request.

| Template          | File                                          |
| ------------------ | ---------------------------------------------- |
| Flowchart          | `assets/flowchart-template.json`               |
| Relationship       | `assets/relationship-template.json`            |
| Mind map           | `assets/mindmap-template.json`                 |
| Data flow (DFD)    | `assets/data-flow-diagram-template.json`       |
| Swimlane           | `assets/business-flow-swimlane-template.json`  |
| Class diagram      | `assets/class-diagram-template.json`           |
| Sequence diagram   | `assets/sequence-diagram-template.json`        |
| ER diagram         | `assets/er-diagram-template.json`              |

## Icon libraries

For architecture diagrams with service icons (AWS, GCP, Azure, and similar), read [`references/icon-libraries.md`](references/icon-libraries.md) when:

- The user requests an AWS/cloud architecture diagram.
- The user mentions wanting specific service icons.
- You need to check whether icon libraries are already set up locally.

`scripts/split-excalidraw-library.py` splits a downloaded `.excalidrawlib` file into per-icon JSON so icon data does not have to enter the model's context, and `scripts/add-icon-to-diagram.py` inserts a chosen icon into a diagram deterministically. `scripts/add-arrow.py` computes correct `startBinding`/`endBinding` geometry for connecting two existing elements, use it instead of hand-computing arrow points and bindings.

## Best practices

### Element count

| Diagram type            | Recommended | Maximum |
| ------------------------ | ------------ | ------- |
| Flowchart steps          | 3-10         | 15      |
| Relationship entities    | 3-8          | 12      |
| Mind map branches        | 4-6          | 8       |
| Sub-topics per branch    | 2-4          | 6       |

If the user's request exceeds the maximum, suggest breaking it into multiple diagrams:

> "Your request includes 15 components. For clarity, I recommend: (1) a high-level architecture diagram with 6 main components, (2) detailed sub-diagrams for each subsystem. Want me to start with the high-level view?"

### Layout

- **Flow direction**: left-to-right for processes, top-to-bottom for hierarchies.
- **Spacing**: 200-300px horizontal, 100-150px vertical between elements.
- **Grid alignment**: position on multiples of 20px for clean alignment.
- **Margins**: at least 50px from the canvas edge.
- **Text sizing**: 28-36px titles, 18-22px labels, 14-16px annotations.
- **Font**: use `fontFamily: 5` (Excalifont) for hand-drawn consistency, falling back to `1` (Virgil) if 5 is not supported.
- **Background zones**: for architecture diagrams, add semi-transparent dashed zone rectangles (`opacity: 35`, `strokeStyle: "dashed"`, `roughness: 0`) as the first elements in the array to create visual grouping regions. See [`references/excalidraw-schema.md`](references/excalidraw-schema.md) under Background Zones.
- **Element order**: zones, then shapes, then arrows, then text elements, so z-index comes out right and text always renders on top.

### Common mistakes to avoid

- Using `label: { text: "..." }` shorthand on shapes or arrows (not supported by the Excalidraw parser).
- Putting `text` directly on shape elements without `containerId`.
- Using `start`/`end` for arrow bindings; use `startBinding`/`endBinding` with `elementId`/`focus`/`gap` instead.
- Forgetting to add arrows to their connected shapes' `boundElements` arrays.
- Omitting `originalText`, `lineHeight`, `autoResize`, or `backgroundColor: "transparent"` from text elements inside containers.
- Omitting required base properties (`angle`, `strokeStyle`, `opacity`, `groupIds`, `frameId`, `index`, `isDeleted`, `seed`, `version`, `versionNonce`, `updated`, `link`, `locked`); elements without them will not render.
- Missing `"files": {}` at the top level of the JSON.
- Using `roundness: { "type": 3 }` on ellipses; ellipses must use `roundness: null`.
- Missing `lastCommittedPoint`, `startArrowhead`, `endArrowhead` on arrows.
- Declaring text elements before arrows, so text renders underneath and gets obscured.
- Floating arrows without bindings, so they will not move with shapes.
- Overlapping elements; increase spacing instead.
- Inconsistent color usage; define the palette upfront.
- Too many elements on one diagram; break into sub-diagrams.

## Validation checklist

Before delivering the diagram, verify:

- [ ] All elements have unique IDs.
- [ ] Every element has every required base property: `angle`, `strokeStyle`, `opacity`, `groupIds`, `frameId`, `index`, `isDeleted`, `link`, `locked`, `seed`, `version`, `versionNonce`, `updated`.
- [ ] `index` values are assigned in order (`"a0"`, `"a1"`, ...), with text elements getting higher values than shapes/arrows.
- [ ] The top-level JSON includes `"files": {}`.
- [ ] Shapes with text use `boundElements` plus a separate text element with `containerId`.
- [ ] Text elements inside containers have `containerId`, `originalText`, `lineHeight: 1.25`, `autoResize: true`, `roundness: null`, `backgroundColor: "transparent"`.
- [ ] Arrows use `startBinding`/`endBinding` (with `elementId`, `focus`, `gap`) when connecting shapes, plus `lastCommittedPoint: null`, `startArrowhead: null`, `endArrowhead: "arrow"`.
- [ ] Connected shapes list the arrow in their `boundElements` arrays.
- [ ] Element order is shapes, then arrows, then text elements.
- [ ] Ellipses use `roundness: null`, not `{ "type": 3 }`.
- [ ] Coordinates avoid overlap (check spacing).
- [ ] Text is readable (font size 16+).
- [ ] Colors follow a consistent scheme.
- [ ] The file is valid JSON.
- [ ] Element count stays reasonable (under 20 for clarity).

## Troubleshooting

| Issue                          | Solution                                                                                       |
| -------------------------------- | ------------------------------------------------------------------------------------------------ |
| Text not showing in shapes      | Use `boundElements` plus a separate text element with `containerId`, `originalText`, `lineHeight`. |
| Text hidden behind arrows       | Move text elements to the end of the `elements` array, after all arrows.                          |
| Arrows do not move with shapes  | Use `startBinding`/`endBinding` with `elementId`, `focus: 0`, `gap: 1`.                            |
| Shape not moving with arrows    | Add the arrow to the shape's `boundElements` array.                                               |
| Elements overlap                | Increase spacing between coordinates.                                                             |
| Text does not fit               | Increase shape width or reduce font size.                                                         |
| Too many elements               | Break into multiple diagrams.                                                                     |
| Colors look inconsistent        | Define the color palette upfront and apply it consistently.                                       |

## Limitations

- Complex curves are simplified to straight or basic curved lines.
- Hand-drawn roughness stays at the default (1) unless you set it explicitly.
- No embedded images in auto-generation; use icon libraries for service icons.
- Maximum recommended is 20 elements per diagram for clarity.
- No automatic collision detection; follow the spacing guidelines instead.
