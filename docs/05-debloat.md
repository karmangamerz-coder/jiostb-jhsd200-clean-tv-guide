# 5. Safe debloat

## Preserve the features you use

The tested configuration preserved all of these:

- JioTV+/Live TV and TV input services
- YouTube (`com.jio.yt`)
- Netflix (`com.netflix.ninja` and partner token)
- Hotstar (`in.startv.hotstar`)
- SonyLIV, ZEE5, and JioSaavn/JioBeats
- Voice assistant and microphone
- Casting/DIAL and Miracast
- Bluetooth remote and keyboard
- JioStore and package installation
- Automatic firmware/update services

If your preferences differ, inspect packages and change the list deliberately. Never disable an app merely because its name looks unfamiliar.

## Inspect each candidate

For every line in `config/debloat-jhsd200.txt`:

```powershell
& $adb -s '<tv-ip>:5555' shell dumpsys package PACKAGE_NAME
```

Look for TV input services, settings activities, Bluetooth/remote receivers, package installation, update jobs, and privileged permissions. If the purpose is unclear, do not disable it.

## Apply the guarded list

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Apply-Debloat.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

The wrapper calls CleanYourTV's `tools/disable.ps1`, which:

- Validates package names.
- Refuses core Android/TV packages.
- Records original state for recovery.
- Uses `pm disable-user --user 0`, not uninstall.
- Applies Home/input safety checks.

## Verify the batch

```powershell
& $adb -s '<tv-ip>:5555' shell pm list packages -d --user 0
```

Confirm exactly the expected six packages appear. Use CleanYourTV to capture a screenshot after the batch:

```powershell
$env:TV_HOST = '<tv-ip>:5555'
$env:TV_ADB_BINARY = 'C:\Android\platform-tools\adb.exe'
& .\.upstream\cleanyourtv\tools\venv\Scripts\python.exe -I `
  .\.upstream\cleanyourtv\tools\tv.py `
  --screenshot shots\after-debloat.png HOME
```

Inspect the screenshot locally. Never publish it without redacting Wi-Fi names, accounts, recommendations, and personal content.

## Persist and reboot once

Wait at least 15 seconds after the last package change or run `sync`, then reboot once. Android writes package state asynchronously; rebooting immediately can make a successful change appear to revert.

After reboot, reconnect and compare the disabled list with the intended list. If Home is black, restore before doing anything else.

## Restore

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Restore-Debloat.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

The recovery record preserves packages that were already disabled before this guide. Do not replace it with a blanket `pm enable` loop.
