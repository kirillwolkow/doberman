#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/kirillwolkow/doberman.git"
INSTALL_DIR="/opt/doberman"
LOG_DIR="/var/log/doberman"
CONFIG_SRC="$INSTALL_DIR/doberman.example.config"
CONFIG_DST="$INSTALL_DIR/doberman.config"
SERVICE_FILE="/etc/systemd/system/doberman.service"
TIMER_FILE="/etc/systemd/system/doberman.timer"

echo "=== Doberman Installer ==="


echo "[1/6] Installing python3 if missing..."
if ! command -v python3 >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y python3
fi


echo "[2/6] Cloning/updating repository..."
if [ ! -d "$INSTALL_DIR" ]; then
    sudo git clone "$REPO_URL" "$INSTALL_DIR"
else
    sudo git -C "$INSTALL_DIR" pull
fi

if [ ! -f "$CONFIG_DST" ]; then
    echo "No doberman.config found — creating from example..."
    sudo cp "$CONFIG_SRC" "$CONFIG_DST"
    sudo chmod 600 "$CONFIG_DST"
else
    echo "Existing doberman.config detected — leaving unchanged."
fi


echo "[3/6] Setting permissions..."
sudo chown -R root:root "$INSTALL_DIR"
sudo chmod -R go-rwx "$INSTALL_DIR"
sudo chmod 750 "$INSTALL_DIR/main.py"


echo "[4/6] Creating log directory..."
sudo mkdir -p "$LOG_DIR"
sudo touch "$LOG_DIR/doberman.log"
sudo chown -R root:root "$LOG_DIR"
sudo chmod 700 "$LOG_DIR"
sudo chmod 600 "$LOG_DIR/doberman.log"


echo "[5/6] Installing systemd service and timer..."

sudo cp "$INSTALL_DIR/systemd/doberman.service" "$SERVICE_FILE"
sudo cp "$INSTALL_DIR/systemd/doberman.timer" "$TIMER_FILE"
sudo chmod 644 "$SERVICE_FILE" "$TIMER_FILE"

sudo systemctl daemon-reload


echo "[6/6] Testing service..."
sudo systemctl start doberman.service || true

echo "Checking logs:"
sudo tail -n 10 "$LOG_DIR/doberman.log" || true


sudo systemctl enable --now doberman.timer

echo ""
echo "=== Installation complete! ==="
echo "Timer status:"
systemctl status doberman.timer --no-pager
echo ""
echo "Doberman will now run every 2 minutes automatically."
