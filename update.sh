#!/usr/bin/env bash
# Update all dotfiles-managed tools to their latest versions.
# Safe to re-run at any time.
set -euo pipefail

info()  { printf "\033[1;34m[update]\033[0m %s\n" "$*"; }
ok()    { printf "\033[1;32m[update]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[update]\033[0m %s\n" "$*"; }

command_exists() { command -v "$1" &>/dev/null; }

# ── Dotfiles repo ─────────────────────────────────────────────
DOTFILES_DIR="$HOME/dev/dotfiles"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Pulling latest dotfiles..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Could not pull (maybe dirty)"
    ok "Dotfiles updated"
else
    warn "Dotfiles repo not found at $DOTFILES_DIR, skipping"
fi

# ── Brew ──────────────────────────────────────────────────────
if command_exists brew; then
    info "Updating brew packages..."
    brew update
    outdated=$(brew outdated 2>/dev/null || true)
    if [[ -n "$outdated" ]]; then
        echo "$outdated"
        brew upgrade
        ok "Brew packages upgraded"
    else
        ok "Brew packages already up to date"
    fi
    brew cleanup --prune=7 2>/dev/null || true
else
    warn "brew not found, skipping"
fi

# ── uv ────────────────────────────────────────────────────────
if command_exists uv; then
    info "Updating uv..."
    uv self update 2>/dev/null || warn "uv self update not available (install via curl to enable)"
    ok "uv: $(uv --version)"
else
    warn "uv not found, skipping"
fi

# ── Rust ──────────────────────────────────────────────────────
if command_exists rustup; then
    info "Updating Rust..."
    rustup update stable
    ok "Rust: $(rustc --version)"
else
    warn "rustup not found, skipping"
fi

# ── Claude Code ───────────────────────────────────────────────
if command_exists claude; then
    info "Updating Claude Code..."
    # Ensure nvm/node is available
    export NVM_DIR="$HOME/.nvm"
    if [[ -s "$NVM_DIR/nvm.sh" ]]; then source "$NVM_DIR/nvm.sh"; fi
    npm update -g @anthropic-ai/claude-code
    ok "Claude Code: $(claude --version 2>/dev/null || echo 'updated')"
else
    warn "claude not found, skipping"
fi

# ── Neovim plugins ────────────────────────────────────────────
if command_exists nvim; then
    info "Updating nvim plugins..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || warn "Lazy sync had issues"
    ok "Nvim plugins updated"
else
    warn "nvim not found, skipping"
fi

# ── Tmux plugins ─────────────────────────────────────────────
TPM_UPDATE="$HOME/.tmux/plugins/tpm/bin/update_plugins"
if [[ -x "$TPM_UPDATE" ]]; then
    info "Updating tmux plugins..."
    "$TPM_UPDATE" all || warn "TPM update failed (tmux may not be running)"
    ok "Tmux plugins updated"
else
    warn "TPM not found, skipping"
fi

# ── Summary ──────────────────────────────────────────────────
echo ""
ok "========================================="
ok "  All tools updated!"
ok "========================================="
echo ""
info "Tool versions:"
command_exists nvim     && info "  nvim:     $(nvim --version | head -1)"
command_exists tmux     && info "  tmux:     $(tmux -V)"
command_exists rg       && info "  rg:       $(rg --version | head -1)"
command_exists fzf      && info "  fzf:      $(fzf --version | head -1)"
command_exists fd       && info "  fd:       $(fd --version)"
command_exists eza      && info "  eza:      $(eza --version | head -1)"
command_exists bat      && info "  bat:      $(bat --version)"
command_exists starship && info "  starship: $(starship --version)"
command_exists uv       && info "  uv:       $(uv --version)"
command_exists rustc    && info "  rustc:    $(rustc --version)"
command_exists gh       && info "  gh:       $(gh --version | head -1)"
