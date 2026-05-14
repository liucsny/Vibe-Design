# Button
Buttons trigger actions. Use buttons for:
- create
- confirm
- submit
- start
- deploy
- edit
- remove
- open secondary utilities
Do not use buttons for passive status display or plain text navigation.

## Button Families
- `Button_Solid`
- `Button_Light`
- `Button_Borderless`
- `Button_Link`
- `Button_Split`
- `Button_Group`

All button families support the same type, size and content options.

## Semantic Types
Each button family may use one of the following semantic types:
- `Primary`: the main action in a page or section
- `Tertiary`: supporting action with lower emphasis
- `Warning`: cautionary action that needs attention but is not destructive
- `Danger`: destructive or high-risk action

Use semantic type to express action priority and meaning, not visual preference.


## Sizes
Buttons support the following sizes:
- `Default`: standard button size for most Vine interfaces
- `Small`: compact toolbars, dense table actions, or constrained inline usage
- `Large`: only use when stronger visual emphasis is truly needed

In Vine, `Default` should be the default choice.  
Do not mix multiple button sizes in the same action group without a clear reason.

## Content Types
Buttons support the following content structures, in order of common hierarchy:
1. `Icon + Text`: For emphasized actions
2. `Text`: Default for most actions
3. `Text + Icon`: For dropdown, next-step, or directional actions
4. `Icon Only`: For tight layouts or parallel compact actions; must show tooltip on hover

## State Handling
Common interaction states include:
- default
- hover
- active
- disabled
- loading

In the active design surface:
- treat semantic type, size, and content as the main selectable dimensions
- treat hover and active as reference states, not separate production components
- expose disabled and loading as standalone variants only when they meaningfully affect page composition

## Commonly Used Button Hierarchy in Vine
The following button patterns are the most commonly used and recommended in Vine, ordered from highest emphasis to lowest emphasis:
1. `Button_Solid / Primary`: Entire page’s strongest action. **Use sparingly. In most cases, only one per page, excluding modal overlays.**
2. `Button_Light / Primary`: Important action with strong emphasis. Can appear multiple times.
3. `Button_Borderless / Primary`: Meaningful action with lower visual weight. Keeps the UI less noisy.
4. `Button_Light / Tertiary`: Secondary action, usually cancel, back, or rollback-like actions.
5. `Button_Link / Primary`: Lightweight action for navigation, download, or jump actions.

`Danger` is not part of the normal hierarchy. Use it only for destructive or high-risk actions.
Use this hierarchy to determine visual emphasis and action priority.

Rules:
- choose the highest-emphasis button only for the most important action in the current region
- lower-emphasis button styles should support, not compete with, the primary action
- do not use all hierarchy levels at once unless the page genuinely requires them
- prefer fewer, clearer action levels over visually rich button mixtures
