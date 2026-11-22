# Architecture

This repository is an orchestration and documentation layer, not a fork of Android, JioOS, or CleanYourTV.

## Components

```text
Windows 11 host
├── trusted ADB client
├── this guide
│   ├── tested configuration
│   ├── read-only backup/verification wrappers
│   └── thin wrappers around upstream safety tools
└── pinned CleanYourTV checkout (.upstream/, gitignored)
    ├── guarded disable/restore scripts
    ├── ADB/screenshot tools
    └── launcher source and Gradle build
         │
         └── authorized ADB over the owner's LAN
              └── JHSD200 Android 9 device
```

## Trust boundaries

- **Device boundary:** ADB has powerful shell access. It is temporary and must be closed after maintenance.
- **Host boundary:** ADB keys, backups, and screenshots stay outside version control.
- **Upstream boundary:** CleanYourTV is fetched from its official Git repository and pinned to a tested commit.
- **Provider boundary:** Jio services and infrastructure are not part of this repository. No provider credentials or ACS traffic belong here.
- **Binary boundary:** Proprietary APKs, firmware, and build artifacts are never committed.

## State model

1. `baseline`: package/Home/settings state captured.
2. `debloated`: six optional packages disabled for user 0, with recovery record.
3. `launcher-installed`: source-built launcher installed and selected as Home; old launcher still available during first validation.
4. `themed`: package-based dock, hidden wrapper tiles, and optional remote mappings applied.
5. `privacy-configured`: optional Private DNS and narrowly scoped installer app-ops.
6. `verified`: real remote, screenshots, resumed activities, reboot persistence, and package states checked.
7. `sealed`: debugging disabled, authorizations revoked, and ports verified closed.

Every mutating transition has a documented reverse path. A failed verification returns to the previous safe state instead of adding more changes.

## Reproducibility

- CleanYourTV revision is pinned.
- Launcher build toolchain versions are documented.
- No prebuilt launcher APK is shipped.
- The theme and debloat list are deterministic text files.
- CI validates JSON, package-list invariants, PowerShell syntax, and absence of common sensitive artifacts.
- Hardware/firmware behavior still requires real-device verification; an emulator cannot validate remote keys, HDMI, Live TV, or vendor services.

## Privacy

The launcher configuration has no account data and uses package names only. Backups and screenshots are operational artifacts, gitignored by default. Public documentation uses placeholders instead of real IPs, SSIDs, serials, or MAC addresses.
