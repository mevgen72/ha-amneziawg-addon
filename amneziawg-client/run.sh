#!/bin/bash
set -e

# Конфиг из /config/amneziawg/awg0.conf (маппинг через map: config:rw)
CONFIG="/config/amneziawg/awg0.conf"

echo "=== AmneziaWG Client ==="

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: Config not found at $CONFIG"
    echo "Please create /config/amneziawg/awg0.conf"
    echo ""
    echo "Example config:"
    echo "[Interface]"
    echo "PrivateKey = YOUR_KEY"
    echo "Address = 10.8.1.8/32"
    echo "..."
    sleep 99999
    exit 1
fi

echo "Config found: $CONFIG"

if [ ! -e /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
    chmod 600 /dev/net/tun
fi

echo "Starting amneziawg-go..."

amneziawg-go -f "$CONFIG" &

sleep 3

echo "Interface status:"
ip link show awg0 2>/dev/null || echo "awg0 not found yet"

echo "Routes:"
ip route | grep awg0 2>/dev/null || true

echo "=== Running ==="

while true; do
    sleep 60
done
