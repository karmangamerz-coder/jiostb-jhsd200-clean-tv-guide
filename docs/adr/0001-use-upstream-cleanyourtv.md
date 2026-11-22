# ADR 0001: Use pinned upstream CleanYourTV tools

- Status: Accepted
- Date: 2026-11-22

## Context

Package disabling and Home replacement can make an Android TV difficult to recover. CleanYourTV already has protected-package checks, Home/input guards, recovery records, screenshot tooling, and a source-buildable launcher.

## Decision

Clone CleanYourTV from its official repository, pin the tested revision, and keep this repository's scripts as thin wrappers. Do not copy or reimplement its destructive safety logic.

## Consequences

- Safety fixes remain attributable to the upstream project.
- Users can audit the exact revision.
- The guide stays small.
- Updating the pin requires a new real-device verification pass.
