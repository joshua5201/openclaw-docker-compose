#!/bin/bash
set -e

# 1. Ensure local persistence directories exist
mkdir -p config workspace

# 2. Check for OpenClaw Repository
REPO_DIR="openclaw"
if [ ! -d "$REPO_DIR" ] || [ -z "$(ls -A $REPO_DIR)" ]; then
    echo "==> Cloning OpenClaw repository..."
    git clone https://github.com/openclaw/openclaw.git "$REPO_DIR"
else
    echo "==> Updating OpenClaw repository..."
    cd "$REPO_DIR" && git pull && cd - > /dev/null
fi

echo "==> Building OpenClaw Sandbox Image..."
docker compose build

echo "==> Installing dependencies inside isolated volume..."
docker compose run --rm sandbox pnpm install

echo "==> Compiling OpenClaw..."
docker compose run --rm sandbox pnpm build

echo "==> Building UI..."
docker compose run --rm sandbox pnpm ui:build

# Generate a random token
TOKEN=$(openssl rand -hex 32)
echo ""
echo "=================================================================="
echo "GENERATED GATEWAY TOKEN: $TOKEN"
echo "=================================================================="
echo "Please COPY and SAVE this token now."
echo "You will need to provide it during the onboarding wizard if asked,"
echo "or use it to log in to the dashboard later."
echo "=================================================================="
echo ""
echo "==> Launching Onboarding Wizard..."
echo "This will configure your OpenClaw instance."
echo "Note: Choose 'token' auth and 'lan' bind when prompted."
echo ""

# Run the onboarding command
docker compose run --rm sandbox node openclaw.mjs onboard --no-install-daemon

echo ""
echo "==> Setup Complete!"
echo "To start the gateway, run:"
echo "  docker compose up -d gateway"
echo ""
echo "The gateway will be available at: http://localhost:18789"