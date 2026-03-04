# DevBox Setup Scripts

Automated development environment setup scripts for quick VM/server provisioning.

## Quick Start

Run this one-liner on a fresh Ubuntu installation:

```bash
curl -sSL https://raw.githubusercontent.com/GrepCoder/devbox/main/setup-devbox.sh | bash
```

## What Gets Installed

✅ **Docker** - Latest stable with Docker Compose
✅ **Rust** - Via rustup (latest stable)
✅ **cargo-run-script** - For running project scripts
✅ **Java** - OpenJDK 21 LTS
✅ **Node.js** - v22 LTS
✅ **Tailscale** - For remote access
✅ **Azure CLI** - For Azure cloud management
✅ **Terraform** - Infrastructure as Code
✅ **kubectl** - Kubernetes CLI
✅ **Helm** - Kubernetes package manager
✅ **GitHub CLI** - GitHub from the command line
✅ **Google Cloud CLI** - For GCP management
✅ **OpenCode** - AI coding assistant (runs as a system service on port 4096)
✅ **Zsh** - Modern shell with history configuration
✅ **QEMU Guest Agent** - For Proxmox integration
✅ **Mutagen** - For file syncing

## Post-Installation

After the script completes:

1. **Connect Tailscale**:
   ```bash
   sudo tailscale up
   ```

2. **Reboot** (recommended):
   ```bash
   sudo reboot
   ```

3. **Verify installations**:
   ```bash
   docker --version
   rustc --version
   node --version
   java --version
   az --version
   terraform --version
   kubectl version --client
   helm version --short
   gh --version
   gcloud --version
   zsh --version
   opencode --version
   ```

5. **OpenCode server** (AI assistant, auto-starts on boot):
   ```bash
   sudo systemctl status opencode-server
   # Access at http://<server-ip>:4096
   ```

6. **Start using Zsh** (after reboot, Zsh will be your default shell):
   - History is configured with 10,000 entries
   - Arrow keys search through history intelligently
   - Shared history between terminal sessions

## Manual Installation

If you prefer to review before running:

```bash
# Download the script
curl -sSL https://raw.githubusercontent.com/nhlbo/devbox/main/setup-devbox.sh -o setup-devbox.sh

# Review it
cat setup-devbox.sh

# Make executable and run
chmod +x setup-devbox.sh
./setup-devbox.sh
```

## Requirements

- Ubuntu 22.04 LTS or newer
- `sudo` privileges
- Internet connection

## License

MIT
