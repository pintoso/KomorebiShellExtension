# Working directory
$wrkDir = $env:WRK_DIR
if (-not $wrkDir) { $wrkDir = (Get-Location).Path }

# Path to Python script
$komorebiRulePath = Join-Path $wrkDir "KomorebiRuleManager.py"
if (-not (Test-Path $komorebiRulePath)) {
    $komorebiRulePath = Join-Path $wrkDir "Python\KomorebiRuleManager.py"
}

# Location of pythonw.exe
try {
    $pythonPath = (Get-Command "pythonw.exe" -ErrorAction Stop).Source
} catch {
    Write-Host "Python not found. Please install Python and try again." -ForegroundColor Red
    exit
}

# Icons - Using the script's directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$iconKomorebi    = Join-Path $scriptDir "komorebi.ico"
$iconKomorebiOff = Join-Path $scriptDir "komorebi_off.ico"

#------------------ CREATION ------------------------------------
$baseKey = "Registry::HKEY_CURRENT_USER\Software\Classes\exefile\shell\Komorebi"

# 1. Parent key (transformed into submenu)
New-Item -Path $baseKey -Force | Out-Null
Set-ItemProperty -Path $baseKey -Name "MUIVerb"     -Value "Komorebi"
Set-ItemProperty -Path $baseKey -Name "Icon"        -Value $iconKomorebi
Set-ItemProperty -Path $baseKey -Name "SubCommands" -Value ""   # ← Makes it a submenu

# 2. Shell folder (where child commands live)
$subShell = Join-Path $baseKey "shell"
New-Item -Path $subShell -Force | Out-Null

# ---------- IGNORE ----------
$ignoreKey        = Join-Path $subShell "Ignore"
$ignoreCommandKey = Join-Path $ignoreKey "command"

New-Item -Path $ignoreKey        -Force | Out-Null
New-Item -Path $ignoreCommandKey -Force | Out-Null

Set-ItemProperty -Path $ignoreKey -Name "MUIVerb" -Value "Ignore"
Set-ItemProperty -Path $ignoreKey -Name "Icon"    -Value $iconKomorebiOff
$ignoreCmd = "`"$pythonPath`" `"$komorebiRulePath`" `"%1`" exe -i"
Set-ItemProperty -Path $ignoreCommandKey -Name "(Default)" -Value $ignoreCmd

# ---------- MANAGE ----------
$manageKey        = Join-Path $subShell "Manage"
$manageCommandKey = Join-Path $manageKey "command"

New-Item -Path $manageKey        -Force | Out-Null
New-Item -Path $manageCommandKey -Force | Out-Null

Set-ItemProperty -Path $manageKey -Name "MUIVerb" -Value "Manage"
Set-ItemProperty -Path $manageKey -Name "Icon"    -Value $iconKomorebi
$manageCmd = "`"$pythonPath`" `"$komorebiRulePath`" `"%1`" exe -m"
Set-ItemProperty -Path $manageCommandKey -Name "(Default)" -Value $manageCmd

Write-Host "`n✅ Komorebi submenu created successfully!" -ForegroundColor Green
