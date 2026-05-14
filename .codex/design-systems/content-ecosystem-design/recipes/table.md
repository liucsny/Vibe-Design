# Recipe: Table

## Load When
- The surface displays dependencies, version history, evaluation rows, rollout stages, review queues, or any scannable row/column data.

## Public Components
- `Table`
- `Header`
- `Column`
- `Row`
- `Cell`
- `Actions Cell`
- `Pagination`

## Hard Rules
- Use table components for structured row/column data.
- Do not build tables as loose lines, rectangles, and text.
- Header, Row, Cell, and Actions Cell should remain semantically nested.
- Column and cell text in fixed-width columns must use truncation when values can overflow.
- Decision-critical truncated cell values need tooltip, popover, or linked detail view.
- Use `Actions Cell` for row-level actions.

## Evidence
Record table component names/keys, column structure, truncation fields, and fallback reasons.
