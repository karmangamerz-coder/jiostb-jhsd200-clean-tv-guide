# ADR 0002: Disable system packages; never uninstall them

- Status: Accepted
- Date: 2026-11-22

## Context

JioOS package names do not always reveal whether a component is required by Live TV, remote control, settings, updates, or authentication. User-0 uninstall operations are harder to reason about and may interact poorly with firmware updates.

## Decision

Use `pm disable-user --user 0` only through the guarded upstream tool. Keep the tested list to six optional packages. Restoration replays the recorded original state.

## Consequences

- Changes are reversible without firmware flashing.
- Disabled APKs still occupy system storage.
- The guide prioritizes recoverability over maximum removal.
