# wsl.exe ==export ubuntu C://clean-base.tar

$DistroName = "Ubuntu"
$InstallPath = "C:\WSL\Ubuntu"
$TarPath = "C:\clean-base.tar"

wsl --terminate $DistroName 2>$null
wsl --unregister $DistroName 2>$null

if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
}

Write-Host "Importing $DistroName from $TarPath..."
wsl --import $DistroName $InstallPath $TarPath --version 2
Write-Host "Done! You can now run 'wsl -d $DistroName'"
