$komorebiKeyPaths = @(
    "Registry::HKEY_CURRENT_USER\Software\Classes\exefile\shell\Komorebi"     # .exe
    # "Registry::HKEY_CURRENT_USER\Software\Classes\dllfile\shell\Komorebi"   # .dll
    # "Registry::HKEY_CURRENT_USER\Software\Classes\SystemFileAssociations\.txt\shell\Komorebi"  # .txt
)

foreach ($key in $komorebiKeyPaths) {
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force
        Write-Host "Removed:" $key -ForegroundColor Green
    } else {
        Write-Host "Key not found:" $key -ForegroundColor Yellow
    }
}
