# AI Development Guide

This file provides context and instructions for AI assistants (Gemini, Claude, ChatGPT, etc.) working on the `openclaw-docker-compose` repository.

## Project Overview
This repository provides a reproducible, isolated Docker environment for [OpenClaw](https://github.com/openclaw/openclaw). It uses a single-container architecture where the container acts as both the gateway server and the development sandbox.

## Architecture
- **Service Name**: `openclaw`
- **Base Image**: Ubuntu 24.04 (Noble) with Node.js 22.
- **Persistence**: 
  - `./openclaw`: Source code (mounted).
  - `./config`: Gateway configuration.
  - `./workspace`: Agent state and memory.
  - `openclaw_node_modules`: Docker volume for isolated dependencies.

## Key Commands

### Setup & Build
- Full Setup: `./setup.sh`
- Build Image: `docker compose build`
- Install Dependencies: `docker compose run --rm openclaw pnpm install`
- Compile Source: `docker compose run --rm openclaw pnpm build`
- Build UI: `docker compose run --rm openclaw pnpm ui:build`

### Runtime & CLI
- Start Gateway: `docker compose up -d`
- Stop Gateway: `docker compose down`
- Enter Sandbox: `docker compose exec openclaw bash`
- Pair Device: `docker compose exec openclaw node openclaw.mjs devices approve <ID>`

## AI Agent Workflow Guidelines
To maintain a clean and safe development process, all AI agents must follow these rules:

1. **Branching Strategy**: Always create a new feature/bugfix branch for any development work. Do not work directly on the `main` branch.
2. **No Auto-Push**: Do not push changes to the remote repository (GitHub) automatically. Always wait for explicit user confirmation before pushing.
3. **Commit Messages**: Use clear, descriptive commit messages following the project's style.
4. **Testing**: Verify changes inside the Docker sandbox using the provided build/test commands before considering a task complete.
