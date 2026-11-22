# 2. Windows 11 setup

## Install prerequisites

Open an ordinary PowerShell window and check:

```powershell
git --version
python --version
```

If either is missing, install the official package and reopen PowerShell:

```powershell
winget install --id Git.Git -e
winget install --id Python.Python.3.12 -e
```

For launcher builds, install JDK 17:

```powershell
winget install --id Microsoft.OpenJDK.17 -e
```

Install Android SDK command-line tools from the official Android developer site. The tested launcher build used:

- Android SDK Platform 34
- Android Build Tools 34.0.0
- Platform Tools
- JDK 17

Do not download SDK archives or ADB binaries from file-sharing sites.

## Clone this guide

```powershell
git clone <your-repository-url>
cd jiostb-jhsd200-clean-tv-guide
```

## Fetch the pinned upstream safety tools

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Setup-Upstream.ps1
```

The script clones CleanYourTV into the gitignored `.upstream/cleanyourtv` folder, checks out revision:

```text
f63a1ebcdcd63aae1ec1b6f62aa4d2a6858c116b
```

and installs its Python requirements into `tools/venv`.

Pinning the revision makes the documented commands reproducible. Before using a newer revision, read its changelog and re-run the verification process.

## ADB binary

You may use either:

- Official Android SDK `platform-tools\adb.exe`, or
- An already trusted ADB binary that successfully connects to this box.

Pass its full path with `-AdbPath`. Never commit the ADB key files generated in the user profile.

## Firewall and antivirus

Do not disable Windows Defender, the firewall, or antivirus globally. For an authorized local listener, create the narrowest possible temporary rule for the exact executable and private network profile, then remove it. ADB client connections normally need no inbound firewall exception.
