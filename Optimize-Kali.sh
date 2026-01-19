#!/bin/bash
# Ultimate Kali Linux WSL2 Optimization Script
# This script configures the guest environment for the best experience.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}   ULTIMATE KALI WSL2 GUEST OPTIMIZATION${NC}"
echo -e "${BLUE}============================================================${NC}"

# 1. Update and Upgrade
echo -e "${GREEN}[*] Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. Enable systemd
echo -e "${GREEN}[*] Enabling systemd support...${NC}"
if [ ! -f /etc/wsl.conf ] || ! grep -q "systemd=true" /etc/wsl.conf; then
    sudo bash -c 'cat <<EOF >> /etc/wsl.conf
[boot]
systemd=true

[network]
generateHosts = false
generateResolvConf = false
EOF'
    echo -e "${RED}[!] systemd enabled. You MUST run 'wsl --shutdown' in Windows after this script finishes.${NC}"
else
    echo -e "[+] systemd already enabled."
fi

# 3. Install Win-KeX (GUI Mode)
echo -e "${GREEN}[*] Installing Win-KeX for GUI support...${NC}"
sudo apt install -y kali-win-kex

# 4. Install Hardware Support Tools
echo -e "${GREEN}[*] Installing USB and Hardware tools...${NC}"
sudo apt install -y usbutils pciutils hwdata udev

# 5. Install Essential Security Toolsets (Large)
# Note: This is a large download.
echo -e "${GREEN}[*] Installing Kali Large Toolset (this may take a while)...${NC}"
sudo apt install -y kali-linux-large

# 6. Configure WiFi Monitor Mode Support (Drivers)
echo -e "${GREEN}[*] Installing common WiFi drivers (RTL8812AU/8814AU)...${NC}"
sudo apt install -y realtek-rtl88xxau-dkms

# 7. Setup GPU Acceleration (CUDA)
echo -e "${GREEN}[*] Setting up CUDA support...${NC}"
sudo apt install -y kali-win-kex nvidia-cuda-toolkit

# 8. Fix for Sound in WSL
echo -e "${GREEN}[*] Configuring PulseAudio for sound support...${NC}"
sudo apt install -y pulseaudio
# Win-KeX handles most of this, but we ensure it's present.

# 9. Create Shortcuts/Aliases
echo -e "${GREEN}[*] Adding helpful aliases to .bashrc...${NC}"
cat <<EOF >> ~/.bashrc

# Ultimate Kali Aliases
alias kex-win='kex --win -s'
alias kex-esm='kex --esm --ip -s'
alias kex-sl='kex --sl -s'
alias update-kali='sudo apt update && sudo apt upgrade -y'
alias lsusb='lsusb'
EOF

echo -e "${BLUE}============================================================${NC}"
echo -e "${GREEN}   OPTIMIZATION COMPLETE!${NC}"
echo -e "${BLUE}============================================================${NC}"
echo -e "1. Run 'wsl --shutdown' in Windows PowerShell."
echo -e "2. Restart Kali Linux."
echo -e "3. Start GUI with: 'kex --win -s'"
echo -e "${BLUE}============================================================${NC}"
