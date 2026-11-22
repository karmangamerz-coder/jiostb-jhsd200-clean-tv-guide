# 7. Privacy and sideloading

## Optional Private DNS

Android 9 supports strict Private DNS. Before enabling it, ask whether the router already uses Pi-hole, AdGuard Home, a VPN/domain filter, or fake-IP proxy rules. Private DNS bypasses the router's normal DNS path; use router-side filtering instead when those rules matter.

Enable AdGuard DNS:

```powershell
& $adb -s '<tv-ip>:5555' shell settings put global private_dns_specifier dns.adguard-dns.com
& $adb -s '<tv-ip>:5555' shell settings put global private_dns_mode hostname
```

Verify:

```powershell
& $adb -s '<tv-ip>:5555' shell settings get global private_dns_mode
& $adb -s '<tv-ip>:5555' shell settings get global private_dns_specifier
& $adb -s '<tv-ip>:5555' shell ping -c 1 -W 5 dns.adguard-dns.com
```

Expected settings are `hostname` and `dns.adguard-dns.com`.

Private DNS does **not** block YouTube video ads. Test Live TV and at least one streaming app afterward.

Undo:

```powershell
& $adb -s '<tv-ip>:5555' shell settings put global private_dns_mode opportunistic
& $adb -s '<tv-ip>:5555' shell settings delete global private_dns_specifier
```

## Unknown-app installation access

Do not grant install access indiscriminately to Android core packages. Grant it only to apps that declare `android.permission.REQUEST_INSTALL_PACKAGES` and that the owner intentionally uses to install packages.

On the tested box, these installed apps declared the permission:

| Package | Role |
|---|---|
| `com.hamondev.shevery` | Shevery utility |
| `com.phlox.tvwebbrowser` | TV Bro/browser |
| `cm.aptoidetv.pt` | Aptoide TV |
| `com.jio.web` | Jio web browser |
| `com.jio.store` | JioStore |
| `com.atroc.tvhome` | ATV Launcher |
| `io.github.wingedpanther.openshelf` | OpenShelf |

First inspect each package on your firmware:

```powershell
& $adb -s '<tv-ip>:5555' shell dumpsys package PACKAGE_NAME
```

Then, one package per shell call:

```powershell
& $adb -s '<tv-ip>:5555' shell cmd appops set PACKAGE_NAME REQUEST_INSTALL_PACKAGES allow
```

Persist and verify:

```powershell
& $adb -s '<tv-ip>:5555' shell cmd appops write-settings
& $adb -s '<tv-ip>:5555' shell cmd appops get PACKAGE_NAME REQUEST_INSTALL_PACKAGES
```

Expected result: `REQUEST_INSTALL_PACKAGES: allow`.

Undo a package:

```powershell
& $adb -s '<tv-ip>:5555' shell cmd appops set PACKAGE_NAME REQUEST_INSTALL_PACKAGES default
```

Unknown-source access does not make an APK trustworthy. Prefer official stores, upstream GitHub releases with signatures/hashes, and locally reproducible builds. Do not install APKs from random mirrors.
