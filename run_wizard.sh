#!/bin/bash
echo "Starting OpenClaw Onboarding Wizard..."
docker compose run --rm sandbox node openclaw.mjs onboard --no-install-daemon
