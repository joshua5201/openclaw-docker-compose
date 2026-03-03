FROM node:22-trixie

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basics 
RUN apt-get update && apt-get install -y \
    git curl wget vim nano zip xz-utils unzip \
    ca-certificates gnupg lsb-release \
    python3 python3-pip jq build-essential procps file

# Install browser deps
RUN apt-get install -y \
    libgbm1 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libxkbcommon0 libxcomposite1 libxdamage1 libxext6 libxfixes3 \
    libxrandr2 libpango-1.0-0 libcairo2 libasound2t64

# Prepare /nix for single-user installation
RUN mkdir -p /nix && chown -R node:node /nix

# Switch to 'node' user
USER node
ENV HOME=/home/node
WORKDIR /home/node

# Install Nix (single-user, no daemon) and configure sandbox off
ENV NIX_INSTALLER_NO_MODIFY_PROFILE=1
ENV NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
RUN curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon
RUN mkdir -p /home/node/.config/nix && \
    printf "sandbox = false\nexperimental-features = nix-command flakes\n" > /home/node/.config/nix/nix.conf

# Install OpenClaw
ENV PATH="/home/node/.nix-profile/bin:/home/node/.npm-global/bin:$PATH"
RUN curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard 

WORKDIR /app/openclaw

CMD ["bash"]
