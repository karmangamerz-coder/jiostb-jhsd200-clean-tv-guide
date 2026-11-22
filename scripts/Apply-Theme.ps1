[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$TvHost,
    [string]$AdbPath,
    [string]$UpstreamPath = (Join-Path (Split-Path -Parent $PSScriptRoot) '.upstream\cleanyourtv')
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$theme = Join-Path $root 'config\apple-tv-jhsd200'
$themeScript = Join-Path $UpstreamPath 'tools\theme.ps1'
$target = if ($TvHost -match ':\d+$') { $TvHost } else { "${TvHost}:5555" }

if (-not (Test-Path -LiteralPath $themeScript)) { throw 'Run scripts\Setup-Upstream.ps1 first.' }
if ($AdbPath) { $env:TV_ADB_BINARY = (Resolve-Path -LiteralPath $AdbPath).Path }
$env:TV_HOST = $target

& powershell -NoProfile -ExecutionPolicy Bypass -File $themeScript -TvHost $target $theme
exit $LASTEXITCODE
