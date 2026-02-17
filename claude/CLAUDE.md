# Personal Preferences

## Language & Style
- **British English** in all code, comments, documentation, and user-facing copy (e.g. "colour" not "color", "optimise" not "optimize", "behaviour" not "behavior")
- Concise output — don't over-explain
- No emojis unless explicitly requested

## Toolchain
- **Python:** uv (not pip), Python 3.13, ruff for linting/formatting, ty for type checking
- **Editor:** neovim 0.11 with native LSP (`vim.lsp.config()` / `vim.lsp.enable()`), lazy.nvim
- **Shell:** zsh (no oh-my-zsh), starship prompt, fzf + zoxide
- **Terminal multiplexer:** tmux with TPM
- **Git:** main branch convention varies by project — check before assuming
- **Node:** nvm (lazy-loaded), prefer npm
- **Infrastructure:** Terraform, Docker

## Coding
- Prefer simple, direct solutions — avoid over-engineering
- Don't add comments unless the logic isn't self-evident
- In Python, use type hints and follow ruff's `select = ["ALL"]` convention
- Tests with pytest; use markers for slow tests
