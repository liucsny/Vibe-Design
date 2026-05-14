---
name: vine-design-core
description: Core Vine design language and product UI principles. In raw PRD-to-UI workflows, use only during Final UI generation or later UI design review after Intent / Requirement, Flow Spec, and UI Generation Spec are complete. Do not use for Intent / Requirement, Flow Spec, or UI Generation Spec.
---

# Vine Design Core

## Entry Boundary

This skill is not the default entrypoint for raw PRDs, feature briefs, or broad PRD-to-UI requests.

Start raw PRD-to-UI work with `design-workflow-orchestrator`. Load this skill only after Intent / Requirement, Flow Spec, and UI Generation Spec are complete, when the workflow reaches concrete Vine UI generation, screen review, page archetype decisions, or design-system decisions.

## Purpose
This document provides the foundational rules for generating Vine interfaces.

Use this skill to:
- understand Vine’s product context before generating any UI
- identify the correct page archetype for a task
- preserve structural consistency across pages
- enforce shared B-end design rules across modules
- prevent the model from producing visually plausible but structurally incorrect output

This is the base layer for all other Vine design skills.

## What Vine Is
Vine is an enterprise AI platform for model creation, prompt engineering, supervised fine-tuning, evaluation, workflow orchestration, and agent-assisted operations.

Vine is not:
- a marketing site
- a consumer product
- a content browsing app
- a decorative concept showcase

Vine is:
- task-oriented
- workflow-heavy
- information-dense
- stateful
- version-aware
- evaluation-driven
All generated UI should reflect these qualities.

## Platform Constraint
Vine is a desktop-first PC product.
Default design assumptions:
- default canvas width: `1280px`
- prioritize desktop layout and interaction patterns
- do not generate mobile-first, tablet-first, or responsive-consumer layouts unless explicitly requested

## Core Design Goals
Every Vine interface should optimize for the following goals:

### 1. Structural clarity
Users should quickly understand:
- what this page is for
- what object or task it belongs to
- what the next action is

### 2. Operational efficiency
The interface should support frequent enterprise actions such as:
- scanning
- filtering
- configuring
- comparing
- validating
- reviewing
- submitting
- releasing

### 3. Consistency over novelty
Reuse existing Vine page types and interaction patterns before inventing new layouts.

### 4. State visibility
Important states must remain visible, especially:
- object status
- version
- progress
- evaluation result
- deployment state
- running / failed / success states

### 5. Decision support
Vine pages should help users make decisions, not only display content.

### 6. Scalable density
The UI should support high information density without becoming visually chaotic.


## Product Tone
Vine follows a restrained, professional, system-oriented B-end tone.

### Visual tone
- clean
- stable
- neutral
- information-first
- lightly branded
- low decoration

### Interaction tone
- explicit
- predictable
- low-surprise
- task-driven
- state-aware
- workflow-aware

### Content tone
- concise
- direct
- descriptive
- non-marketing
- system-friendly

Avoid expressive, playful, emotional, or consumer-style UI language.

## Clear hierarchy
Pages should make it easy to distinguish:
- primary content
- supporting information
- status information
- secondary controls
- contextual help
Avoid layouts where everything competes equally for attention.

---

## What This Core Skill Does Not Cover
This core file does not define all details.

Use other Vine design files for:
- page-specific structure and examples
- common pattern logic
- component-level interaction rules
- page examples and reference cases

Recommended skills:
- `vine-design-tokens`: Defines how to use tokens (color, typography, radius) to style Vine interfaces.
- `vine-design-components`: Defines usage guidelines for core UI components.
<!-- - `vine-design-patterns`: Defines the common interaction patterns used in Vine interfaces.
- `vine-design-examples`: Provides representative Vine page examples that follow the core design rules. -->

---
## Icon Consistency
Icons in Vine must be checked carefully, regardless of whether they are pasted from Figma or generated directly in Pencil.

Default rules:
- **Color**: icon color must remain consistent with its context. In most cases, it should be equal to or slightly lighter than the adjacent text color. When used inline with text, the icon should usually be slightly lighter than the text to avoid competing with readability.
- **Size**: icon size should scale with adjacent text size. As text gets larger, the icon should be reduced by a larger amount. Example: 20px text → 18px icon, 14px text → 14px icon. The inner path must scale together with the outer container.
- **Context-aware icon selection**: the model should always choose icons based on the current context, rather than blindly keeping the icon bundled with a component. If the default icon does not match the action, meaning, or layout, the model should replace it or remove it.
- **Default source**: prefer icons from `eco-icons.lib.pen` whenever possible.

Do not:
- do not assume imported or generated icons are already correct
- do not leave icon color inconsistent with nearby text or component state
- do not let the inner path scale incorrectly relative to its container
- do not force problematic icons to remain if a better contextual replacement is available

## Icon Resize Integrity
Icons in Vine must preserve structural integrity when resized.

Default rules:
- resizing an icon must resize both the outer container and the inner path content together
- the inner path must remain centered within the outer container after resize
- the inner path must scale proportionally with the outer container
- the inner path must not remain at its original size when the outer container changes
- the inner path must not become detached, cropped, stretched, or visually off-center after resize
- if resizing breaks path integrity, the model should replace the icon, reset it to a standard size, or use a more stable icon source instead
- whenever the icon size is changed, the model must update the inner path size together with the outer container. Resizing only the outer frame without resizing the inner path is invalid.

Do not:
- do not resize only the outer frame while leaving the inner path unchanged
- do not keep an icon if the inner path no longer matches the container size
- do not force repeated manual scaling on a broken icon structure

### Icon Color Integrity
- the outer icon frame or container should remain colorless by default and should not be used as the main color layer
- icon color must be applied to the inner path content, not to the outer frame
- when adjusting icon color, always modify the inner path color directly
- after resize, replacement, or restyling, check that the inner path color remains correct and consistent with the component context
- if the inner path color is lost, reset, or mismatched, replace or restyle the icon instead of keeping the broken asset

Do not:
- do not color the outer frame as a shortcut for changing icon color
- do not leave the outer frame colored while the inner path remains incorrect
- do not keep an icon if frame color and inner path color are visually inconsistent

---

## Do
- reuse existing Vine page archetypes
- make the page purpose obvious
- preserve object identity, status, version, and next action
- keep layout predictable
- make enterprise workflows easy to scan and operate
- expose state clearly
- support evaluation and review loops where needed
- prioritize structural correctness over visual novelty
- use concise and operational language
- keep interfaces professional and task-oriented

---

## Don’t
- do not design Vine pages like consumer apps
- do not use decorative or playful visual language
- do not remove structural elements just to make the UI look simpler
- do not turn complex workflows into generic minimal layouts
- do not hide version, state, or review logic
- do not invent new page structures when an existing Vine archetype already fits
- do not overuse cards where lists, tables, or structured panels are more appropriate
- do not collapse enterprise review tasks into plain text chat or plain forms
- do not mix too many primary goals in one page

---

## Output Requirements
Any UI generated under Vine design rules should:
- clearly map to one Vine page archetype
- preserve Vine’s B-end structure
- keep task flow understandable
- expose object identity, state, and version where relevant
- support human review where the workflow requires it
- remain compatible with existing Vine components and patterns
- be reviewable by a designer without major structural rework

These product traits should take priority over visual novelty in all generated UI.
