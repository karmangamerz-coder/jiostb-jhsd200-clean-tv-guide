# 8. Jio remote hotkeys

## Why injected keys are not enough

Branded app buttons travel through the physical remote input path and may be reported as `KEYCODE_UNKNOWN`. `adb shell input keyevent` does not reproduce the hardware scancode, so it cannot prove a mapping works.

The tested remote identified as `JIO BLE Remote`. Its branded buttons produced distinct scancodes even though Android reported keycode 0/unknown.

## Capture your own remote

Use the Linux input stream when permitted:

```powershell
& $adb -s '<tv-ip>:5555' shell getevent -lt
```

If that output is buffered or empty, clear logs, press one real button at a time, and inspect the system log immediately:

```powershell
& $adb -s '<tv-ip>:5555' logcat -c
# Press the physical button once.
& $adb -s '<tv-ip>:5555' logcat -d | Select-String 'GlobalKeyManager|KeyEvent|scanCode'
```

The tested Jio remote produced:

| Button | Scancode | Mapping |
|---|---:|---|
| YouTube | 185 | `com.jio.yt` |
| Netflix | 187 | `com.netflix.ninja` |
| Hotstar | 184 | `in.startv.hotstar` |
| Voot | 186 | Unassigned; choose an installed replacement such as JioCinema only after confirming its package |

Scancodes can differ by remote revision. Do not copy them blindly.

## Theme mapping format

CleanYourTV uses `scan:<decimal-scancode>:<package>` entries:

```json
"app_keys": [
  "scan:185:com.jio.yt",
  "scan:187:com.netflix.ninja",
  "scan:184:in.startv.hotstar"
]
```

The tested theme includes these three mappings. Voot remains unassigned because no installed Voot/JioCinema package was confirmed during the run.

Apply the theme, then verify the accessibility input service remains enabled:

```powershell
& $adb -s '<tv-ip>:5555' shell settings get secure enabled_accessibility_services
& $adb -s '<tv-ip>:5555' shell settings get secure accessibility_enabled
```

The enabled-services list must include `com.gathin.tvhome/com.gathin.tvhome.InputKeyService`, and accessibility must be `1`.

## Real-remote verification

Press each physical button from Home and from inside another app. Confirm the intended app becomes resumed:

```powershell
& $adb -s '<tv-ip>:5555' shell dumpsys activity activities | `
  Select-String 'mResumedActivity|topResumedActivity'
```

After enabling a key-filtering service, hold Volume Up and Volume Down. Some firmware stops repeating and changes a smooth volume ramp into one step per press. If that occurs, choose between working branded buttons and volume repeat; do not conceal the tradeoff.

Force-stopping the launcher can unbind its accessibility services. Recheck bindings after reboot, app updates, and force stops.
