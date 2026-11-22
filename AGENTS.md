# Agent instructions

This repository is a sanitized public guide for an owned Jio STB JHSD200. Read `README.md`, `docs/01-scope-and-safety.md`, and `docs/ARCHITECTURE.md` before changing anything.

## Hard rules

- Never add device identifiers, SSIDs, IP addresses from a real run, account data, tokens, ADB keys, certificate material, packet captures, proprietary APKs, or firmware.
- Never add ACS interception, credential relay, DRM bypass, root, or subscription bypass instructions.
- Never add `pm uninstall` for system packages.
- Do not replace CleanYourTV's safety tools with local destructive scripts.
- Keep the debloat list small and reversible.
- No prebuilt binaries or APKs.
- Every new mutating step needs an undo and a verification step.
- Remote-button claims require a real physical press; ADB-injected keys are not proof.
- Close ADB at the end and verify the port is closed.

## Validation

Run:

```powershell
python tests\validate.py
```

Parse every PowerShell file before committing. Update `CHANGELOG.md` under semantic versioning for user-visible changes. Record major decisions in `docs/adr/`.
