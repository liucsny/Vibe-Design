---
name: vine-design-tokens
description: Vine semantic token guidance for color, typography, radius, hierarchy, state, and surface styling. In raw PRD-to-UI workflows, use only during Final UI generation, visual refinement, or later design review after Intent / Requirement, Flow Spec, and UI Generation Spec are complete. Do not use for Intent / Requirement, Flow Spec, or UI Generation Spec.
---

# Vine Design Tokens

## Entry Boundary

This skill supports concrete Vine UI styling decisions. In raw PRD-to-UI workflows, load it only during Final UI generation, visual refinement, or later design review, not while creating Intent / Requirement, Flow Spec, or UI Generation Spec.

For raw PRD-to-UI tasks, start with `design-workflow-orchestrator`.

## Purpose
This document defines the semantic token rules for Vine.

This version focuses on:
- color
- typography
- radius

Use this skill to:
- keep generated UI visually consistent
- ensure styles are driven by semantic meaning instead of decoration
- align Vine interfaces with the Semi-based token system
- reduce one-off styling decisions in AI-generated output

This file defines semantic usage rules, not full implementation specs.

---

## Token Philosophy
Vine uses tokens as semantic design variables, not arbitrary visual values.

Always prefer:
- semantic token roles

over:
- hard-coded hex values
- ad hoc styling
- page-specific visual improvisation

For Vine, token usage should optimize for:
- clarity
- consistency
- predictability
- maintainability

---

## Token Layers

### Usage Tokens
These are the primary tokens used in design and generation, such as:
- `--color-bg-base`
- `--color-text-0`
- `--color-border`
- `--color-primary`
- `--color-success`
- `--color-warning`
- `--color-danger`
- `--color-info`
- `--color-disabled-text`
- `--color-overlay-bg`
- `--color-data-*`

Use these first.

### Palette Tokens
These are lower-level color scales such as:
- `--brand-*`
- `--blue-*`
- `--grey-*`
- `--green-*`
- `--red-*`
- `--amber-*`

These are implementation references, not the primary design language for LLM generation.

Rule:
- prefer usage tokens over palette tokens

---

## Color Tokens

### Background
Use:
- `--color-bg-base` is a light gray background used to distinguish the page canvas from white content surfaces.
- `--color-bg-0` to `--color-bg-4` for content surfaces and layered backgrounds
- `--color-nav-bg` for navigation background where needed

Rules:
- keep the page base neutral
- use background differences to express structure
- do not use tinted backgrounds decoratively

### Text
Use:
- `--color-text-0`: High Emphasis. Applied to H1 and H2 headings to establish a dominant visual anchor. 
- `--color-text-1`: Medium Emphasis. Optimized for primary body copy and subtitles to ensure maximum readability. 
- `--color-text-2`: Low Emphasis. Designated for secondary descriptions and input placeholders to distinguish hints from user input.
- `--color-text-3`: Muted / Disabled. Reserved for metadata, secondary details, and inactive states to minimize visual weight.

Rules:
- do not use weak text colors for critical information
- use text color to express emphasis, not structural hierarchy

### Border
Use:
- `--color-border` for default structure
- `--color-focus-border` for focus state
- `--color-disabled-border` for disabled controls when needed

Rules:
- borders should clarify structure, not create clutter
- focus borders must remain clearly visible

### Fill
Use:
- `--color-fill-0` (Resting): The base fill for neutral interactive surfaces (Buttons, Inputs, Selects) in their default state. 
- `--color-fill-1` (Hover): Subtle feedback fill for interactive elements during mouse-over. 
- `--color-fill-2` (Active/Pressed): High-contrast feedback fill for the moment of interaction (click/touch). 
- `--color-fill-primary-*`: Reserved for brand-aligned actions and high-emphasis states (e.g., Primary Buttons, Selected Tabs).

Rules:
- fills should be subtle by default
- use them for hover, weak selection, or soft emphasis
- do not use large decorative fill blocks

### Primary
Use:
- `--color-primary`: Primary interaction emphasis. 
- `--color-primary-hover`: Primary interaction emphasis on hover. 
- `--color-primary-active`: Primary interaction emphasis on active state. 
- `--color-primary-disabled`: Primary interaction emphasis on disabled state. 
- `--color-primary-light-*`: Primary interaction emphasis on light states.

Rules:
- primary is for the main action or active emphasis
- do not overload a page with primary accents
- do not use primary as decoration

### Secondary and Tertiary
Use:
- `--color-secondary*`
- `--color-tertiary*`
- `--color-tertiary-light-*`

Rules:
- prefer tertiary for neutral low-emphasis controls
- use secondary only when a true secondary accent is needed
- if unsure, prefer primary + neutral + status colors

### Status
Use:
- success
- warning
- danger
- info

Mapping in Vine:
- running / processing → info
- success / pass / deployed → success
- caution / review-needed / risk → warning
- fail / invalid / delete / severe issue → danger

