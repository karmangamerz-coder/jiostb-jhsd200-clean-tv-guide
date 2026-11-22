[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$TvHost,
    [string]$AdbPath,
    [string]$UpstreamPath = (Join-Path (Split-Path -Parent $PSScriptRoot) '.upstream\cleanyourtv')
)

$ErrorActionPreference = 'Stop'
$target = if ($TvHost -match ':\d+$') { $TvHost } else { "${TvHost}:5555" }
$python = Join-Path $UpstreamPath 'tools\venv\Scripts\python.exe'
$tvPy = Join-Path $UpstreamPath 'tools\tv.py'

if (-not (Test-Path -LiteralPath $python)) { throw 'Run scripts\Setup-Upstream.ps1 first.' }
if ($AdbPath) { $env:TV_ADB_BINARY = (Resolve-Path -LiteralPath $AdbPath).Path }
$env:TV_HOST = $target

function Read-Tv([string]$Label, [string]$Command) {
    Write-Host "`n=== $Label ==="
    & $python -I $tvPy $Command
    if ($LASTEXITCODE -ne 0) { throw "Verification failed: $Label" }
}

Read-Tv 'Model and build' 'getprop ro.product.model; getprop ro.build.version.release; getprop ro.build.version.sdk; getprop ro.build.display.id'
Read-Tv 'Default Home' 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME'
Read-Tv 'Focused activity' 'dumpsys activity activities | grep -E "mResumedActivity|topResumedActivity|mFocusedApp"'
Read-Tv 'Disabled packages' 'pm list packages -d --user 0'
Read-Tv 'Private DNS' 'settings get global private_dns_mode; settings get global private_dns_specifier'
Read-Tv 'Display size' 'wm size'
Read-Tv 'Display density' 'wm density'
