# Set the registry values for wallpaper
$RegistryPath = "HKCU\Control Panel\Desktop"
$WallpaperValue = "Wallpaper"
$WallpaperStyleValue = "WallpaperStyle"
$WallpaperFullPath = "C:\resources\wallpaper\background.jpg"
$WallpaperStyle = 10  # 2 = Stretched, 0 = Centered, 10 = Fill
$LogFilePath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\wallpaper2.log"

# Function to log custom messages
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $LogFilePath -Value $logMessage
}

# Ensure the registry path exists
try {
    if (-not (Test-Path "Registry::$RegistryPath")) {
        New-Item -Path "Registry::$RegistryPath" -Force | Out-Null
        Write-Log "Created registry path: $RegistryPath"
    } else {
        Write-Log "Registry path already exists: $RegistryPath"
    }
} catch {
    Write-Host "Failed to create the registry path: $RegistryPath. Error: $_" -ForegroundColor Red
    Write-Log "Failed to create the registry path: $RegistryPath. Error: $_"
    exit 1
}

# Set the Wallpaper registry value
try {
    Set-ItemProperty -Path "Registry::$RegistryPath" -Name $WallpaperValue -Value $WallpaperFullPath
    Write-Log "Registry updated. Wallpaper set to $WallpaperFullPath"
} catch {
    Write-Host "Failed to update the registry for Wallpaper. Error: $_" -ForegroundColor Red
    Write-Log "Failed to update the registry for Wallpaper. Error: $_"
    exit 1
}

# Set the WallpaperStyle registry value
try {
    Set-ItemProperty -Path "Registry::$RegistryPath" -Name $WallpaperStyleValue -Value $WallpaperStyle
    Write-Log "Registry updated. Wallpaper style set to $WallpaperStyle"
} catch {
    Write-Host "Failed to update the registry for WallpaperStyle. Error: $_" -ForegroundColor Red
    Write-Log "Failed to update the registry for WallpaperStyle. Error: $_"
    exit 1
}

# Refresh the desktop to apply the changes
try {
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
    Write-Host "Wallpaper and style applied successfully."
    Write-Log "Wallpaper and style applied successfully."
} catch {
    Write-Host "Failed to refresh desktop. Error: $_" -ForegroundColor Red
    Write-Log "Failed to refresh desktop. Error: $_"
    exit 1
}

# Restart explorer.exe to apply changes
try {
    Stop-Process -Name explorer -Force
    Start-Process explorer
    Write-Host "Explorer restarted successfully."
    Write-Log "Explorer restarted successfully."
} catch {
    Write-Host "Failed to restart explorer.exe. Error: $_" -ForegroundColor Red
    Write-Log "Failed to restart explorer.exe. Error: $_"
    exit 1
}
