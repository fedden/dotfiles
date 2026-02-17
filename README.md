# dotfiles

Dev environment bootstrap for macOS and Linux (Ubuntu/Debian/Amazon Linux).

One command to set up a fresh machine:

```bash
curl -fsSL https://raw.githubusercontent.com/fedden/dotfiles/main/install.sh | bash
```

With GitHub auth:

```bash
curl -fsSL https://raw.githubusercontent.com/fedden/dotfiles/main/install.sh \
  | GITHUB_TOKEN=ghp_xxx bash
```

## What's included

| Tool | Config | Purpose |
|------|--------|---------|
| **neovim** | `config/nvim/` | Editor — Lua config, lazy.nvim, native LSP, treesitter |
| **tmux** | `tmux/tmux.conf` | Terminal multiplexer — session persistence, sourcerer theme |
| **zsh** | `shell/zshrc` | Shell — no framework, fast startup, fzf + zoxide |
| **starship** | `config/starship.toml` | Prompt — cross-shell, sourcerer palette |
| **git** | `git/gitconfig` | Git defaults |

### CLI tools installed

`eza` `bat` `fd` `fzf` `ripgrep` `zoxide` `starship` `gh`

### Language toolchains

`uv` (Python) | `nvm` (Node, lazy-loaded) | `rustup` (Rust)

### Colour scheme

Everything uses the [sourcerer](https://github.com/xero/sourcerer.vim) palette:

- Purple accent: `#a88af8`
- Sage green: `#87af87`
- Warm orange: `#d7875f`
- Warm grey: `#918175`

## Structure

```
config/
  nvim/          Neovim config (init.lua + lua/)
  starship.toml  Starship prompt
shell/
  zshrc          Zsh config (no oh-my-zsh)
  aliases        Shell aliases
  ignore         Global ripgrep/fd ignore patterns
tmux/
  tmux.conf      Tmux config
git/
  gitconfig      Git defaults
skills/
  nvim.md        Neovim reference
  tmux.md        Tmux reference
  shell.md       Shell/CLI reference
install.sh       Bootstrap script
```

## Private extensions

The install script and zshrc both source `~/.dotfiles.private.sh` if it exists. Use this for machine-specific or company-specific setup:

```bash
# ~/.dotfiles.private.sh (not tracked)
export SOME_API_KEY="..."
alias myproject="cd ~/work/myproject"
# Clone private repos, set up credentials, etc.
```

## CI

Nightly GitHub Actions workflow tests `install.sh` on Ubuntu and macOS. Verifies:

- All tools install and are on PATH
- Neovim starts and plugins load
- Symlinks are correct
- Zsh loads without errors

## Re-running

`install.sh` is idempotent — safe to re-run at any time. It skips steps that are already done and pulls the latest dotfiles.
