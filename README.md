# openclaw-docker-compose

A reproducible, isolated Docker environment for [OpenClaw](https://github.com/openclaw/openclaw) (formerly known as **Moltbot** and **Clawdbot**), designed to keep your host system clean and secure.

## Features

- **Gateway + Browserless Services**: `openclaw` runs gateway/CLI, and `browserless` handles headless browser workloads.
- **Automated Setup**: One script (`./setup.sh`) handles image build, onboarding, and startup.
- **Non-Root Security**: Runs as a non-root `node` user (UID 1000) inside the container.
- **Persistent Storage**: Configuration and workspace data persist in local `config/` and `workspace/` directories.
- **Built-in Nix**: Single-user Nix is preinstalled in the container (`--no-daemon`) with sandbox mode disabled.

## Prerequisites

- **Docker** and **Docker Compose** installed on your system.
- `git`
- **Note:** This project has only been tested on **Ubuntu 24.04**.

## Quick Start

1.  **Clone this repository:**
    ```bash
    git clone https://github.com/joshua5201/openclaw-docker-compose.git
    cd openclaw-docker-compose
    ```

2.  **Run the automated setup:**
    ```bash
    ./setup.sh
    ```
    This script will:
    *   Build the Docker image.
    *   Launch the interactive **Onboarding Wizard**.
    *   Configure the gateway to listen on LAN (for Docker access).
    *   Start the gateway and provide your **Dashboard URL**.

3.  **Approve your Browser (Pairing):**
    OpenClaw requires you to approve new devices for security.
    If you see "Pairing Required" on the dashboard:
    
    1.  List pending requests:
        ```bash
        docker compose exec openclaw devices list
        ```
    2.  Approve the request ID:
        ```bash
        docker compose exec openclaw devices approve <ID>
        ```

## Usage

- **Start Gateway:** `docker compose up -d`
- **Stop Gateway:** `docker compose down`
- **View Logs:** `docker compose logs -f openclaw`
- **Open Shell:** `docker compose exec openclaw bash`

## Tips

- **Browser Performance:** If you experience performance issues when running the browser inside the main container, you can use the built-in `browserless` service. In your agent configuration, set the browser connection URL to `ws://browserless:3000`. This offloads browser execution and provides 10 concurrent sessions with 2GB of shared memory.
- **Browser Setup:** When asking the agent to use a headless browser, tell it that it is executing inside a Docker sandbox. This informs the agent that it does not need to use additional sandbox mode when setting up the browser.

## Configuration

Your OpenClaw configuration is stored in the `config/` directory (ignored by git).
The agent's memory and workspace are stored in `workspace/`.

### Port Configuration

Set host ports in your `.env` file (recommended) to avoid compose warnings and ensure stable localhost bindings.

Add the following to your `.env`:
```env
OPENCLAW_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
BROWSERLESS_PORT=3000
```

### Nix Configuration (Inside Container)

The `openclaw` image includes single-user Nix for the `node` user:

- Installed with `--no-daemon`
- Nix sandbox disabled via `/home/node/.config/nix/nix.conf`
- Nix binary available on `PATH` at `/home/node/.nix-profile/bin`

Verify inside the container:

```bash
docker compose exec openclaw bash -lc 'which nix && nix --version && nix config show | rg "^sandbox|^experimental-features"'
```

## Troubleshooting

- **"Pairing Required" (Error 1008):** See step 3 in Quick Start.
- **Gateway not accessible:** Ensure the container is running (`docker compose ps`) and listening on port `18789`.
- **Re-run Wizard:** If you need to reconfigure, run `./run_wizard.sh`.

## Contributing

Feel free to submit PRs!

## Disclaimer

This software is provided "as is" without warranty of any kind. OpenClaw is a powerful AI agent capable of executing commands and modifying files. **Use this software at your own risk.** The authors of this Docker wrapper are not responsible for any data loss or security incidents resulting from its use. Ensure you understand the capabilities of the agent before granting it extensive permissions.
