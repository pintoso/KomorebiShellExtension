$fileKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\komorebiignore"
Remove-Item -Path $fileKeyPath -Recurse -Confirm

$fileKeyPath = "Registry::HKEY_CURRENT_USER\Software\Classes\*\shell\komorebimanage"
Remove-Item -Path $fileKeyPath -Recurse -Confirm
