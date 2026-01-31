#!/bin/bash
set -e

echo "==> Launching Onboarding Wizard..."
echo "Follow the prompts. You can choose 'Auto-generate' for the token."
echo ""
docker compose run --rm openclaw node openclaw.mjs onboard --no-install-daemon

# Post-configure: Bind to LAN
CONFIG_FILE="config/openclaw.json"
if [ -f "$CONFIG_FILE" ]; then
    echo "==> Configuring gateway to listen on LAN..."
    # Replace "bind": "loopback" with "bind": "lan"
    if grep -q '"bind": "loopback"' "$CONFIG_FILE"; then
        sed -i 's/"bind": "loopback"/"bind": "lan"/' "$CONFIG_FILE"
        echo "    Updated bind to 'lan'."
    else
        echo "    Bind setting already correct or not found."
    fi
else
    echo "Warning: Config file not found at $CONFIG_FILE"
fi

echo ""
echo "==> Starting Gateway..."
docker compose up -d

echo ""
echo "==> Waiting for gateway to initialize..."
sleep 5

# Grab Token and Print URL
if [ -f "$CONFIG_FILE" ]; then
    TOKEN=$(grep -o '"token": "[^"]*"' "$CONFIG_FILE" | cut -d'"' -f4)
    if [ -n "$TOKEN" ]; then
        echo "========================================================"
        echo "✅ OpenClaw is running!"
        echo ""
        echo "Dashboard URL:"
        echo "http://localhost:18789/?token=$TOKEN"
        echo "========================================================"
    else
        echo "Could not find token in config file. Please check manually."
    fi
else
    echo "Gateway started, but config file missing."
fi

echo ""
echo "⚠️  FINAL STEP: DEVICE PAIRING"
echo "Because you are running in Docker, you must manually approve your browser:"
echo "1. Open the Dashboard URL above."
echo "2. If you see 'Pairing Required', run this command to see the request ID:"
echo "   docker compose exec openclaw node openclaw.mjs devices list"
echo "3. Approve the request using its ID (e.g., 0):"
echo "   docker compose exec openclaw node openclaw.mjs devices approve 0"
echo ""
echo "To enter the shell: docker compose exec openclaw bash"
