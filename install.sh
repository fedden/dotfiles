#!/usr/bin/env bash
# Dotfiles bootstrap script — idempotent, cross-platform (macOS + Ubuntu/Debian).
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/fedden/dotfiles/main/install.sh | bash
#   GITHUB_TOKEN=ghp_xxx ./install.sh          # optional: set up gh auth
#
# Re-running is safe — each step checks if it's already done.
set -euo pipefail

DOTFILES_REPO="https://github.com/fedden/dotfiles.git"
DOTFILES_DIR="$HOME/dev/dotfiles"

# ── Helpers ─────────────────────────────────────────────────────
info()  { printf "\033[1;34m[dotfiles]\033[0m %s\n" "$*"; }
ok()    { printf "\033[1;32m[dotfiles]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[dotfiles]\033[0m %s\n" "$*"; }
err()   { printf "\033[1;31m[dotfiles]\033[0m %s\n" "$*" >&2; }

command_exists() { command -v "$1" &>/dev/null; }

# ── Detect OS ───────────────────────────────────────────────────
detect_os() {
    case "$(uname -s)" in
        Darwin) OS="macos" ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian) OS="debian" ;;
                    amzn)          OS="amazon" ;;
                    *)             OS="linux"  ;;
                esac
            else
                OS="linux"
            fi
            ;;
        *) err "Unsupported OS: $(uname -s)"; exit 1 ;;
    esac
    info "Detected OS: $OS"
}

