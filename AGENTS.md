# AI Development Guide

This file provides context and instructions for AI assistants (Gemini, Claude, ChatGPT, etc.) working on the `openclaw-docker-compose` repository.

## Project Overview
This repository provides a reproducible, isolated Docker environment for [OpenClaw](https://github.com/openclaw/openclaw). The main `openclaw` container hosts the gateway and CLI, and a separate `browserless` service is available for browser automation workloads.

## Architecture
- **Service Name**: `openclaw`
- **Base Image**: `node:22-trixie`
- **Persistence**: 
  - `./config`: OpenClaw config directory mounted to `/home/node/.openclaw`
  - `./workspace`: Agent workspace mounted to `/home/node/.openclaw/workspace`
- **Port Bindings**:
  - `127.0.0.1:${OPENCLAW_PORT}:18789` (Gateway UI)
  - `127.0.0.1:${OPENCLAW_BRIDGE_PORT}:18790` (Bridge)
- **Companion Service**: `browserless/chrome:latest` on `127.0.0.1:${BROWSERLESS_PORT}:3000`

## Key Commands

### Setup & Build
- Full Setup: `./setup.sh`
- Build Image: `docker compose build`
- Run Onboarding Wizard: `./run_wizard.sh`

### Runtime & CLI
- Start Gateway: `docker compose up -d`
- Stop Gateway: `docker compose down`
- Enter Sandbox: `docker compose exec openclaw bash`
- Pair Device: `docker compose exec openclaw devices approve <ID>`
- List Pair Requests: `docker compose exec openclaw devices list`

## AI Agent Workflow Guidelines
To maintain a clean and safe development process, all AI agents must follow these rules:

1. **Branching Strategy**: Always create a new feature/bugfix branch for any development work. Do not work directly on the `main` branch.
2. **Merge Strategy**: Always use the `--no-ff` flag when merging locally to preserve branch history.
3. **No Auto-Push**: Do not push changes to the remote repository (GitHub) automatically. Always wait for explicit user confirmation before pushing.
4. **Commit Messages**: Use clear, descriptive commit messages following the project's style.
5. **Testing**: Verify changes inside the Docker sandbox using the provided build/test commands before considering a task complete.
