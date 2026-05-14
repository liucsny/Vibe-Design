# Content Ecosystem Design Foundations

## Source
- Figma file: https://www.figma.com/design/gYZObm5AoqSEwYDfclY4HJ/Content-Ecosystem-Design
- Style Doc page: `148:2214`

## Foundation Frames
- Color Palette: `148:2215`
- Color Usage: `148:3009`
- Typography: `148:3578`
- Border / Radius: `148:3718`
- Spacing: `148:3768`

## Local Variables And Styles
- Variable collection: `content-eco`
- Modes: `light`, `dark`
- Variable count observed: `282`
- Text styles observed: `32`
- Paint styles observed: `285`
- Effect styles observed: `5`

## Text Styles
Use library text styles before hard-coded font settings.

Available families observed:
- `Header/header-1`
- `Header/header-2`
- `Header/header-3`
- `Header/header-4`
- `Header/header-5`
- `Header/header-6`
- `Paragraph/small`
- `Paragraph/regular`

Variants observed:
- `EN-Regular`
- `EN-Semi Bold`
- `CN-Regular`
- `CN-Semi Bold`

## Usage Colors
Use `Semi/usage/*` paint styles or `content-eco` variables before hard-coded fills.

Observed examples:
- `Semi/usage/bg/--color-bg-0`
- `Semi/usage/bg/--color-bg-base`
- `Semi/usage/text/--color-text-0`
- `Semi/usage/text/--color-text-1`
- `Semi/usage/text/--color-text-2`
- `Semi/usage/text/--color-text-3`
- `Semi/usage/fill/--color-fill-0`
- `Semi/usage/info/--color-info`
- `Semi/usage/link/--color-link`
- `Semi/usage/data/--color-data-*`

## Spacing
Observed spacing tokens:
- `$spacing-none`: 0
- `$spacing-super-tight`: 2px
- `$spacing-extra-tight`: 4px
- `$spacing-tight`: 8px
- `$spacing-base-tight`: 12px
- `$spacing-base`: 16px
- `$spacing-base-loose`: 20px
- `$spacing-loose`: 24px
- `$spacing-extra-loose`: 32px
- `$spacing-super-loose`: 40px

## Radius
Observed radius tokens:
- `--border-radius-extra-small`: 3px
- `--border-radius-small`: 6px
- `--border-radius-medium`: 8px
- `--border-radius-large`: 12px
- `--border-radius-full`: 9999px
- `--border-radius-circle`: 50%

## Effects
Observed effect styles:
- `shadow-0`
- `shadow-1`
- `shadow-2`
- `shadow-knob`
- `shadow-elevated`

## Hard Rules
- Use library variables/styles when available.
- Do not introduce a new color palette unless the task explicitly requires a new semantic state and no existing token fits.
- Do not use style-doc frames as UI components; they are reference/foundation sources only.
