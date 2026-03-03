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

# Nix Setup
RUN apt-get install -y nix-setup-systemd
RUN adduser node nix-users


# Switch to 'node' user
USER node
ENV HOME=/home/node
WORKDIR /home/node

# Install OpenClaw
ENV PATH="/home/node/.npm-global/bin:$PATH"
RUN curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard 

# Nix Envs
ENV PATH=$PATH:$HOME/.nix-profile/bin\
ENV XDG_DATA_DIRS="$HOME/.nix-profile/bin:$HOME/.nix-profile/share:$XDG_DATA_DIRS"

WORKDIR /app/openclaw

CMD ["bash"]
