# Recipe: Overlay And Feedback

## Load When
- The surface includes confirmation, errors, warnings, oncall notices, help popovers, status changes, or temporary feedback.

## Public Components
- `Modal`: focused blocking decisions or short forms.
- `Popconfirm`: compact confirmation near a trigger.
- `Popover`: contextual details or hover/click details.
- `Toast`: temporary non-blocking feedback.
- `Banner`: persistent inline/system feedback.
- `Status Text`: inline status.

## Hard Rules
- Do not hide required warnings only in tooltip/popover.
- Use Modal for production, launch, cost, permission, or irreversible decisions.
- Use Banner for persistent page-level warnings or resource/permission gates.
- Use Popover for threshold details, class details, or contextual metadata.
- Modal title/action/body must be nested and Auto Layout-backed.
- Long modal/banner copy should use Auto height.

## Evidence
Record overlay/feedback component names, trigger context, and required warning visibility.