# ── Install system package manager ──────────────────────────────
install_brew() {
    if command_exists brew; then
        ok "Homebrew already installed"
        return
    fi
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add to current PATH
    if [[ -d /opt/homebrew/bin ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

apt_install() {
    info "Installing apt packages: $*"
    sudo apt-get update -qq
    sudo apt-get install -y -qq "$@"
}

# ── Install packages ───────────────────────────────────────────
install_packages_macos() {
    install_brew
    local packages=(
        neovim tmux ripgrep fzf fd eza bat zoxide starship
        zsh-autosuggestions zsh-syntax-highlighting
        git gh tree-sitter
    )
    info "Installing brew packages..."
    brew install "${packages[@]}" 2>/dev/null || true
    ok "Brew packages installed"
}

install_packages_debian() {
    # System packages
    apt_install git curl wget unzip zsh build-essential

    # Install brew on Linux (easiest way to get latest nvim, eza, starship, etc.)
    install_brew
    local packages=(
        neovim tmux ripgrep fzf fd eza bat zoxide starship
        zsh-autosuggestions zsh-syntax-highlighting
        gh tree-sitter
    )
    info "Installing brew packages..."
    brew install "${packages[@]}" 2>/dev/null || true
    ok "Brew packages installed"
}

install_packages_amazon() {
    # Amazon Linux 2 — similar to RHEL
    sudo yum groupinstall -y "Development Tools" 2>/dev/null || true
    sudo yum install -y git curl wget unzip zsh 2>/dev/null || true
    install_brew
    local packages=(
        neovim tmux ripgrep fzf fd eza bat zoxide starship
        zsh-autosuggestions zsh-syntax-highlighting
        gh tree-sitter
    )
    info "Installing brew packages..."
    brew install "${packages[@]}" 2>/dev/null || true
    ok "Brew packages installed"
}

# ── Install language toolchains ─────────────────────────────────
install_uv() {
    if command_exists uv; then
        ok "uv already installed"
        return
    fi
    info "Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Source the env so uv is available in this session
    if [[ -f "$HOME/.local/bin/env" ]]; then source "$HOME/.local/bin/env"; fi
}

install_nvm() {
    if [[ -d "$HOME/.nvm" ]]; then
        ok "nvm already installed"
        return
    fi
    info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}

install_rust() {
    if command_exists rustc; then
        ok "Rust already installed"
        return
    fi
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
}

# ── Install Claude Code ─────────────────────────────────────────
install_claude_code() {
    if command_exists claude; then
        ok "Claude Code already installed"
        return
    fi
    info "Installing Claude Code..."
    # Ensure nvm/node is available
    export NVM_DIR="$HOME/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then source "$NVM_DIR/nvm.sh"; fi
    if ! command_exists node; then
        info "Installing Node.js via nvm (needed for Claude Code)..."
        nvm install --lts
    fi
    npm install -g @anthropic-ai/claude-code
    ok "Claude Code installed"
}

# ── Clone dotfiles ──────────────────────────────────────────────
clone_dotfiles() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        info "Dotfiles repo already cloned, pulling latest..."
        git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not pull (maybe dirty)"
    else
        info "Cloning dotfiles..."
        mkdir -p "$(dirname "$DOTFILES_DIR")"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
    ok "Dotfiles at $DOTFILES_DIR"
}

# ── Symlink dotfiles ───────────────────────────────────────────
link_file() {
    local src="$1" dst="$2"
    if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
        return  # already correct
    fi
    if [[ -e "$dst" ]]; then
        info "Backing up $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "Linked $dst -> $src"
}

symlink_dotfiles() {
    info "Symlinking dotfiles..."

    # Nvim config (whole directory)
    link_file "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

    # Starship
    link_file "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"

    # Shell
    link_file "$DOTFILES_DIR/shell/zshrc"   "$HOME/.zshrc"
    link_file "$DOTFILES_DIR/shell/aliases" "$HOME/.aliases"
    link_file "$DOTFILES_DIR/shell/ignore"  "$HOME/.ignore"

    # Tmux
    link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Git
    link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

    # Claude Code
    link_file "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    link_file "$DOTFILES_DIR/claude/skills/nvim" "$HOME/.claude/skills/nvim"
    link_file "$DOTFILES_DIR/claude/skills/tmux" "$HOME/.claude/skills/tmux"
    link_file "$DOTFILES_DIR/claude/skills/shell" "$HOME/.claude/skills/shell"

    ok "All dotfiles symlinked"
}

# ── Set up tmux plugin manager ──────────────────────────────────
setup_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        ok "TPM already installed"
    else
        info "Installing TPM (tmux plugin manager)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
    # Install tmux plugins non-interactively
    if [[ -x "$tpm_dir/bin/install_plugins" ]]; then
        info "Installing tmux plugins..."
        "$tpm_dir/bin/install_plugins" || warn "TPM install_plugins failed (tmux may not be running)"
    fi
}

# ── Set up nvim plugins ────────────────────────────────────────
setup_nvim() {
    if ! command_exists nvim; then
        warn "nvim not found, skipping plugin install"
        return
    fi
    info "Installing nvim plugins (headless)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Lazy sync had issues (may need manual run)"
    ok "Nvim plugins installed"
}

# ── Set up GitHub auth ──────────────────────────────────────────
setup_github_auth() {
    if [[ -z "${GITHUB_TOKEN:-}" ]]; then
        warn "No GITHUB_TOKEN set, skipping gh auth"
        return
    fi
    if ! command_exists gh; then
        warn "gh CLI not found, skipping auth"
        return
    fi
    info "Authenticating with GitHub..."
    # Temporarily unset GITHUB_TOKEN so gh reads the token from stdin
    # instead of conflicting with the env var (which causes it to hang
    # with an interactive prompt in non-tty environments).
    local token="$GITHUB_TOKEN"
    unset GITHUB_TOKEN
    if printf '%s\n' "$token" | gh auth login --with-token 2>&1; then
        gh auth setup-git < /dev/null
        ok "GitHub authenticated via gh"
    else
        # gh auth login can fail if the token lacks scopes (e.g. read:org).
        # Fall back to configuring git HTTPS credentials directly so that
        # git clone still works even without full gh CLI auth.
        warn "gh auth login failed — configuring git credentials directly"
        git config --global url."https://x-access-token:${token}@github.com/".insteadOf "https://github.com/"
        ok "Git HTTPS credentials configured"
    fi
    export GITHUB_TOKEN="$token"
}

# ── Set default shell to zsh ───────────────────────────────────
set_default_shell() {
    local zsh_path
    zsh_path="$(which zsh 2>/dev/null || true)"
    if [[ -z "$zsh_path" ]]; then
        warn "zsh not found, skipping default shell change"
        return
    fi
    if [[ "$SHELL" == "$zsh_path" ]]; then
        ok "Default shell is already zsh"
        return
    fi
    # Add to /etc/shells if not present
    if ! grep -qF "$zsh_path" /etc/shells 2>/dev/null; then
        info "Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
    fi
    info "Setting default shell to zsh..."
    # sudo chsh works without a password prompt; bare chsh needs PAM (hangs
    # without a tty), so we only fall back to it when stdin is a terminal.
    if sudo chsh -s "$zsh_path" "$(whoami)" 2>/dev/null; then
        ok "Default shell changed to zsh"
    elif [[ -t 0 ]] && chsh -s "$zsh_path"; then
        ok "Default shell changed to zsh"
    else
        warn "Could not change shell (do it manually: chsh -s $zsh_path)"
    fi
}

# ── fzf key bindings install ───────────────────────────────────
setup_fzf() {
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        ok "fzf shell integration already set up"
        return
    fi
    # Brew-installed fzf
    local fzf_install
    if [[ -f /opt/homebrew/opt/fzf/install ]]; then
        fzf_install="/opt/homebrew/opt/fzf/install"
    elif [[ -f /home/linuxbrew/.linuxbrew/opt/fzf/install ]]; then
        fzf_install="/home/linuxbrew/.linuxbrew/opt/fzf/install"
    fi
    if [[ -n "${fzf_install:-}" ]]; then
        info "Setting up fzf shell integration..."
        "$fzf_install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

# ── Private hook ────────────────────────────────────────────────
run_private_hook() {
    if [[ -f "$HOME/.dotfiles.private.sh" ]]; then
        info "Running private hook (~/.dotfiles.private.sh)..."
        source "$HOME/.dotfiles.private.sh"
    fi
}

# ── Main ────────────────────────────────────────────────────────
main() {
    info "Starting dotfiles bootstrap..."
    detect_os

    case "$OS" in
        macos)  install_packages_macos  ;;
        debian) install_packages_debian ;;
        amazon) install_packages_amazon ;;
        *)      warn "Unknown Linux distro, attempting brew-based install"
                install_packages_debian ;;
    esac

    install_uv
    install_nvm
    install_rust
    install_claude_code
    clone_dotfiles
    symlink_dotfiles
    setup_tpm
    setup_fzf
    setup_nvim
    setup_github_auth
    set_default_shell
    run_private_hook

    echo ""
    ok "========================================="
    ok "  Dotfiles bootstrap complete!"
    ok "========================================="
    echo ""
    info "Next steps:"
    info "  1. Open a new terminal (or: exec zsh)"
    info "  2. In tmux: prefix + I to finish plugin install"
    info "  3. In nvim: :checkhealth to verify"
    info "  4. In nvim: :Copilot auth (GitHub Copilot setup)"
    info "  5. Run: claude (to authenticate Claude Code)"
    info ""
    info "Private setup: create ~/.dotfiles.private.sh for"
    info "company-specific config (repo clones, credentials, etc.)"
}

main "$@"
