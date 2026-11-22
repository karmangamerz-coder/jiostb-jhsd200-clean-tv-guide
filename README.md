# Jio STB JHSD200 Clean TV Guide

A reproducible, privacy-conscious guide for turning an owned **Jio STB JHSD200 V2** running **JioOS 5.7.1 / Android 9 (SDK 28)** into a lighter Android TV setup with a clean open-source launcher.

This repository documents a real-device run performed on Windows 11. It does not contain proprietary Jio firmware, Minecraft/Aero Client code, APK binaries, account data, ADB keys, authentication tokens, device serials, Wi-Fi names, or private screenshots.

## What the tested workflow achieved

- Backed up package state, Android properties, settings, display overrides, and Home ownership before changes.
- Kept Live TV/JioTV+, YouTube, Netflix, Hotstar, SonyLIV, ZEE5, JioSaavn/JioBeats, voice input, casting, Miracast, remote/Bluetooth services, and firmware updates.
- Disabled six optional advertising, analytics, promotion, optimizer, and remote-care packages without uninstalling system software.
- Built the MIT-licensed [CleanYourTV](https://github.com/Gathin23/cleanyourtv) launcher from source and installed it as Home.
- Applied a five-app Apple TV-style dock: JioTV+, Jio YouTube, Netflix, Hotstar, SonyLIV.
- Hid duplicate shortcut wrappers for Android Settings and Jio Settings while keeping the real Jio Settings application.
- Enabled AdGuard Private DNS as an optional, reversible setting.
- Granted unknown-app installation access only to installed apps that explicitly request it.
- Identified branded remote scancodes for YouTube, Netflix, Hotstar, and Voot.
- Verified the launcher and Jio YouTube with screenshots pulled from the real TV.

## Start here

1. Read [scope and safety](docs/01-scope-and-safety.md).
2. Prepare [Windows 11 and the upstream tools](docs/02-windows-setup.md).
3. Connect through [ADB on hardware you own](docs/03-adb-connection.md).
4. [Back up everything](docs/04-backup.md).
5. Apply the [small, tested debloat list](docs/05-debloat.md).
6. Build and configure the [open-source launcher](docs/06-launcher.md).
7. Optionally configure [Private DNS and sideload access](docs/07-privacy-and-sideloading.md).
8. Map [real remote hotkeys](docs/08-remote-hotkeys.md).
9. [Verify, recover, and close ADB](docs/09-verify-recover-close.md).
10. If anything differs, stop and use [troubleshooting](docs/TROUBLESHOOTING.md).

## Tested package decisions

The exact guarded list is [`config/debloat-jhsd200.txt`](config/debloat-jhsd200.txt). It disables:

| Package | Purpose observed during the tested run |
|---|---|
| `com.jio.stbadservice` | STB advertising service |
| `com.jio.adc.embedded` | Embedded advertising/measurement component |
| `com.jio.bioscopecontentservice` | Promotional content service |
| `com.rjil.jiostblogservice` | Jio STB logging service |
| `com.jio.stbremotecare.ril` | Remote-care component |
| `com.jio.appoptimizer` | Vendor app optimizer |

It intentionally does **not** disable TV input services, the remote, Bluetooth, keyboard, voice assistant, casting, streaming apps, JioStore, settings, or update services.

## Repository layout

```text
config/                  Tested debloat list and launcher theme
docs/                    Detailed workflow and architecture decisions
scripts/                 Thin Windows wrappers around upstream safety tools
tests/validate.py        Offline validation and secret-pattern checks
.github/workflows/       Documentation/config validation only
```

## Important limits

- This is for equipment you own and are authorized to modify.
- The repository does not provide or automate ACS interception, forged certificates, credential relay, DRM bypass, root, firmware flashing, or subscription bypass.
- Obtain ADB through device/vendor-supported developer settings or another lawful method. If you independently use [krishnasen2401/jiostb](https://github.com/krishnasen2401/jiostb), inspect and follow that project's current documentation; this guide does not copy or execute its network-interception code.
- Never disable antivirus or firewall globally. Add narrow, temporary rules only when you understand the listener and remove them afterward.
- Android TV port 5555 is plaintext. Close debugging at the end and verify the port is closed.
- Package names and firmware behavior can change. Re-check every package on your own box with `dumpsys package` before disabling it.

## Licensing and attribution

Original material in this repository is GPL-3.0-only. CleanYourTV remains MIT-licensed and is fetched from upstream rather than vendored. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

## Contributing

Corrections for other JHSD200 firmware versions are welcome. Never submit serial numbers, MAC addresses, IP addresses, SSIDs, account names, ADB keys, tokens, signing material, copyrighted APKs, or unredacted screenshots. See [CONTRIBUTING.md](CONTRIBUTING.md).
