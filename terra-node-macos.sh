#!/bin/bash
# Terra Node Setup Script - One-command node installation for macOS
# Usage: curl -sSL https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/terra-node-macos.sh | bash -s -- [client_id] [client_password]

set -e

# Detect CPU architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    DEFAULT_DOWNLOAD_URL="https://github.com/AI-Decenter/Agent-Node/releases/latest/download/agent-node-aarch64-apple-darwin"
    ARCH_SUFFIX="arm64"
elif [[ "$ARCH" == "x86_64" ]]; then
    DEFAULT_DOWNLOAD_URL="https://github.com/AI-Decenter/Agent-Node/releases/latest/download/agent-node-x86_64-apple-darwin"
    ARCH_SUFFIX="x86_64"
else
    error "Unsupported architecture: $ARCH. Only arm64 (Apple Silicon) and x86_64 (Intel) are supported."
fi

# Parse arguments or use environment variables with defaults
CLIENT_ID="${1:-${CLIENT_ID}}"
CLIENT_PASSWORD="${2:-${CLIENT_PASSWORD}}"
DOWNLOAD_URL="${3:-${DOWNLOAD_URL:-$DEFAULT_DOWNLOAD_URL}}"

# Enhanced logging
log() {
    echo -e "\033[32m[$(date '+%H:%M:%S')] $1\033[0m"
}

error() {
    echo -e "\033[31m[ERROR] $1\033[0m" >&2
    exit 1
}

# Validate required parameters
[[ -n "$CLIENT_ID" ]] || error "Client ID is required. Usage: bash script.sh [client_id] [client_password]"
[[ -n "$CLIENT_PASSWORD" ]] || error "Client password is required. Usage: bash script.sh [client_id] [client_password]"

PUBLIC_IP=$(curl -4 -s --max-time 5 icanhazip.com 2>/dev/null || echo "")

# Create client ID with IP and architecture if available
if [[ -n "$PUBLIC_IP" ]]; then
    CLIENT_WITH_IP="${CLIENT_ID}_macos-${ARCH_SUFFIX}_${PUBLIC_IP}"
else
    CLIENT_WITH_IP="${CLIENT_ID}_macos-${ARCH_SUFFIX}"
fi

log "Detected architecture: $ARCH ($ARCH_SUFFIX)"
log "Installing Terra Node (ID: $CLIENT_WITH_IP)"

# Create setup directory (using ~/Library/Application Support for macOS standards)
SETUP_DIR="$HOME/Library/Application Support/terra-node"
log "Creating setup directory: $SETUP_DIR"
mkdir -p "$SETUP_DIR"

# Download node binary
log "Downloading terra-agent from: $DOWNLOAD_URL"
cd "$SETUP_DIR" || exit
if ! curl -fsSL -o terra-agent "$DOWNLOAD_URL"; then
    error "Failed to download terra-agent from: $DOWNLOAD_URL"
fi
chmod +x terra-agent

# Create config file
log "Creating configuration file"
cat > config.toml <<EOF
host = "127.0.0.1"
port = 8379
storage_path = "terra_data"
engine = "rwlock"
sync_interval_seconds = 30

[replication]
enabled = true
mqtt_broker = "emqx.decenter.ai"
mqtt_port = 1883
topic_prefix = "terra_kv"
client_id = "$CLIENT_WITH_IP"
client_password = "$CLIENT_PASSWORD"
EOF

# Create LaunchAgent plist for automatic startup
log "Creating LaunchAgent service"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$PLIST_DIR/ai.decenter.terra-node.plist"

mkdir -p "$PLIST_DIR"

cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ai.decenter.terra-node</string>
    <key>ProgramArguments</key>
    <array>
        <string>$SETUP_DIR/terra-agent</string>
        <string>--config</string>
        <string>$SETUP_DIR/config.toml</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$SETUP_DIR</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$SETUP_DIR/terra-node.log</string>
    <key>StandardErrorPath</key>
    <string>$SETUP_DIR/terra-node-error.log</string>
    <key>ThrottleInterval</key>
    <integer>5</integer>
</dict>
</plist>
EOF

# Load and start the service
log "Loading and starting Terra Node service"
launchctl unload "$PLIST_FILE" 2>/dev/null || true
launchctl load "$PLIST_FILE"

# Wait and check service status
sleep 2
if launchctl list | grep -q "ai.decenter.terra-node"; then
    log "Terra Node service started successfully"
    SERVICE_STATUS="running"
else
    log "Warning: Service may have failed to start. Check logs in: $SETUP_DIR"
    SERVICE_STATUS="failed"
fi

# Display installation summary
log "Installation completed!"
echo
echo "Terra Node Details:"
echo "  Architecture: $ARCH ($ARCH_SUFFIX)"
echo "  Client ID: $CLIENT_WITH_IP"
echo "  Setup Directory: $SETUP_DIR"
echo "  Service Status: $SERVICE_STATUS"
echo
echo "Service Management Commands:"
echo "  Check status: launchctl list | grep terra-node"
echo "  View logs: tail -f '$SETUP_DIR/terra-node.log'"
echo "  View errors: tail -f '$SETUP_DIR/terra-node-error.log'"
echo "  Stop service: launchctl unload '$PLIST_FILE'"
echo "  Start service: launchctl load '$PLIST_FILE'"
echo "  Restart service: launchctl unload '$PLIST_FILE' && launchctl load '$PLIST_FILE'"
echo
echo "Uninstall Instructions:"
echo "  1. launchctl unload '$PLIST_FILE'"
echo "  2. rm '$PLIST_FILE'"
echo "  3. rm -rf '$SETUP_DIR'"
