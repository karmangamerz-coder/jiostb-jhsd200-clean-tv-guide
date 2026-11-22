# ADR 0003: Build the launcher from source

- Status: Accepted
- Date: 2026-11-22

## Context

The device has roughly 1 GB of RAM, and users need a transparent, free Home replacement without paid features, telemetry, or an opaque APK supply chain.

## Decision

Build CleanYourTV's native launcher locally with JDK 17 and Android SDK 34. Ship only theme configuration and reproducible instructions. Keep effects light and do not add blur, video, or network polling.

## Consequences

- Users can audit and reproduce the build.
- Toolchain setup is required.
- No binary APK is stored in this repository.
