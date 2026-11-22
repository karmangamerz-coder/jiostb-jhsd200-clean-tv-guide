# Troubleshooting

## Windows mobile hotspot immediately turns off

Confirm WLAN AutoConfig and Internet Connection Sharing are running:

```powershell
Get-Service WlanSvc, SharedAccess
```

Update the Wi-Fi driver from the laptop manufacturer. A driver reporting `Hosted network supported: No` can still support Windows Mobile Hotspot through Wi-Fi Direct, but unstable vendor drivers may create and immediately remove the virtual adapter. Ethernet is the simpler maintenance path when available.

Do not disable antivirus to fix Mobile Hotspot.

## ADB is unauthorized

- Keep the TV awake and visible.
- Accept the fingerprint prompt.
- Use the same ADB installation/key as the successful connection.
- Run `adb kill-server`, `adb start-server`, and reconnect once.
- Reboot the box once if it remains stale.

Do not repeatedly delete host/device keys; that creates more authorization prompts and can leave the transport offline.

## ADB is offline

Restart the host ADB server and reconnect. If `adb devices -l` still reports `offline`, reboot the box once. Confirm the IP has not changed.

## Device becomes unreachable

Check the TV screen and router client list. `DestinationHostUnreachable` plus an incomplete ARP entry means the box is no longer on that LAN address. Wake it, reconnect Wi-Fi, or find its new DHCP address before retrying. Do not scan networks you do not own.

## Theme application says device not found

The ADB daemon may have restarted and forgotten the TCP transport:

```powershell
& $adb connect '<tv-ip>:5555'
& $adb devices -l
```

Retry only after the state is `device`.

## Screenshot is empty or stale

Netflix, Live TV, HDMI, and some protected video surfaces return empty screenshots. Verify the resumed activity instead. If screenshots repeat an old frame byte-for-byte, check `mCurrentFocus`, leave/force-stop the stale app, and capture again.

## Launcher looks enlarged or clipped

Read all three values before changing anything:

```powershell
& $adb -s '<tv-ip>:5555' shell wm size
& $adb -s '<tv-ip>:5555' shell wm density
& $adb -s '<tv-ip>:5555' shell settings get secure display_density_forced
```

Restore an accidental override rather than changing launcher layout to compensate.

## Jio YouTube appears to redirect

Make sure nobody is pressing another remote button during the test. Force-stop stores and YouTube, launch only `com.jio.yt/dev.cobalt.app.MainActivity`, wait without sending input, then inspect focus. During the tested clean run, Jio YouTube remained resumed and loaded recommendations.

## `getevent` shows nothing for branded buttons

Some ADB/PTY combinations buffer the stream. Clear logcat, press one real button, then immediately inspect `GlobalKeyManager`/`KeyEvent` lines. The Jio remote reported `KEYCODE_UNKNOWN` with distinct `scanCode` values.

## Hotkeys work but held volume no longer repeats

That can be a firmware/accessibility filtering tradeoff. Confirm the effect with the real remote before and after binding the input service. If volume repeat matters more, remove the app-key mappings or disable the helper and document the compromise.

## Private DNS breaks an app

Temporarily return to opportunistic mode. If the app works again, keep router-side DNS filtering instead of strict Private DNS.

## Restore appears incomplete

Run the same CleanYourTV restore command again after the TV is fully online. Compare `pm list packages -d --user 0` with the recovery record. Never “fix” it by blindly enabling every disabled package.
