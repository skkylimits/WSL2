# syntax=docker/dockerfile:1.4
FROM ubuntu:22.04 AS base

# Setup environment
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    PATH="/root/.local/bin:/root/.cargo/bin:/root/go/bin:${PATH}"

# Deze layer wordt gecached! Nieuwe packages toevoegen rebuild alleen vanaf hier
FROM base AS apt-packages

# Mount APT cache (blijft bestaan tussen builds!)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y \
    # Core tools
    curl \
    wget \
    git \
    jq \
    # System utilities
    cmatrix \
    htop \
    nmap \
    net-tools \
    # Build essentials (voor pyenv)
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    # Docker dependencies
    ca-certificates \
    gnupg \
    lsb-release \
    # Voeg hier nieuwe APT packages toe:
    proxychains4 \
    && rm -rf /var/lib/apt/lists/*

# Docker installatie (separate stage voor flexibiliteit)
FROM apt-packages AS docker-install

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Shell configs (separate stage, cached)
FROM docker-install AS shell-config

RUN --mount=type=cache,target=/tmp/bashrc-cache \
    if [ ! -f /tmp/bashrc-cache/.bashrc ]; then \
      git clone https://github.com/skkylimits/.bashrc /tmp/bashrc-cache; \
    fi && \
    cp /tmp/bashrc-cache/.bashrc /root/.bashrc && \
    cp /tmp/bashrc-cache/.bash_aliases /root/.bash_aliases && \
    cp /tmp/bashrc-cache/.bash_logout /root/.bash_logout

# pyenv installatie (cached)
FROM shell-config AS pyenv-install

RUN --mount=type=cache,target=/root/.pyenv \
    if [ ! -d /root/.pyenv/.git ]; then \
      git clone https://github.com/pyenv/pyenv.git /root/.pyenv; \
    fi && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> /root/.bashrc

# Python LTS installatie (deze layer cachen!)
FROM pyenv-install AS python-install

ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

RUN --mount=type=cache,target=/root/.pyenv/cache \
    pyenv install 3.12.6 && \
    pyenv global 3.12.6 && \
    pip install --user --upgrade pip pipenv requests pipx

# nvm en Node.js (cached)
FROM python-install AS node-install

RUN --mount=type=cache,target=/root/.nvm \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . /root/.nvm/nvm.sh && \
    nvm install --lts

# pnpm (cached)
FROM node-install AS pnpm-install

RUN curl -fsSL https://get.pnpm.io/install.sh | sh - && \
    # Remove pnpm's .bashrc additions (we manage our own)
    sed -i '/# pnpm/,+2d' /root/.bashrc

# Final stage
FROM pnpm-install AS final

WORKDIR /workspace

# Copy scripts
COPY scripts/ /workspace/scripts/

CMD ["/bin/bash"]
