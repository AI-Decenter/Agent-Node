#!/bin/bash
# Terra Node Setup Script - One-command node installation
# Usage: curl -sSL https://raw.githubusercontent.com/AI-Decenter/Agent-Node/main/terra-node-linux.sh | bash -s -- [client_id] [client_password]
set -e

# Default configuration
DEFAULT_DOWNLOAD_URL="https://github.com/AI-Decenter/Agent-Node/releases/latest/download/terra-node-linux-x86_64"

# Parse arguments or use environment variables with defaults
CLIENT_ID="${1:-${CLIENT_ID}}_linux"
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

# Create client ID with IP if available, otherwise use original CLIENT_ID
if [[ -n "$PUBLIC_IP" ]]; then
    CLIENT_WITH_IP="${CLIENT_ID}_${PUBLIC_IP}"
else
    CLIENT_WITH_IP="$CLIENT_ID"
fi

log "Installing Terra Node (ID: $CLIENT_WITH_IP)"

# Create setup directory
SETUP_DIR="/opt/terra-node"
log "Creating setup directory: $SETUP_DIR"
sudo mkdir -p "$SETUP_DIR"

# Download node binary
log "Downloading terra-agent from: $DOWNLOAD_URL"
cd "$SETUP_DIR" || exit
if ! sudo curl -fsSL -o terra-agent "$DOWNLOAD_URL"; then
    error "Failed to download terra-agent from: $DOWNLOAD_URL"
fi
sudo chmod +x terra-agent

# Create config file
log "Creating configuration file"
sudo tee config.toml > /dev/null <<EOF
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

# Create systemd service
log "Creating systemd service"
sudo tee /etc/systemd/system/terra-node.service > /dev/null <<EOF
[Unit]
Description=Terra Node Service
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=$SETUP_DIR
ExecStart=$SETUP_DIR/terra-agent --config config.toml
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal
SyslogIdentifier=terra-node

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
log "Enabling and starting Terra Node service"
sudo systemctl daemon-reload
sudo systemctl enable terra-node.service
sudo systemctl start terra-node.service

# Wait and check service status
sleep 2
if systemctl is-active --quiet terra-node.service; then
    log "Terra Node service started successfully"
    SERVICE_STATUS="running"
else
    log "Warning: Service may have failed to start. Check: journalctl -u terra-node -f"
    SERVICE_STATUS="failed"
fi

# Display installation summary
log "Installation completed!"
echo
echo "Terra Node Details:"
echo "  Client ID: $CLIENT_WITH_IP"
echo "  Setup Directory: $SETUP_DIR"
echo "  Service Status: $SERVICE_STATUS"
echo
echo "Service Management Commands:"
echo "  Check status: sudo systemctl status terra-node"
echo "  View logs: sudo journalctl -u terra-node -f"
echo "  Stop service: sudo systemctl stop terra-node"
echo "  Start service: sudo systemctl start terra-node"
echo "  Restart service: sudo systemctl restart terra-node"
