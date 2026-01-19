# 🐉 Ultimate Kali Linux WSL2 Experience

This package provides a professional-grade setup for running Kali Linux on Windows 11 Pro via WSL2. It is designed to bypass common limitations, enabling **GUI support**, **Hardware Passthrough (USB/WiFi)**, **GPU Acceleration**, and **Mirrored Networking**.

## 🌟 Key Features
- **Win-KeX Integration**: Seamless, Windowed, and Enhanced Session GUI modes with sound.
- **Mirrored Networking**: Kali sees the host's network interfaces directly (requires Windows 11 22H2+).
- **USB Passthrough**: Connect external WiFi adapters for monitor mode and packet injection.
- **GPU Acceleration**: Full CUDA support for password cracking (Hashcat) and AI tools.
- **Systemd Support**: Run services like Docker, databases, and more natively.

---

## 🛠️ Installation Instructions

### Phase 1: Windows Host Setup
1. Open **PowerShell** as **Administrator**.
2. Navigate to the folder containing `Setup-UltimateKali.ps1`.
3. Run the script:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\Setup-UltimateKali.ps1
   ```
4. **Restart your computer** when prompted.

### Phase 2: Kali Guest Optimization
1. Open your Kali Linux terminal (type `kali` in Windows search).
2. Copy `Optimize-Kali.sh` into your Kali home directory.
3. Make it executable and run it:
   ```bash
   chmod +x Optimize-Kali.sh
   ./Optimize-Kali.sh
   ```
4. Once finished, go back to Windows PowerShell and run:
   ```powershell
   wsl --shutdown
   ```
5. Restart Kali.

---

## 📡 Hardware Passthrough (WiFi Pentesting)
To use an external USB WiFi adapter in Kali:
1. Connect the adapter to your PC.
2. In Windows PowerShell (Admin):
   ```powershell
   usbipd list
   usbipd bind --busid <BUSID>
   usbipd attach --wsl --busid <BUSID>
   ```
3. In Kali, verify with `lsusb` and `iwconfig`.

---

## ⚠️ Legal Disclaimer & Liability
**FOR EDUCATIONAL AND AUTHORIZED TESTING ONLY.**

By using this setup, you agree to the following:
- You are solely responsible for your actions and any legal consequences arising from the use of these tools.
- This environment is intended for professional penetration testing and security research in controlled, authorized environments.
- The developers of this script (Manus AI) are not liable for any misuse, damage, or illegal activity performed using this software.
- **Always obtain explicit written permission** before testing any network or system you do not own.

---

## 📜 Credits
- **Lead Developer** (Michael Lastovich)
- **Kali Linux Team** (OffSec)
- **Microsoft WSL Team**
- **dorssel** (usbipd-win)

