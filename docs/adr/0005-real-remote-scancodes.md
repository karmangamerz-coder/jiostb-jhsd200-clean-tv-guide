# ADR 0005: Map branded buttons by physical scancode

- Status: Accepted
- Date: 2026-11-22

## Context

The Jio remote reports multiple branded app buttons as `KEYCODE_UNKNOWN`. Mapping keycode 0 would make all unknown buttons collide. Injected ADB keys do not carry the physical remote scancode.

## Decision

Capture the real remote, map `scan:<decimal>:<package>`, and verify with real button presses. Keep Voot unassigned until an installed replacement package is chosen. Re-test volume hold because accessibility key filtering may alter repeat behavior.

## Consequences

- Individual buttons can be distinguished safely.
- Scancodes may vary by remote revision and must be re-captured.
- Hardware verification remains mandatory.
