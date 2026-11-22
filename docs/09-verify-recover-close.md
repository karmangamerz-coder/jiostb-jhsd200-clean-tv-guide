# 9. Verify, recover, and close ADB

## Automated read-only verification

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Verify-Jhsd200.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

Review every section. Expected highlights:

- Model JHSD200, Android 9, SDK 28
- Default Home `com.gathin.tvhome/.MainActivity`
- Only the six intended optional packages disabled
- Native 1920x1080 size and expected density, without accidental overrides
- Private DNS state matching the owner's choice

## D-pad and UI checklist

Use the real remote and screenshots:

1. Home opens the new launcher.
2. Five dock tiles appear in the intended order.
3. Left/right stops at the dock edges.
4. Up from the dock reaches Inputs, Wi-Fi, and Settings.
5. Top-bar focus does not fall through into tiles.
6. Down reaches the app grid and scrolls exactly one row.
7. Inputs opens the compact Live TV list without switching automatically.
8. Settings opens from the top pill.
9. JioTV+, YouTube, Netflix, Hotstar, and SonyLIV launch.
10. Voice/microphone, casting, Miracast, and volume repeat still work.
11. Physical branded buttons are tested after mapping.

For apps that block screenshots, verify `mResumedActivity` instead.

## Reboot persistence

Wait 15 seconds or run `sync`, reboot once, reconnect, and repeat the checks. Confirm Home and package state survived. Do not combine stock-launcher changes, key-service changes, and a first reboot into one risky step.

## Recovery

Restore the guarded debloat list:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Restore-Debloat.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

Undo Private DNS with the commands in `07-privacy-and-sideloading.md`. Reset installer app-ops to `default` if desired. If Home is broken, set a known installed launcher as Home using the component recorded in `backup/home-before.txt`.

## Close debugging

Network ADB on port 5555 is plaintext. When the owner accepts the result:

1. Note any Wireless Debugging TLS port from `adb mdns services`.
2. Turn off Wireless Debugging and Network/ADB debugging in the TV UI.
3. Turn off USB debugging unless the owner explicitly needs it.
4. Revoke USB debugging authorizations.
5. Verify the TLS port is closed before reboot using upstream `tools/adb-closed.py`.
6. Reboot.
7. Verify port 5555 is closed:

```powershell
& .\.upstream\cleanyourtv\tools\venv\Scripts\python.exe -I `
  .\.upstream\cleanyourtv\tools\adb-closed.py '<tv-ip>'
```

Only the tool reporting the port closed counts. A dropped ADB session, a toggle that looks off, or a generic ping failure is not proof.

If the device used USB Ethernet, turn debugging off, reconnect the adapter, and confirm Ethernet—not Wi-Fi—is active again.
