# Recipe: Button

## Load When
- The surface has explicit actions: submit, cancel, deploy, save, next, export, create, delete, retry, or open link.

## Public Components
- `Button_Solid`: primary action.
- `Button_Light`: important secondary action.
- `Button_Borderless`: low-emphasis toolbar or row action.
- `Button_Link`: navigation-like inline action.
- `Button_Group`: grouped mutually related actions.
- `Button_Split`: primary action with secondary menu.

## Hard Rules
- Do not draw buttons with rectangle + text.
- Use only one primary `Button_Solid` per page region unless a modal creates a separate decision context.
- Use danger/warning variants only for destructive or risk-bearing actions.
- Button label text should use Auto width.
- If the label can overflow in a fixed-width button, enable truncation and expose full label through tooltip or action detail.

## Evidence
Record component name/key or fallback reason in `final-ui-reference.md`.
