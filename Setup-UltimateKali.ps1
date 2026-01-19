<#
.SYNOPSIS
    Ultimate Kali Linux WSL2 Setup Script for Windows 11 Pro.
    This script automates the host-side configuration for an advanced Kali experience.

.DESCRIPTION
    - Enables WSL2 and Virtual Machine Platform.
    - Configures advanced .wslconfig (Mirrored Networking, GPU, Memory).
    - Installs usbipd-win for hardware passthrough.
    - Sets up Kali Linux with systemd and Win-KeX.

.NOTES
    Run this script as Administrator in PowerShell.
#>

$ErrorActionPreference = "Stop"

function Write-Header {
    param($Text)
    Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor White -BackgroundColor DarkCyan
    Write-Host ("=" * 60) + "`n"
}

Write-Header "ULTIMATE KALI WSL2 SETUP - WINDOWS 11 PRO"

# 1. Check for Administrator Privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator!"
    exit
}

# 2. Enable WSL and Virtual Machine Platform
Write-Header "Step 1: Enabling Windows Features"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Write-Host "[+] WSL and Virtual Machine Platform enabled." -ForegroundColor Green

# 3. Configure Global WSL Settings (.wslconfig)
Write-Header "Step 2: Configuring Advanced .wslconfig"
$wslConfigPath = "$env:USERPROFILE\.wslconfig"
$wslConfigContent = @"
[wsl2]
# Advanced Networking (Mirrored Mode) - Allows Kali to see Windows interfaces
networkingMode=mirrored
dnsTunneling=true
firewall=true
autoProxy=true

# Performance Tuning
memory=8GB        # Adjust based on your RAM
processors=4      # Adjust based on your CPU
guiApplications=true

# Hardware Acceleration
nestedVirtualization=true
vmIdleTimeout=-1

[experimental]
autoMemoryReclaim=gradual
sparseVhd=true
"@

Set-Content -Path $wslConfigPath -Value $wslConfigContent
Write-Host "[+] .wslconfig created at $wslConfigPath" -ForegroundColor Green

# 4. Install usbipd-win for USB Passthrough
Write-Header "Step 3: Installing Hardware Passthrough Tools (usbipd-win)"
if (Get-Command "usbipd" -ErrorAction SilentlyContinue) {
    Write-Host "[!] usbipd-win is already installed." -ForegroundColor Yellow
} else {
    Write-Host "[*] Downloading and installing usbipd-win via winget..."
    winget install --id=dorssel.usbipd-win -e --accept-package-agreements --accept-source-agreements
    Write-Host "[+] usbipd-win installed. You may need to restart your terminal." -ForegroundColor Green
}

# 5. Install/Update Kali Linux
Write-Header "Step 4: Preparing Kali Linux Distribution"
$kaliInstalled = wsl --list --quiet | Select-String "kali-linux"
if ($kaliInstalled) {
    Write-Host "[!] Kali Linux is already installed. Updating to WSL2..." -ForegroundColor Yellow
    wsl --set-version kali-linux 2
} else {
    Write-Host "[*] Installing Kali Linux from Microsoft Store..."
    wsl --install -d kali-linux
}

# 6. Instructions for Guest-Side Setup
Write-Header "Step 5: Finalizing Setup"
Write-Host "Host-side setup is complete!" -ForegroundColor Green
Write-Host "`nNEXT STEPS:" -ForegroundColor White
Write-Host "1. Open Kali Linux (type 'kali' in terminal)."
Write-Host "2. Run the 'Optimize-Kali.sh' script inside Kali."
Write-Host "3. To attach a USB device (e.g., WiFi adapter):"
Write-Host "   - Run 'usbipd list' in Windows PowerShell."
Write-Host "   - Run 'usbipd bind --busid <BUSID>' (Admin)."
Write-Host "   - Run 'usbipd attach --wsl --busid <BUSID>'."

Write-Host "`n[!] Please restart your computer to apply all changes." -ForegroundColor Red