Rules:
- keep status meaning stable across all pages
- do not use status colors decoratively

### Disabled
Use:
- `--color-disabled-bg`
- `--color-disabled-fill`
- `--color-disabled-text`
- `--color-disabled-border`

Rules:
- disabled elements should feel intentionally unavailable
- disabled should not be confused with secondary emphasis

### Overlay
Use:
- `--color-overlay-bg` for modal and major overlay masks

Rules:
- use overlay only for true layered surfaces
- do not use overlay patterns for normal inline workflows

### Link
Use:
- `--color-link`
- `--color-link-hover`
- `--color-link-active`
- `--color-link-visited`

Rules:
- links are for navigation and lightweight contextual actions
- do not use text links where a button is needed

### Data Colors
Use:
- `--color-data-0` to `--color-data-19`

Rules:
- data colors are for analytical encoding only
- do not use data colors for workflow state
- keep category-to-color mapping stable within a chart

---

## Vine-Specific Color Constraints
- use semantic usage tokens instead of palette tokens
- keep state meaning stable across list, form, evaluation, agent, and workflow pages
- do not overload primary
- preserve B-end neutrality
- distinguish system meaning from data meaning:
  - status colors = workflow or system meaning
  - data colors = analytical meaning

---

## Typography Tokens

### Font Family
Vine uses:
`Inter, sans-serif`

Rules:
- prefer Inter for Latin content
- preserve reliable system fallback support
- do not introduce decorative fonts

### Full Type Scale
- `--font-header-1`: 32px
- `--font-header-2`: 28px
- `--font-header-3`: 24px
- `--font-header-4`: 20px
- `--font-header-5`: 18px
- `--font-header-6`: 16px
- `--font-regular`: 14px
- `--font-small`: 12px

### Preferred Usage in Vine
Although Vine defines a full type scale, the most commonly used typography styles are: 
- **Header-4-Semibold**: page main title 
- **Header-6-Semibold**: modal, panel, and bar main title 
- **Regular-Semibold**: title-like text
- **Regular-Regular**: standard text 
- **Small-Semibold**: emphasized supporting text 
- **Small-Regular**: auxiliary text

Rules:
- use the smallest text style that still preserves the correct hierarchy
- use typography to define structural level
- use text color to define emphasis level
- do not overuse large headings
- do not use semibold everywhere
- do not use small text for critical operational content

### Typography Hierarchy
Recommended order:
1. page title
2. local panel, modal, or bar title
3. title-like local emphasis
4. standard text
5. emphasized supporting text
6. auxiliary text

---

## Radius Tokens

### Available Radius Tokens
- `--semi-border-radius-extra-small`: 3px
- `--semi-border-radius-small`: 6px
- `--semi-border-radius-medium`: 8px
- `--semi-border-radius-large`: 12px
- `--semi-border-radius-circle`: 50%
- `--semi-border-radius-full`: 9999px

### Preferred Usage in Vine
Use most often:
- `--semi-border-radius-small` (6px): input, button, and compact controls
- `--semi-border-radius-medium` (8px): modal, card, and larger containers

Rules:
- radius should scale with component size
- compact controls use smaller radius
- larger containers use slightly larger radius
- circular elements use circle radius
- pill elements use full radius
- equivalent components in the same region should use the same radius token unless hierarchy requires otherwise
- avoid extra-large rounded corners in standard Vine pages

Do not:
- use large rounded corners to make Vine feel softer or more consumer-like
- apply `full` radius to ordinary cards or containers
- casually mix 6px, 8px, and 12px across equivalent components

---

## Relationship to Semi Design
Vine uses a Semi-based token system as the implementation foundation.

Interpretation rules:
- Semi provides the token structure
- Vine defines product-specific usage constraints
- usage tokens are preferred for generation
- palette tokens remain lower-level references

---

## LLM Generation Rules

### Always Do
- use semantic token roles
- keep backgrounds neutral and structured
- preserve stable status meaning
- use primary only for real emphasis
- use data colors only for analytical encoding
- use typography and text color together, but for different purposes
- keep the radius system consistent within the same page

### Never Do
- do not hard-code random hex values
- do not select colors directly from palette without reason
- do not use status colors decoratively
- do not use data colors for workflow state
- do not overload one screen with multiple accent colors
- do not invent one-off visual logic for a single page
- do not use typography or radius as decoration

---

## Output Checklist
Before finalizing a Vine design, check:

1. Are colors driven by semantic meaning rather than decoration?
2. Is primary color used only for true emphasis?
3. Are status colors consistent with their meaning?
4. Are data colors reserved for charts and analytical encoding?
5. Does typography preserve Vine’s restrained B-end hierarchy?
6. Does the radius system preserve control-vs-container distinction?
7. Are palette tokens avoided unless truly needed?
8. Does the page look consistent with the rest of Vine?

If any answer is no, revise before output.
