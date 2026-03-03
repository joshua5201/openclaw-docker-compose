#!/bin/bash
set -e

# 1. Ensure local persistence directories exist
mkdir -p config workspace

echo "==> Building OpenClaw Image..."
docker compose build

echo ""
# Hand over to the wizard script for config and startup
./run_wizard.sh
