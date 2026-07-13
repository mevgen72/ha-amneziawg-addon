#!/bin/bash
set -e

CONFIG="/config/amneziawg/awg0.conf"

echo "=== AmneziaWG Client ==="

if [ ! -f "$CONFIG" ]; then
    echo "ERROR: Config not found at $CONFIG"
    echo "Please create /config/amneziawg/awg0.conf"
    sleep 99999
    exit 1
fi

echo "Config found: $CONFIG"

if [ ! -e /dev/net/tun ]; then
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
    chmod 600 /dev/net/tun
fi

echo "Starting AmneziaWG..."

# awg-quick ищет конфиг в /etc/amnezia/amneziawg/ !
mkdir -p /etc/amnezia/amneziawg
cp "$CONFIG" /etc/amnezia/amneziawg/awg0.conf

# Запускаем через awg-quick
awg-quick up awg0

echo ""
echo "AmneziaWG interface is UP!"
echo ""

echo "Status:"
awg show awg0

echo ""
echo "Routes:"
ip route | grep awg0 2>/dev/null || true

echo ""
echo "Testing Telegram API..."
curl -s --max-time 10 -o /dev/null -w "HTTP code: %{http_code}\n"     --interface awg0 https://api.telegram.org 2>/dev/null ||     echo "curl test failed"

echo ""
echo "=== Running ==="

while true; do
    if ! ip link show awg0 >/dev/null 2>&1; then
        echo "Interface down! Restarting..."
        awg-quick down awg0 2>/dev/null || true
        sleep 2
        awg-quick up awg0
        echo "Interface restored"
    fi
    sleep 30
done
