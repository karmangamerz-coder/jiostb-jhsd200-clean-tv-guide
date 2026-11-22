# 1. Scope and safety

## Supported baseline

This guide was tested on:

- Jio STB **JHSD200 V2** (`franklin`)
- JioOS **5.7.1**
- Android **9**, SDK **28**
- Windows 11 host
- Built-in Wi-Fi for normal use; Ethernet was useful during initial troubleshooting
- Network ADB on TCP port 5555 after the owner enabled debugging

Stop if the model, Android version, or firmware differs. A package that is optional on one build may be essential on another.

## Authorization boundary

Use this guide only on a box you own or are expressly authorized to administer. It does not authorize access to provider infrastructure or another person's network/device.

This repository deliberately excludes:

- ACS interception or credential relay automation
- Forged certificate chains
- Authentication tokens or provider credentials
- Root exploits and bootloader bypasses
- DRM, subscription, or ownership bypasses
- Firmware images, proprietary APKs, or decompiled proprietary source

Enable ADB through lawful device/vendor-supported developer settings or another authorized method. If you choose to investigate a separate device-research project, inspect its source and license yourself and keep that work outside this repository.

## Non-negotiable rules

1. Back up before the first change.
2. Disable system packages; do not uninstall them.
3. Apply one small batch at a time.
4. Keep Live TV/input, remote/Bluetooth, keyboard, settings, package installer, permission controller, Play/Jio services required by installed apps, and update services.
5. Never launch factory/test packages to see what they do.
6. Never disable Android core packages.
7. Install and verify another Home before touching any existing launcher.
8. Use real remote presses to validate hardware buttons.
9. Close ADB when finished and verify the port is closed.
10. Never publish raw backups or screenshots containing private information.

## Core packages that are always out of scope

Never disable `android`, `com.android.systemui`, `com.android.shell`, `com.android.phone`, `com.android.settings`, `com.android.tv.settings`, permission/package installers, module metadata, ext services/shared, `com.android.providers.*`, TV input middleware, or any package whose role is unclear.

CleanYourTV's guarded scripts reject many known dangerous entries. That guard is a last line of defense, not a replacement for understanding the list.

## USB and network warning

Before changing debugging, note what is connected to USB. Some Android TV devices remove power from USB while debugging is active. If the network itself uses a USB Ethernet adapter, turning debugging on or off may drop both Ethernet and ADB. The tested JHSD200 used built-in Wi-Fi and had nothing in USB.

Port 5555 is plaintext. `ro.adb.secure=1` requires an authorized key, but the transport is still exposed to the LAN. Treat ADB as a temporary maintenance channel.
