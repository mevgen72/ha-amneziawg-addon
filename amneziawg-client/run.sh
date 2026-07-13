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

# Создаём TUN device ДО запуска amneziawg-go
echo "Creating TUN device..."
mkdir -p /dev/net
if [ ! -e /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi
chmod 600 /dev/net/tun
ls -la /dev/net/tun

echo "TUN device ready"

# Включаем IP forwarding
sysctl -w net.ipv4.ip_forward=1 2>/dev/null || true
sysctl -w net.ipv4.conf.all.src_valid_mark=1 2>/dev/null || true

echo "Starting amneziawg-go (userspace)..."

# Запускаем amneziawg-go с явным указанием TUN
# -f = конфиг файл
export WG_TUN_NAME=awg0
export WG_CONFIG_FILE="$CONFIG"

amneziawg-go -f "$CONFIG" &

sleep 5

echo ""
echo "Interface status:"
ip link show awg0 2>/dev/null || echo "awg0 not found"

echo ""
echo "All interfaces:"
ip link show 2>/dev/null | head -20 || true

echo ""
echo "Routes:"
ip route | grep awg0 2>/dev/null || true

echo ""
echo "Testing Telegram API..."
curl -s --max-time 10 -o /dev/null -w "HTTP code: %{http_code}\n"     --interface awg0 https://api.telegram.org 2>/dev/null ||     echo "curl test failed"

echo ""
echo "=== Running ==="

# Держим контейнер активным
while true; do
    if ! ip link show awg0 >/dev/null 2>&1; then
        echo "Interface down! Restarting..."
        amneziawg-go -f "$CONFIG" &
        sleep 3
        echo "Interface restored"
    fi
    sleep 30
done
