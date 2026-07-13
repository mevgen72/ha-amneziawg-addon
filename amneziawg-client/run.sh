#!/bin/bash
set -e

CONFIG="/etc/amneziawg/awg0.conf"

echo "=== AmneziaWG Client ==="

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: Config not found at $CONFIG"
    sleep 99999
    exit 1
fi

echo "Config found"

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
