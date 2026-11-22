# 6. Build and install the launcher

## Why build from source

The workflow uses CleanYourTV's small native Android TV launcher, package `com.gathin.tvhome`. It is open source, has no telemetry, and is built locally. The guide does not distribute a prebuilt APK.

The tested JHSD200 is Android 9 / SDK 28. CleanYourTV's launcher requires minSdk 26, so it is compatible.

## Check sideload support first

Before spending time on a build, test whether the TV accepts an APK you built or trust. Stop if every install fails with `INSTALL_FAILED_VERIFICATION_FAILURE` or if firmware rejects HOME-capable apps by signature. Do not loop retries or bypass platform verification.

## Build requirements

- JDK 17
- Android SDK Platform 34
- Android Build Tools 34.0.0
- A trusted ADB client

Set environment variables for the current PowerShell session:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Microsoft\jdk-17'
$env:ANDROID_HOME = 'C:\Android\Sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:Path = "$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:Path"
```

Adjust paths to your installation.

## Build and test

```powershell
Push-Location .\.upstream\cleanyourtv\launcher
.\gradlew.bat --no-daemon testReleaseUnitTest lintRelease assembleRelease --console=plain
Pop-Location
```

The tested build completed all unit tests, lint, and release assembly. Record the APK SHA-256 locally:

```powershell
Get-FileHash -Algorithm SHA256 `
  .\.upstream\cleanyourtv\launcher\app\build\outputs\apk\release\app-release.apk
```

Do not commit the APK.

## Install without disabling another launcher

Use the upstream script and explicitly leave the stock/current launchers enabled on the first pass:

```powershell
$env:TV_HOST = '<tv-ip>:5555'
$env:TV_ADB_BINARY = 'C:\Android\platform-tools\adb.exe'

powershell -ExecutionPolicy Bypass -File `
  .\.upstream\cleanyourtv\launcher\build-and-install.ps1 `
  -TvHost $env:TV_HOST `
  -StockLauncher none
```

Verify Home ownership:

```powershell
& $adb -s '<tv-ip>:5555' shell cmd package resolve-activity --brief `
  -a android.intent.action.MAIN -c android.intent.category.HOME

& $adb -s '<tv-ip>:5555' shell dumpsys activity activities
```

Expected component:

```text
com.gathin.tvhome/.MainActivity
```

Do not remove another launcher until the new Home survives a reboot.

## Apply the tested theme

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Apply-Theme.ps1 `
  -TvHost '<tv-ip>' `
  -AdbPath 'C:\Android\platform-tools\adb.exe'
```

The theme provides:

- Five dock slots: JioTV+, Jio YouTube, Netflix, Hotstar, SonyLIV
- Pitch-black background with a translucent rounded dock band
- Focus scale and glass highlight
- Ambient color glow
- Clock/date/greeting and Inputs/Wi-Fi/Settings pills
- No blur, video, polling, or advanced effects
- Hidden SmartTube bridge and duplicate settings wrappers

The Jio YouTube package is `com.jio.yt`; the tested clean launch remained focused in `dev.cobalt.app.MainActivity` and loaded recommendations.

## Duplicate settings entries

The tested box exposed:

- Real Jio settings: `com.rjil.jiostbsetting` — kept visible
- Wrapper shortcut: `com.user.jiosettings` — hidden
- Android settings wrapper: `com.user.androidsettings` — hidden because Settings is already in the top bar

Hiding a tile does not disable or uninstall its package.

## Removing user-installed fallback launchers

Prefer leaving a fallback until the new Home has survived a reboot. If the owner later chooses to remove a user-installed launcher, use Android Settings > Apps and keep a recoverable copy obtained from its legitimate source. Never uninstall a system launcher/package from this guide.
