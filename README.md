# openclaw-docker-compose

A reproducible, isolated Docker environment for [OpenClaw](https://github.com/openclaw/openclaw) (formerly known as **Moltbot** and **Clawdbot**), designed to keep your host system clean and secure.

## Features

- **Single Container Architecture**: Runs both the Gateway and CLI tools in one isolated container.
- **Automated Setup**: One script (`./setup.sh`) handles cloning, building, dependencies, and configuration.
- **Isolated Workspace**: `node_modules` are kept in a Docker volume, keeping your local repo clean.
- **Non-Root Security**: Runs as a non-root `node` user (UID 1000) inside the container.
- **Persistent Storage**: Configuration and workspace data persist in local `config/` and `workspace/` directories.

## Prerequisites

- **Docker** and **Docker Compose** installed on your system.
- `git`

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
    *   Clone/update the OpenClaw source code into `./openclaw`.
    *   Build the Docker image.
    *   Install dependencies and compile the project.
    *   Launch the interactive **Onboarding Wizard**.
    *   Configure the gateway to listen on LAN (for Docker access).
    *   Start the gateway and provide your **Dashboard URL**.

3.  **Approve your Browser (Pairing):**
    OpenClaw requires you to approve new devices for security.
    If you see "Pairing Required" on the dashboard:
    
    1.  List pending requests:
        ```bash
        docker compose exec openclaw node openclaw.mjs devices list
        ```
    2.  Approve the request ID:
        ```bash
        docker compose exec openclaw node openclaw.mjs devices approve <ID>
        ```

## Usage

- **Start Gateway:** `docker compose up -d`
- **Stop Gateway:** `docker compose down`
- **View Logs:** `docker compose logs -f openclaw`
- **Open Shell:** `docker compose exec openclaw bash`

## Tips

- **Browser Setup:** When asking the agent to use a headless browser, tell it that it is executing inside a Docker sandbox. This informs the agent that it does not need to use additional sandbox mode when setting up the browser.

## Configuration

Your OpenClaw configuration is stored in the `config/` directory (ignored by git).
The agent's memory and workspace are stored in `workspace/`.

## Troubleshooting

- **"Pairing Required" (Error 1008):** See step 3 in Quick Start.
- **Gateway not accessible:** Ensure the container is running (`docker compose ps`) and listening on port `18789`.
- **Re-run Wizard:** If you need to reconfigure, run `./run_wizard.sh`.

## Disclaimer

This software is provided "as is" without warranty of any kind. OpenClaw is a powerful AI agent capable of executing commands and modifying files. **Use this software at your own risk.** The authors of this Docker wrapper are not responsible for any data loss or security incidents resulting from its use. Ensure you understand the capabilities of the agent before granting it extensive permissions.