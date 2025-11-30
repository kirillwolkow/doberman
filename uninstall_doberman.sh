#!/usr/bin/env bash
set -e

echo "=== Doberman Uninstaller ==="

INSTALL_DIR="/opt/doberman"
LOG_DIR="/var/log/doberman"
SERVICE_FILE="/etc/systemd/system/doberman.service"
TIMER_FILE="/etc/systemd/system/doberman.timer"

echo "[1/5] Stopping and disabling systemd units..."

if systemctl list-unit-files | grep -q "doberman.timer"; then
    sudo systemctl stop doberman.timer || true
    sudo systemctl disable doberman.timer || true
fi

if systemctl list-unit-files | grep -q "doberman.service"; then
    sudo systemctl stop doberman.service || true
    sudo systemctl disable doberman.service || true
fi


echo "[2/5] Removing systemd unit files..."

if [ -f "$SERVICE_FILE" ]; then
    sudo rm -f "$SERVICE_FILE"
fi

if [ -f "$TIMER_FILE" ]; then
    sudo rm -f "$TIMER_FILE"
fi

sudo systemctl daemon-reload


echo "[3/5] Removing logs..."
if [ -d "$LOG_DIR" ]; then
    sudo rm -rf "$LOG_DIR"
fi


echo "[4/5] Removing Doberman installation..."
if [ -d "$INSTALL_DIR" ]; then
    sudo rm -rf "$INSTALL_DIR"
fi


echo "[5/5] Removing this uninstaller script..."
SCRIPT_PATH="$0"
if [ -f "$SCRIPT_PATH" ]; then
    sudo rm -f "$SCRIPT_PATH"
fi

echo ""
echo "=== Doberman has been fully uninstalled. ==="
