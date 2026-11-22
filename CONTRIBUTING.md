# Contributing

Contributions should make the guide safer, clearer, or more reproducible.

## Before opening a change

1. Test on hardware you own.
2. State the exact model, Android version, and firmware build without including the serial number.
3. Prefer read-only evidence: `dumpsys package`, Home resolution, enabled/disabled package lists, and redacted screenshots.
4. Keep system changes reversible. Use CleanYourTV's guarded disable/restore tools.
5. Run `python tests/validate.py`.

## Never commit

- ADB private/public keys or authorizations.
- Microsoft, Google, Jio, or other authentication tokens.
- Signing keys, certificates, forged certificate chains, or ACS credentials.
- Serial numbers, Android IDs, MAC addresses, IP addresses, SSIDs, account names, or precise location data.
- Proprietary firmware, system images, APKs, DRM material, or decompiled proprietary source.
- Instructions for bypassing subscriptions, ownership checks, DRM, or provider authorization.

## Package-list changes

For every newly disabled package:

- Record why it is optional.
- Show its activities/services from `dumpsys package`.
- Confirm it is not an input, remote, Bluetooth, keyboard, settings, update, package-installer, permission-controller, Play service, or Android core package.
- Disable it alone, wait for package state to persist, reboot once, and verify it remains disabled.
- Add the matching recovery note.

Contributions are licensed under GPL-3.0-only.
