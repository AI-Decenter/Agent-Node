# Agent Node Installation Guide

Complete setup instructions for deploying Agent Nodes across different environments.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
  - [1. Strato Node (VPS/Virtual Machine)](#1-strato-node-vpsvirtual-machine)
  - [2. Terra Node (Linux)](#2-terra-node-linux)
  - [3. Terra Node (macOS)](#3-terra-node-macos)
  - [4. Terra Node (Windows)](#4-terra-node-windows)
- [Getting Your Credentials](#getting-your-credentials)
- [Troubleshooting](#troubleshooting)

---

## Overview

Agent Nodes are distributed key-value store nodes that participate in the AI-Decenter network. This guide covers installation on:

- **Strato Node**: For VPS and virtual machines (systemd-based Linux)
- **Terra Node (Linux)**: For Linux desktop/server environments
- **Terra Node (macOS)**: For macOS desktop/server environments (Intel & Apple Silicon)
- **Terra Node (Windows)**: For Windows desktop/server environments

---

## Prerequisites

### All Platforms
- Active internet connection
- Valid `CLIENT_ID` and `CLIENT_PASSWORD` from your Dashboard
- Sufficient disk space (minimum 1GB recommended)

### Linux/VPS
- Ubuntu 18.04+ / Debian 9+ / CentOS 7+ or any systemd-based Linux distribution
- `curl` installed
- `sudo` privileges

### macOS
- macOS 10.15 (Catalina) or higher
- Works on both Intel (x86_64) and Apple Silicon (M1/M2/M3) Macs
- Terminal access
- `curl` installed (pre-installed on macOS)

### Windows
- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1 or higher
- Administrator privileges

---

## Installation Methods

### 1. Strato Node (VPS/Virtual Machine)

Strato Node is designed for VPS and virtual machine deployments with automatic systemd service configuration.

#### Quick Installation

Copy and run this single command in your terminal:

```bash
export CLIENT_ID='your_client_id' CLIENT_PASSWORD='your_client_password' && curl -sSL https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/strato-node-linux.sh | bash -s
```

> **Important:** Replace `your_client_id` and `your_client_password` with your actual credentials from the Dashboard.

#### What Gets Installed

- **Binary Location:** `/opt/strato-node/strato-agent`
- **Configuration:** `/opt/strato-node/config.toml`
- **Service Name:** `strato-node.service`
- **Data Directory:** `/opt/strato-node/strato_data`

#### Service Management Commands

```bash
# Check service status
sudo systemctl status strato-node

# View live logs (real-time)
sudo journalctl -u strato-node -f

# View last 100 log lines
sudo journalctl -u strato-node -n 100

# Stop the service
sudo systemctl stop strato-node

# Start the service
sudo systemctl start strato-node

# Restart the service
sudo systemctl restart strato-node

# Disable service (prevent auto-start on boot)
sudo systemctl disable strato-node

# Enable service (auto-start on boot)
sudo systemctl enable strato-node
```

#### Manual Configuration

If you need to modify the configuration:

```bash
# Edit configuration file
sudo nano /opt/strato-node/config.toml

# After editing, restart the service
sudo systemctl restart strato-node
```

[⬆ Back to top](#table-of-contents)

---

### 2. Terra Node (Linux)

Terra Node for Linux provides the same functionality as Strato Node but uses different binary naming conventions.

#### Quick Installation

Copy and run this single command in your terminal:

```bash
export CLIENT_ID='your_client_id' CLIENT_PASSWORD='your_client_password' && curl -sSL https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/terra-node-linux.sh | bash -s
```

> **Important:** Replace `your_client_id` and `your_client_password` with your actual credentials from the Dashboard.

#### What Gets Installed

- **Binary Location:** `/opt/terra-node/terra-agent`
- **Configuration:** `/opt/terra-node/config.toml`
- **Service Name:** `terra-node.service`
- **Data Directory:** `/opt/terra-node/terra_data`

#### Service Management Commands

```bash
# Check service status
sudo systemctl status terra-node

# View live logs (real-time)
sudo journalctl -u terra-node -f

# View last 100 log lines
sudo journalctl -u terra-node -n 100

# Stop the service
sudo systemctl stop terra-node

# Start the service
sudo systemctl start terra-node

# Restart the service
sudo systemctl restart terra-node

# Disable service (prevent auto-start on boot)
sudo systemctl disable terra-node

# Enable service (auto-start on boot)
sudo systemctl enable terra-node
```

#### Manual Configuration

If you need to modify the configuration:

```bash
# Edit configuration file
sudo nano /opt/terra-node/config.toml

# After editing, restart the service
sudo systemctl restart terra-node
```

[⬆ Back to top](#table-of-contents)

---

### 3. Terra Node (macOS)

Terra Node for macOS runs as a LaunchAgent service with automatic startup. The installer automatically detects your Mac's architecture (Intel or Apple Silicon) and downloads the appropriate binary.

#### Quick Installation

1. **Open Terminal**
   - Press `Cmd + Space` and type "Terminal"
   - Or find it in Applications → Utilities → Terminal

2. **Run the installation command:**

```bash
export CLIENT_ID='your_client_id' CLIENT_PASSWORD='your_client_password' && curl -sSL https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/terra-node-macos.sh | bash -s
```

> **Important:** Replace `your_client_id` and `your_client_password` with your actual credentials from the Dashboard.

#### Supported Architectures

The script automatically detects and installs the correct binary:
- **Apple Silicon (M1/M2/M3)**: Downloads `agent-node-aarch64-apple-darwin`
- **Intel Macs**: Downloads `agent-node-x86_64-apple-darwin`

#### What Gets Installed

- **Installation Directory:** `~/Library/Application Support/terra-node`
- **Executable:** `~/Library/Application Support/terra-node/terra-agent`
- **Configuration:** `~/Library/Application Support/terra-node/config.toml`
- **Service Name:** `ai.decenter.terra-node`
- **Data Directory:** `~/Library/Application Support/terra-node/terra_data`
- **Log Files:**
  - Standard Output: `~/Library/Application Support/terra-node/terra-node.log`
  - Error Output: `~/Library/Application Support/terra-node/terra-node-error.log`

#### Service Management Commands

```bash
# Check service status
launchctl list | grep terra-node

# View live logs (tail -f equivalent)
tail -f ~/Library/Application\ Support/terra-node/terra-node.log

# View error logs
tail -f ~/Library/Application\ Support/terra-node/terra-node-error.log

# View last 50 lines of logs
tail -n 50 ~/Library/Application\ Support/terra-node/terra-node.log

# Stop the service
launchctl unload ~/Library/LaunchAgents/ai.decenter.terra-node.plist

# Start the service
launchctl load ~/Library/LaunchAgents/ai.decenter.terra-node.plist

# Restart the service
launchctl unload ~/Library/LaunchAgents/ai.decenter.terra-node.plist && launchctl load ~/Library/LaunchAgents/ai.decenter.terra-node.plist
```

#### Manual Configuration

If you need to modify the configuration:

```bash
# Edit configuration file
nano ~/Library/Application\ Support/terra-node/config.toml

# After editing, restart the service
launchctl unload ~/Library/LaunchAgents/ai.decenter.terra-node.plist && launchctl load ~/Library/LaunchAgents/ai.decenter.terra-node.plist
```

#### Complete Uninstallation

If you need to completely remove Terra Node:

```bash
# Stop and unload the service
launchctl unload ~/Library/LaunchAgents/ai.decenter.terra-node.plist

# Remove the LaunchAgent plist
rm ~/Library/LaunchAgents/ai.decenter.terra-node.plist

# Remove installation directory
rm -rf ~/Library/Application\ Support/terra-node
```

[⬆ Back to top](#table-of-contents)

---

### 4. Terra Node (Windows)

Terra Node for Windows runs as a background Windows Service with no console window.

#### Quick Installation

1. **Open PowerShell as Administrator**
   - Right-click on PowerShell
   - Select "Run as Administrator"

2. **Run the installation command:**

```powershell
$env:CLIENT_ID='your_client_id'; $env:CLIENT_PASSWORD='your_client_password'; iex (irm https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/terra-node-windows.ps1)
```

> **Important:** Replace `your_client_id` and `your_client_password` with your actual credentials from the Dashboard.

#### What Gets Installed

- **Installation Directory:** `C:\ProgramData\TerraNode`
- **Executable:** `C:\ProgramData\TerraNode\terra-agent.exe`
- **Configuration:** `C:\ProgramData\TerraNode\config.toml`
- **Service Name:** `TerraNode`
- **Data Directory:** `C:\ProgramData\TerraNode\terra_data`
- **Log Files:**
  - Standard Output: `C:\ProgramData\TerraNode\service.log`
  - Error Output: `C:\ProgramData\TerraNode\service-error.log`

#### Service Management Commands (PowerShell)

```powershell
# Check service status
Get-Service -Name TerraNode

# Check detailed service status
Get-Service -Name TerraNode | Format-List *

# Stop the service
Stop-Service -Name TerraNode

# Start the service
Start-Service -Name TerraNode

# Restart the service
Restart-Service -Name TerraNode

# Set service to start automatically
Set-Service -Name TerraNode -StartupType Automatic

# Set service to manual start
Set-Service -Name TerraNode -StartupType Manual
```

#### Service Management Commands (GUI)

1. Press `Win + R`
2. Type `services.msc` and press Enter
3. Find "Terra Node Service"
4. Right-click for options (Start, Stop, Restart, Properties)

#### Viewing Logs

**View live logs (tail -f equivalent):**

```powershell
# View standard output logs (last 50 lines, live update)
Get-Content "C:\ProgramData\TerraNode\service.log" -Tail 50 -Wait

# View error logs (last 50 lines, live update)
Get-Content "C:\ProgramData\TerraNode\service-error.log" -Tail 50 -Wait
```

**View complete logs:**

```powershell
# View all standard output
Get-Content "C:\ProgramData\TerraNode\service.log"

# View all error output
Get-Content "C:\ProgramData\TerraNode\service-error.log"

# View last 100 lines
Get-Content "C:\ProgramData\TerraNode\service.log" -Tail 100
```

#### Manual Configuration

If you need to modify the configuration:

```powershell
# Open configuration file in Notepad
notepad "C:\ProgramData\TerraNode\config.toml"

# After editing, restart the service
Restart-Service -Name TerraNode
```

#### Firewall Configuration

The installer automatically creates a firewall rule for port 8379. To verify:

```powershell
# Check firewall rule
Get-NetFirewallRule -DisplayName "Terra Node"

# Manually create firewall rule if needed
New-NetFirewallRule -DisplayName "Terra Node" -Direction Inbound -Protocol TCP -LocalPort 8379 -Action Allow
```

[⬆ Back to top](#table-of-contents)

---

## Getting Your Credentials

To obtain your `CLIENT_ID` and `CLIENT_PASSWORD`:

1. Log in to your **Dashboard** at the AI-Decenter platform
2. Navigate to the **Node Management** or **Settings** section
3. Locate your unique **Client ID** and **Client Password**
4. Copy these credentials for use in the installation commands

> **Security Note:** Keep your credentials secure and do not share them publicly. Each set of credentials is unique to your account.

[⬆ Back to top](#table-of-contents)

---

## Troubleshooting

### Linux/VPS Issues

#### Service Won't Start

Check the service logs for error messages:

```bash
# View recent logs for Strato Node
sudo journalctl -u strato-node -n 50 --no-pager

# View recent logs for Terra Node
sudo journalctl -u terra-node -n 50 --no-pager

# View logs with timestamps
sudo journalctl -u strato-node -n 50 --no-pager -o short-precise
```

#### Port Already in Use

Check if port 8379 is already occupied:

```bash
# Check what's using port 8379
sudo netstat -tulpn | grep 8379
# or
sudo ss -tulpn | grep 8379

# Kill the process if needed (replace PID with actual process ID)
sudo kill -9 PID
```

#### Permission Issues

Ensure the service has proper permissions:

```bash
# For Strato Node
sudo chown -R root:root /opt/strato-node
sudo chmod +x /opt/strato-node/strato-agent

# For Terra Node
sudo chown -R root:root /opt/terra-node
sudo chmod +x /opt/terra-node/terra-agent
```

#### Network Connectivity

Test MQTT broker connectivity:

```bash
# Install mosquitto clients if not available
sudo apt-get install mosquitto-clients  # Debian/Ubuntu
sudo yum install mosquitto              # CentOS/RHEL

# Test connection to MQTT broker
mosquitto_sub -h emqx.decenter.ai -p 1883 -t test -v
```

#### Reinstallation

If you need to completely reinstall:

```bash
# For Strato Node
sudo systemctl stop strato-node
sudo systemctl disable strato-node
sudo rm /etc/systemd/system/strato-node.service
sudo rm -rf /opt/strato-node
sudo systemctl daemon-reload

# For Terra Node
sudo systemctl stop terra-node
sudo systemctl disable terra-node
sudo rm /etc/systemd/system/terra-node.service
sudo rm -rf /opt/terra-node
sudo systemctl daemon-reload
```

### macOS Issues

#### Service Won't Start

Check the service logs:

```bash
# View standard output log
tail -n 100 ~/Library/Application\ Support/terra-node/terra-node.log

# View error log
tail -n 100 ~/Library/Application\ Support/terra-node/terra-node-error.log

# Check if service is loaded
launchctl list | grep terra-node
```

#### Port Already in Use

Check if port 8379 is occupied:

```bash
# Check what's using port 8379
lsof -i :8379

# Kill the process if needed (replace PID with actual process ID)
kill -9 PID
```

#### Permission Issues

Ensure proper file permissions:

```bash
# Fix permissions
chmod +x ~/Library/Application\ Support/terra-node/terra-agent

# Check file ownership (should be your user)
ls -la ~/Library/Application\ Support/terra-node/
```

#### Architecture Detection Issues

Verify your Mac's architecture:

```bash
# Check your Mac's architecture
uname -m

# Should return:
# arm64 - for Apple Silicon (M1/M2/M3)
# x86_64 - for Intel Macs
```

#### Download Failures

If the download fails:

```bash
# Check your internet connection
ping -c 4 github.com

# Try manual download for Apple Silicon
curl -L -o ~/Downloads/terra-agent https://github.com/AI-Decenter/Agent-Node/releases/latest/download/agent-node-aarch64-apple-darwin

# Try manual download for Intel
curl -L -o ~/Downloads/terra-agent https://github.com/AI-Decenter/Agent-Node/releases/latest/download/agent-node-x86_64-apple-darwin
```

#### Gatekeeper Issues

If macOS blocks the executable (security warning):

```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine ~/Library/Application\ Support/terra-node/terra-agent

# Or allow in System Preferences:
# System Preferences → Security & Privacy → General → Allow
```

#### Complete Reinstallation

If you need to completely reinstall:

```bash
# Stop and unload the service
launchctl unload ~/Library/LaunchAgents/ai.decenter.terra-node.plist

# Remove all files
rm ~/Library/LaunchAgents/ai.decenter.terra-node.plist
rm -rf ~/Library/Application\ Support/terra-node

# Then run the installation script again
```

### Windows Issues

#### Administrator Privileges Required

If you see an error about administrator privileges:

1. Close PowerShell
2. Right-click PowerShell icon
3. Select "Run as Administrator"
4. Run the installation command again

#### Download Failures

If the download fails:

```powershell
# Check your internet connection
Test-NetConnection -ComputerName github.com -Port 443

# Verify TLS settings
[Net.ServicePointManager]::SecurityProtocol

# Try manual download
Invoke-WebRequest -Uri "https://github.com/AI-Decenter/Agent-Node/releases/latest/download/terra-node-windows-x86_64.exe" -OutFile "$env:TEMP\terra-agent.exe"
```

#### Service Won't Start

Check the Windows Event Viewer:

1. Press `Win + R`
2. Type `eventvwr.msc` and press Enter
3. Navigate to: Windows Logs → Application
4. Look for errors from "TerraNode" service

Or check service logs:

```powershell
# View error log
Get-Content "C:\ProgramData\TerraNode\service-error.log" -Tail 50

# Check service status details
Get-Service -Name TerraNode | Format-List *
Get-WmiObject Win32_Service | Where-Object {$_.Name -eq "TerraNode"} | Format-List *
```

#### Port Already in Use

Check if port 8379 is occupied:

```powershell
# Check what's using port 8379
Get-NetTCPConnection -LocalPort 8379 -ErrorAction SilentlyContinue

# Find the process using the port
Get-Process -Id (Get-NetTCPConnection -LocalPort 8379).OwningProcess
```

#### Firewall Blocking Connection

Manually configure firewall:

```powershell
# Check existing rule
Get-NetFirewallRule -DisplayName "Terra Node"

# Remove old rule
Remove-NetFirewallRule -DisplayName "Terra Node"

# Create new rule
New-NetFirewallRule -DisplayName "Terra Node" -Direction Inbound -Protocol TCP -LocalPort 8379 -Action Allow
```

#### Complete Uninstallation

If you need to completely remove Terra Node:

```powershell
# Stop and remove service
Stop-Service -Name TerraNode -Force
sc.exe delete TerraNode

# Remove files
Remove-Item -Path "C:\ProgramData\TerraNode" -Recurse -Force

# Remove firewall rule
Remove-NetFirewallRule -DisplayName "Terra Node"
```

### Common Issues (All Platforms)

#### Authentication Errors

If you see authentication errors:

- Verify your `CLIENT_ID` and `CLIENT_PASSWORD` are correct
- Check for extra spaces or quotes in your credentials
- Ensure you copied the full credentials from the Dashboard
- Verify your account is active on the platform

#### Connection Timeouts

If the node can't connect to the MQTT broker:

- Check your firewall settings (allow outbound connections on port 1883)
- Verify internet connectivity
- Check if your network blocks MQTT traffic
- Test DNS resolution:
  - **Linux/macOS**: `nslookup emqx.decenter.ai`
  - **Windows**: `nslookup emqx.decenter.ai`

#### High CPU/Memory Usage

Monitor resource usage:

**Linux:**
```bash
# Check CPU and memory usage
top -p $(pgrep -f "strato-agent|terra-agent")
```

**macOS:**
```bash
# Check CPU and memory usage
top -pid $(pgrep -f "terra-agent")

# Or use Activity Monitor (GUI)
open -a "Activity Monitor"
```

**Windows:**
```powershell
# Check process resource usage
Get-Process terra-agent | Format-List *
```

[⬆ Back to top](#table-of-contents)

---

## License

Copyright © 2025 AI-Decenter. All rights reserved.

---

**Last Updated:** October 2025  
**Version:** 1.1.0
