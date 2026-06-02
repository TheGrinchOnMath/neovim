#Requires -Version 5.1
<#
.SYNOPSIS
  Non-interactive, scoop-first provisioner for gronk.nvim on a fresh Windows
  (incl. Win11 IoT LTSC). No DWM/GUI prompts; run from a NORMAL PowerShell.

.DESCRIPTION
  1. Refuses to run elevated (scoop is a per-user tool).
  2. Sets CurrentUser execution policy to RemoteSigned.
  3. Installs scoop (if missing) + git, then `scoop import scoopfile.json`.
  4. Configures the rustup default toolchain (idiomatic rust setup).
  5. Clones this repo into the chosen config dir.
  6. Runs the headless provision step (plugins + parsers + Mason tools).
  7. For -Target claude, also writes the `nvc` launcher to your $PROFILE.

  Idempotent: safe to re-run.

.PARAMETER Target
  default : config at %LOCALAPPDATA%\nvim       -> launch with `nvim`
  claude  : config at %USERPROFILE%\.config\nvim-claude -> launch with `nvc`

.EXAMPLE
  .\manifests\install.ps1
.EXAMPLE
  .\manifests\install.ps1 -Target claude
#>
[CmdletBinding()]
param(
  [ValidateSet('default', 'claude')]
  [string]$Target = 'default',
  [string]$Repo   = 'https://github.com/TheGrinchOnMath/neovim',
  [string]$Branch = 'claude-dev'
)

$ErrorActionPreference = 'Stop'
function Info($m) { Write-Host "[install] $m" -ForegroundColor Cyan }

# 1. Refuse elevation -----------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if ($isAdmin) {
  throw 'Run this in a NORMAL (non-elevated) PowerShell. Scoop installs per-user and refuses admin.'
}

# 2. Execution policy -----------------------------------------------------------
if ((Get-ExecutionPolicy -Scope CurrentUser) -notin 'RemoteSigned', 'Unrestricted', 'Bypass') {
  Info 'setting CurrentUser execution policy to RemoteSigned'
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}

# 3. Scoop + git + manifest -----------------------------------------------------
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
  Info 'installing scoop'
  Invoke-RestMethod -Uri 'https://get.scoop.sh' | Invoke-Expression
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Info 'installing git'
  scoop install git
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Info "importing $here\scoopfile.json"
scoop import (Join-Path $here 'scoopfile.json')

# Refresh PATH so newly-installed shims resolve in this session.
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'User') + ';' +
            [Environment]::GetEnvironmentVariable('Path', 'Machine')

# 4. rustup default toolchain ---------------------------------------------------
# Idiomatic rust setup. rustup defaults to the MSVC host; if you have no MSVC
# linker, switch to the GNU toolchain that uses the mingw gcc installed above:
#   rustup default stable-x86_64-pc-windows-gnu
if (Get-Command rustup -ErrorAction SilentlyContinue) {
  Info 'setting rustup default toolchain (stable)'
  try { rustup default stable } catch { Write-Warning "rustup default failed: $_" }
}

# 5. Resolve config dir per target ----------------------------------------------
switch ($Target) {
  'default' {
    $cfg = Join-Path $env:LOCALAPPDATA 'nvim'
  }
  'claude' {
    $cfg = Join-Path $env:USERPROFILE '.config\nvim-claude'
    $env:NVIM_APPNAME    = 'nvim-claude'
    $env:XDG_CONFIG_HOME = Join-Path $env:USERPROFILE '.config'
  }
}

# 6. Clone / update config (idempotent) -----------------------------------------
if (Test-Path (Join-Path $cfg 'init.lua')) {
  Info "config present at $cfg — pulling latest"
  git -C $cfg pull --ff-only
} else {
  Info "cloning $Repo ($Branch) -> $cfg"
  git clone -b $Branch $Repo $cfg
}

# 7. Headless provision (plugins + parsers + Mason) ------------------------------
Info 'running headless provision (plugins, parsers, Mason tools) ...'
nvim --headless -c "luafile $(Join-Path $here 'provision.lua')" -c 'qa!'

# 8. claude target: install the nvc launcher ------------------------------------
if ($Target -eq 'claude') {
  if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }
  if (-not (Select-String -Path $PROFILE -Pattern 'function nvc' -Quiet)) {
    Info "adding nvc launcher to $PROFILE"
    @'

function nvc {
    $env:NVIM_APPNAME    = 'nvim-claude'
    $env:XDG_CONFIG_HOME = "$env:USERPROFILE\.config"
    & nvim @args
}
'@ | Add-Content -Path $PROFILE -Encoding utf8
  }
}

$launch = if ($Target -eq 'claude') { 'nvc' } else { 'nvim' }
Write-Host ''
Info "done. Open a new terminal and launch with:  $launch"
