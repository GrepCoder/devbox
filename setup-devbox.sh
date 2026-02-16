#!/bin/bash
set -e  # Exit on error

echo "================================"
echo "GrepCoder DevBox Setup Script"
echo "================================"
echo ""

# Update system
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# Install essential tools
echo "🔧 Installing essential tools..."
sudo apt install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

# Install QEMU Guest Agent
echo "🖥️  Installing QEMU Guest Agent..."
sudo apt install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

# Install Docker
echo "🐳 Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group
    sudo usermod -aG docker $USER
    echo "✓ Docker installed successfully"
else
    echo "✓ Docker already installed"
fi

# Install Rust
echo "🦀 Installing Rust..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    echo "✓ Rust installed successfully"
else
    echo "✓ Rust already installed"
fi

# Ensure cargo is in PATH for this script
export PATH="$HOME/.cargo/bin:$PATH"

# Install cargo-run-script
echo "📜 Installing cargo-run-script..."
if ! cargo install --list | grep -q "cargo-run-script"; then
    cargo install cargo-run-script
    echo "✓ cargo-run-script installed successfully"
else
    echo "✓ cargo-run-script already installed"
fi

# Install Java (OpenJDK 21 LTS)
echo "☕ Installing Java..."
if ! command -v java &> /dev/null; then
    sudo apt install -y openjdk-21-jdk
    echo "✓ Java installed successfully"
else
    echo "✓ Java already installed"
fi

# Install Node.js (via NodeSource - Latest LTS v22)
echo "📗 Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "✓ Node.js installed successfully"
else
    echo "✓ Node.js already installed"
fi

# Install Tailscale
echo "🔗 Installing Tailscale..."
if ! command -v tailscale &> /dev/null; then
    curl -fsSL https://tailscale.com/install.sh | sh
    echo "✓ Tailscale installed successfully"
    echo ""
    echo "⚠️  Run 'sudo tailscale up' to connect this machine to your Tailnet"
else
    echo "✓ Tailscale already installed"
fi

# Install Azure CLI
echo "☁️  Installing Azure CLI..."
if ! command -v az &> /dev/null; then
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    echo "✓ Azure CLI installed successfully"
else
    echo "✓ Azure CLI already installed"
fi

# Install Terraform
echo "🏗️  Installing Terraform..."
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y terraform
    echo "✓ Terraform installed successfully"
else
    echo "✓ Terraform already installed"
fi

# Install kubectl
echo "⚓ Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubectl
    echo "✓ kubectl installed successfully"
else
    echo "✓ kubectl already installed"
fi

# Install Google Cloud CLI
echo "☁️  Installing Google Cloud CLI..."
if ! command -v gcloud &> /dev/null; then
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    sudo apt update
    sudo apt install -y google-cloud-cli
    echo "✓ Google Cloud CLI installed successfully"
else
    echo "✓ Google Cloud CLI already installed"
fi

# Install and configure Zsh
echo "💻 Installing Zsh..."
if ! command -v zsh &> /dev/null; then
    sudo apt install -y zsh
    echo "✓ Zsh installed successfully"
else
    echo "✓ Zsh already installed"
fi

# Configure Zsh history
echo "⚙️  Configuring Zsh history..."
cat > "$HOME/.zshrc" <<'ZSHRC'
# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_ALL_DUPS   # Don't save duplicates
setopt HIST_IGNORE_SPACE      # Don't save commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove extra blanks
setopt INC_APPEND_HISTORY     # Add commands immediately

# Better history search with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Enable colors
autoload -U colors && colors

# Better prompt
PS1="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "

# Aliases
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Load cargo environment if it exists
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
ZSHRC

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as default shell..."
    sudo chsh -s $(which zsh) $USER
    echo "✓ Zsh configured with history and set as default shell"
else
    echo "✓ Zsh already configured"
fi

# Install Mutagen (for file syncing if needed)
echo "🔄 Installing Mutagen..."
if ! command -v mutagen &> /dev/null; then
    wget https://github.com/mutagen-io/mutagen/releases/download/v0.17.6/mutagen_linux_amd64_v0.17.6.tar.gz
    sudo tar -xzf mutagen_linux_amd64_v0.17.6.tar.gz -C /usr/local/bin
    rm mutagen_linux_amd64_v0.17.6.tar.gz
    echo "✓ Mutagen installed successfully"
else
    echo "✓ Mutagen already installed"
fi

echo ""
echo "================================"
echo "✅ Setup Complete!"
echo "================================"
echo ""
echo "Installed versions:"
echo "  Docker:      $(docker --version)"
echo "  Rust:        $(rustc --version)"
echo "  Cargo:       $(cargo --version)"
echo "  Java:        $(java --version | head -1)"
echo "  Node.js:     $(node --version)"
echo "  npm:         $(npm --version)"
echo "  Tailscale:   $(tailscale --version)"
echo "  Azure CLI:   $(az --version | head -1)"
echo "  Terraform:   $(terraform --version | head -1)"
echo "  kubectl:     $(kubectl version --client --short 2>/dev/null || echo 'kubectl installed')"
echo "  Google Cloud: $(gcloud --version | head -1)"
echo "  Zsh:         $(zsh --version)"
echo ""
echo "⚠️  IMPORTANT:"
echo "  1. Log out and back in for Docker group membership to take effect"
echo "  2. Run 'sudo tailscale up' to connect to your Tailnet"
echo "  3. Reboot recommended: sudo reboot"
echo ""
