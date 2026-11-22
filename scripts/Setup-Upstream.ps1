[CmdletBinding()]
param(
    [string]$Destination = (Join-Path (Split-Path -Parent $PSScriptRoot) '.upstream\cleanyourtv'),
    [string]$Revision = 'f63a1ebcdcd63aae1ec1b6f62aa4d2a6858c116b'
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'Git is required. Install Git for Windows, reopen PowerShell, and try again.'
}
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    throw 'Python 3 is required. Install it from python.org or winget and reopen PowerShell.'
}

$parent = Split-Path -Parent $Destination
New-Item -ItemType Directory -Force -Path $parent | Out-Null

if (-not (Test-Path -LiteralPath (Join-Path $Destination '.git'))) {
    git clone https://github.com/Gathin23/cleanyourtv.git $Destination
    if ($LASTEXITCODE -ne 0) { throw 'CleanYourTV clone failed.' }
}

git -C $Destination fetch origin $Revision
if ($LASTEXITCODE -ne 0) { throw "Could not fetch pinned CleanYourTV revision $Revision." }
git -C $Destination checkout --detach $Revision
if ($LASTEXITCODE -ne 0) { throw "Could not check out pinned CleanYourTV revision $Revision." }

$venv = Join-Path $Destination 'tools\venv'
python -m venv $venv
if ($LASTEXITCODE -ne 0) { throw 'Could not create the Python virtual environment.' }

$python = Join-Path $venv 'Scripts\python.exe'
& $python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) { throw 'pip upgrade failed.' }
& $python -m pip install -r (Join-Path $Destination 'tools\requirements.txt')
if ($LASTEXITCODE -ne 0) { throw 'CleanYourTV Python dependency installation failed.' }

Write-Host "CleanYourTV is ready at $Destination"
Write-Host "Pinned revision: $Revision"
