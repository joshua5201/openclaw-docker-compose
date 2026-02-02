#!/bin/bash
set -e

# 1. Ensure local persistence directories exist
mkdir -p config workspace

# 2. Check for OpenClaw Repository
REPO_DIR="openclaw"
if [ ! -d "$REPO_DIR" ] || [ -z "$(ls -A $REPO_DIR)" ]; then
    echo "==> Cloning OpenClaw repository..."
    git clone --depth 10 https://github.com/openclaw/openclaw.git "$REPO_DIR"
else
    echo "==> Updating OpenClaw repository..."
    cd "$REPO_DIR" && git pull && cd - > /dev/null
fi

echo "==> Building OpenClaw Image..."
docker compose build

echo "==> Installing dependencies (isolated volume)..."
docker compose run --rm openclaw pnpm install

echo "==> Compiling OpenClaw..."
docker compose run --rm openclaw pnpm build

echo "==> Building UI..."
docker compose run --rm openclaw pnpm ui:build

echo ""
# Hand over to the wizard script for config and startup
./run_wizard.sh
