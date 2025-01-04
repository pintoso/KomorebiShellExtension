$wrkDir = $env:WRK_DIR
$komorebiRulePath = @()

# Find the path to KomorebiRuleManager.py

if (-not $wrkDir)
{
    $wrkDir = Get-Location
    $komorebiRulePath = Join-Path -Path $wrkDir -ChildPath "KomorebiRuleManager.py"
} else
{
    $komorebiRulePath = Join-Path -Path $wrkDir -ChildPath "Python"
    $komorebiRulePath = Join-Path -Path $komorebiRulePath -ChildPath "KomorebiRuleManager.py"
}

# Find the path to Pythonw.exe

$pythonPath = ""
try
{
    $pythonPath = Get-Command "pythonw.exe" -ErrorAction Stop
    $pythonPath = $pythonPath.Source
} catch
{
    Write-Host "Python not found. Please install Python and try again."
    exit
}

# Add ignore rule keys

$fileKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\komorebiignore"
$fileCommandKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\Komorebiignore\command"

New-Item -Path $fileKeyPath -Force | Out-Null
Set-ItemProperty -Path $fileKeyPath -Name "(Default)" -Value "Don't manage this file with Komorebi"
Set-ItemProperty -Path $fileKeyPath -Name "Icon" -Value "imageres.dll,251"

New-Item -Path $fileCommandKeyPath -Force | Out-Null
Set-ItemProperty -Path $fileCommandKeyPath -Name "(Default)" -Value "$pythonPath $komorebiRulePath `"%1`" exe -i"

# Add manage rule keys

$fileKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\komorebimanage"
$fileCommandKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\Komorebimanage\command"

New-Item -Path $fileKeyPath -Force | Out-Null
Set-ItemProperty -Path $fileKeyPath -Name "(Default)" -Value "Manage this file with Komorebi"
Set-ItemProperty -Path $fileKeyPath -Name "Icon" -Value "imageres.dll,251"

New-Item -Path $fileCommandKeyPath -Force | Out-Null
Set-ItemProperty -Path $fileCommandKeyPath -Name "(Default)" -Value "$pythonPath $komorebiRulePath `"%1`" exe -m"
