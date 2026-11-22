# 3. ADB connection

## Enable debugging lawfully

Enable developer/ADB debugging using the device's supported settings or another method you are authorized to use. This guide begins after port 5555 is available and intentionally does not reproduce ACS interception procedures.

The authorization prompt may appear on the TV the first time a new host key connects. Read the fingerprint, select **Always allow from this computer** only on your own trusted PC, and accept it on the TV.

## Find the TV address

Prefer the router's client list or the TV's Network settings. Do not scan networks you do not own. Examples use the documentation address `<tv-ip>`.

## Connect

```powershell
$adb = 'C:\Android\platform-tools\adb.exe'
& $adb connect '<tv-ip>:5555'
& $adb devices -l
```

Expected state:

```text
<tv-ip>:5555    device product:franklin model:JHSD200 device:franklin
```

Do not proceed with `unauthorized`, `offline`, or an unexpected model.

## Record the baseline

```powershell
& $adb -s '<tv-ip>:5555' shell getprop ro.product.model
& $adb -s '<tv-ip>:5555' shell getprop ro.build.version.release
& $adb -s '<tv-ip>:5555' shell getprop ro.build.version.sdk
& $adb -s '<tv-ip>:5555' shell getprop ro.build.display.id
& $adb -s '<tv-ip>:5555' shell getprop ro.adb.secure
```

The tested unit reported JHSD200, Android 9, SDK 28, build `STB-JHSD200-5.7.1`, and `ro.adb.secure=1`.

## Check USB/network topology

```powershell
& $adb -s '<tv-ip>:5555' shell dumpsys usb
& $adb -s '<tv-ip>:5555' shell dumpsys connectivity
```

Confirm the device is actually using the network path you expect. Built-in Wi-Fi normally appears as `wlan0` / `WIFI`.

## Common states

- **unauthorized:** accept the TV prompt; do not delete keys blindly.
- **offline:** restart only the host ADB server, then reconnect. If it persists, reboot the TV once.
- **connection refused:** debugging is not listening.
- **timeout/unreachable:** the TV is off Wi-Fi, asleep, or using a different address.
- **works in a normal terminal but not an agent sandbox:** use CleanYourTV's documented relay only on your own computer/network.

Keep the same trusted ADB binary/key throughout a session. Restarting with a different ADB installation can create a new key and require authorization again.
