# Input
Use Input for:
- plain text
- password
- email
- number
- search keyword
- simple structured text fields

## Input Families
- `Input_Text`: for plain text, password, email, and search keyword
  - `Input_Search`: for search keyword
- `Input_Number`: for numeric input when the value is quantitative and should be constrained as a number
- `Input_Group`: for grouping closely related input and select fields

## Prefix and Suffix
Input may include:
- `Input_Prefix`
  - icon
  - label
- `Input_Suffix`
  - maxcount
  - icon
  - label

### Prefix / Suffix Rules
- prefix and suffix should support understanding
- use icons when they improve recognition
- use labels when they are short and stable
- do not overload one input with too many extra elements

## Sizes
Input support the following sizes:
- `Default`: standard input size for most Vine interfaces
- `Small`: compact toolbars, dense table actions, or constrained inline usage
- `Large`: only use when stronger visual emphasis is truly needed

In Vine, `Default` should be the default choice.  
Do not mix multiple input sizes in the same action group without a clear reason.

## Value Display
Input content has two main states:
- `Placeholder`: empty state, using `--color-text-2`
- `Entered Value`: typing or filled state, using `--color-text-0`

Rules:
- placeholder is only for the empty state
- entered value replaces placeholder immediately
- entered value must not keep placeholder styling

## State Handling
Common interaction states include:
- `Default`
- `Hover`
- `Focused`
- `Disabled`: uninteractive state
- `ReadOnly`: read-only state, cannot be edited

## Status
Input support setting status.  
- `Error`：indicates an error, invalid input or required field

## Input Usage in Forms
In Vine forms, Input should usually be paired with a visible text label above the input field.
Take `Input_Usage_in_Forms` as reference.

Rules:
- use label to express field meaning
- use placeholder only as a lightweight hint
- if a visible label already exists, keep the placeholder short and generic
- for standard text input, placeholder may use `Please enter`
- do not use placeholder as the only field label in standard form layouts

Validation:
- validation feedback should stay directly below the related input field
- if validation fails, the input should switch to `Danger` state and display an error text below the field
- some inputs may use asynchronous validation
- during asynchronous validation, display a loading text below the field
- after asynchronous validation succeeds, display a success text below the field
- validation feedback must remain clearly associated with the field that triggered it

For detailed form-field structure and validation patterns, see the form pattern guidance.