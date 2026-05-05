# Microsoft's official "full" Ubuntu 24.04 image
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Pull in Docker's built-in target architecture variable
ARG TARGETARCH

# 1. Install Python 3 and venv dependencies (as root)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# 2. Create a global virtual environment and set permissions
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV \
    && chown -R vscode:vscode $VIRTUAL_ENV

# 3. Add venv to the PATH so 'python' and 'pip' always use it
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# 4. Download and install VS Code CLI
RUN if [ "$TARGETARCH" = "arm64" ]; then \
        VSCODE_ARCH="cli-linux-arm64"; \
    elif [ "$TARGETARCH" = "amd64" ]; then \
        VSCODE_ARCH="cli-linux-x64"; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi \
    && curl -sSL "https://update.code.visualstudio.com/latest/${VSCODE_ARCH}/stable" -o /tmp/vscode_cli.tar.gz \
    && tar -xf /tmp/vscode_cli.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/code \
    && rm /tmp/vscode_cli.tar.gz

# 5. Configure VS Code to use this venv by default in the UI
# We do this by creating a default settings file for the vscode user
RUN mkdir -p /home/vscode/.vscode-remote/data/Machine/ \
    && echo '{"python.defaultInterpreterPath": "/opt/venv/bin/python"}' \
    > /home/vscode/.vscode-remote/data/Machine/settings.json \
    && chown -R vscode:vscode /home/vscode/.vscode-remote

# Use the pre-configured 'vscode' user
USER vscode
WORKDIR /workspace

# Expose the web port
EXPOSE 8000

# Start the web server
CMD ["code", "serve-web", "--host", "0.0.0.0", "--port", "8000", "--accept-server-license-terms", "--without-connection-token"]
