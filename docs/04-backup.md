# 4. Back up before changing anything

Run the provided read-only wrapper:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Backup-Jhsd200.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

It saves these files under the gitignored `backup/` directory:

- Full installed-package list, including paths, installers, and UIDs
- Disabled-package list for user 0
- `getprop`
- Global, secure, and system settings
- Current Home owner and all Home claimants
- Display size, density, and forced-density state

CleanYourTV's disable tool also records original package/Home state under the current user's `.cleanyourtv` directory. Keep both records until the device has passed a reboot and recovery test.

## Additional checks

Before changing packages, record:

```powershell
& $adb -s '<tv-ip>:5555' shell cmd package query-activities --brief `
  -a android.intent.action.MAIN -c android.intent.category.HOME

& $adb -s '<tv-ip>:5555' shell wm size
& $adb -s '<tv-ip>:5555' shell wm density
& $adb -s '<tv-ip>:5555' shell settings get secure display_density_forced
```

Do not interpret an empty `display_density_forced` as damage; it normally means the default density is active.

## Protect the backup

The backup may contain serial numbers, network names, MAC addresses, account identifiers, installed-app history, and tokens. It is excluded by `.gitignore`. Do not upload it to GitHub, paste it into issues, or send it to strangers.

When sharing evidence, quote only the model, Android version, firmware build, and the minimal redacted lines needed to reproduce a problem.
