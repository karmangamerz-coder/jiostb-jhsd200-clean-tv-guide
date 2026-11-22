[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$TvHost,
    [string]$AdbPath,
    [string]$UpstreamPath = (Join-Path (Split-Path -Parent $PSScriptRoot) '.upstream\cleanyourtv'),
    [string]$OutputPath = (Join-Path (Split-Path -Parent $PSScriptRoot) 'backup')
)

$ErrorActionPreference = 'Stop'
$target = if ($TvHost -match ':\d+$') { $TvHost } else { "${TvHost}:5555" }
$python = Join-Path $UpstreamPath 'tools\venv\Scripts\python.exe'
$tvPy = Join-Path $UpstreamPath 'tools\tv.py'

if (-not (Test-Path -LiteralPath $python)) { throw 'Run scripts\Setup-Upstream.ps1 first.' }
if ($AdbPath) {
    if (-not (Test-Path -LiteralPath $AdbPath)) { throw "ADB not found: $AdbPath" }
    $env:TV_ADB_BINARY = (Resolve-Path -LiteralPath $AdbPath).Path
}
$env:TV_HOST = $target

New-Item -ItemType Directory -Force -Path $OutputPath | Out-Null

function Save-TvOutput {
    param([string]$Name, [Parameter(ValueFromRemainingArguments = $true)][string[]]$Command)
    $result = & $python -I $tvPy @Command
    if ($LASTEXITCODE -ne 0) { throw "Backup command failed for $Name" }
    $result | Set-Content -LiteralPath (Join-Path $OutputPath $Name) -Encoding utf8
}

Save-TvOutput 'packages-all.txt' 'pm list packages -f -i -U'
Save-TvOutput 'packages-disabled.txt' 'pm list packages -d --user 0'
Save-TvOutput 'getprop.txt' 'getprop'
Save-TvOutput 'settings-global.txt' 'settings list global'
Save-TvOutput 'settings-secure.txt' 'settings list secure'
Save-TvOutput 'settings-system.txt' 'settings list system'
Save-TvOutput 'home-before.txt' 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME'
Save-TvOutput 'home-claimants-before.txt' 'cmd package query-activities --brief -a android.intent.action.MAIN -c android.intent.category.HOME'
Save-TvOutput 'wm-size.txt' 'wm size'
Save-TvOutput 'wm-density.txt' 'wm density'
Save-TvOutput 'display-density-forced.txt' 'settings --user 0 get secure display_density_forced'

Write-Host "Sensitive backup written to $OutputPath"
Write-Warning 'The backup is gitignored. Do not publish it without careful redaction.'
