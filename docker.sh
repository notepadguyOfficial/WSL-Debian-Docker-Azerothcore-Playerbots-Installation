#!/bin/bash

set -e
set -o pipefail

echo "[*] Updating system..."
sudo apt-get update && sudo apt-get dist-upgrade -y

echo "[*] Installing base packages..."
sudo apt-get install -y ca-certificates curl wget gnupg lsb-release apt-transport-https

# Only install genie if not already present
if ! command -v genie &> /dev/null; then
    echo "[*] Setting up WSL genie (if running in WSL)..."
    sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
    sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg

    echo -e "deb https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main\n\
deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/wsl-transdebian.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y systemd-genie

    echo 'genie -i' >> ~/.bashrc
else
    echo "✔️  Genie already installed."
fi

# Docker check and install if not already installed
if ! command -v docker &> /dev/null; then
    echo "[*] Docker not found. Installing Docker..."

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
        https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER

    echo "✔️  Docker installed. Please log out and back in to apply group changes."
    exit 1
else
    echo "✔️  Docker is already installed."
fi

# Optional: Install docker-compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "[*] Installing docker-compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/2.32.4/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "✔️  docker-compose is already installed."
fi

echo "✅ System preparation complete."
