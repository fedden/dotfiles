---
name: shell
description: Shell and CLI tools reference — zsh config, modern CLI replacements (eza, bat, fd, fzf, zoxide, starship), aliases, keybindings. Use when answering questions about shell setup, aliases, or CLI tools.
user-invocable: true
---

# Shell Skills Reference

Zsh config without oh-my-zsh. Config lives in `~/.zshrc`, aliases in `~/.aliases`, prompt in `~/.config/starship.toml`.

---

## Modern CLI Tools

| Tool | Replaces | What it does |
|------|----------|-------------|
| `eza` | `ls` | File listing with colours, git status, tree view |
| `bat` | `cat` | Syntax-highlighted file viewer with line numbers |
| `fd` | `find` | Fast file finder, respects .gitignore |
| `zoxide` | `cd` | Smart directory jumper — learns from your habits |
| `fzf` | — | Fuzzy finder for files, history, directories |
| `ripgrep` | `grep` | Fast content search, respects .gitignore |
| `starship` | p10k/oh-my-zsh | Cross-shell prompt, single toml config |

## Aliases

### File listing (eza)

| Alias | Command | What it does |
|-------|---------|-------------|
| `ls` | `eza --group-directories-first` | Coloured listing, dirs first |
| `ll` | `eza -la --git` | Long listing with git status |
| `la` | `eza -a` | All files including hidden |
| `lt` | `eza -la --sort=modified` | Sort by modification time |
| `tree` | `eza --tree --level=3` | Tree view, 3 levels deep |

### File viewing (bat)

| Alias | Command | What it does |
|-------|---------|-------------|
| `cat` | `bat --paging=never` | Syntax-highlighted, no pager |
| `catp` | `bat` | With pager (scrollable) |

### File finding (fd)

| Alias | Command | What it does |
|-------|---------|-------------|
| `ff` | `fd --type f` | Find files |
| `fdir` | `fd --type d` | Find directories |

fd respects `.gitignore` and `~/.ignore` by default. Examples:

```bash
ff "test_.*\.py"              # Find Python test files
ff config --extension toml    # Find .toml files named "config"
fdir node_modules -H          # Find hidden dirs too (-H)
```

### Smart navigation (zoxide)

| Alias | Command | What it does |
|-------|---------|-------------|
| `cd` | `z` | Jump to best-matching directory |
| `cdi` | `zi` | Interactive picker with fzf |

zoxide learns from your `cd` usage. After visiting a directory a few times:

```bash
cd myproject       # jumps to ~/dev/myproject
cd frontend        # jumps to ~/dev/myproject/frontend
cd terraform       # jumps to ~/dev/myproject/infra
cdi                # interactive: fuzzy-find all known directories
```

**Tip:** zoxide ranks by "frecency" (frequency + recency). Directories you visit often and recently rank highest.

### Git

| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gl` | `git log --oneline -20` |
| `glg` | `git log --oneline --graph --all -30` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git pull` |
| `gf` | `git fetch --all --prune` |

### Tmux

| Alias | Command |
|-------|---------|
| `ta <name>` | Attach to session |
| `tn <name>` | New named session |
| `tls` | List sessions |
| `tk <name>` | Kill session |

### Utilities

| Alias | What it does |
|-------|-------------|
| `reload` | Re-source ~/.zshrc |
| `path` | Show PATH entries, one per line |
| `ports` | Show listening TCP ports |
| `myip` | Show public IP |
| `weather` | Current weather |

---

## fzf Key Bindings

| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy search shell history |
| `Ctrl+T` | Fuzzy find files (insert path at cursor) |
| `Alt+C` | Fuzzy find directories (cd into selection) |

fzf uses `fd` under the hood (respects `.gitignore` and `~/.ignore`). Colours match the sourcerer theme.

**Tip:** `Ctrl+R` is the single most useful fzf binding. Start typing any fragment of a previous command and it finds it instantly. Much better than `history | grep`.

---

## Starship Prompt

The prompt shows contextual information — only what's relevant to the current directory:

```
~/dev/myproject  main ~1 ?2  3.13 (.venv)
>
```

| Segment | When it appears | Colour |
|---------|----------------|--------|
| Directory | Always | White (`#c2c2b0`) |
| Git branch | In git repos | Sage green (`#87af87`) |
| Git status | When dirty | Warm orange (`#d7875f`) |
| Python version + venv | In Python projects | Teal (`#87afaf`) |
| Node version | In Node projects | Green (`#87af87`) |
| Terraform version | In Terraform dirs | Purple (`#a88af8`) |
| Rust version | In Rust projects | Orange (`#d7875f`) |
| Command duration | When >3 seconds | Grey (`#918175`) |
| Prompt character | Always | Purple `>` (red on error) |

**Git status symbols:** `~` modified, `?` untracked, `+` staged, `-` deleted, `^N` ahead, `vN` behind.

Config: `~/.config/starship.toml`

---

## Shell Options

| Option | What it does |
|--------|-------------|
| `AUTO_CD` | Type a directory name to cd into it (no `cd` needed) |
| `SHARE_HISTORY` | History shared across all terminal sessions |
| `HIST_IGNORE_ALL_DUPS` | No duplicate history entries |
| `EXTENDED_GLOB` | Advanced globbing patterns |

History: 50,000 entries, deduplicated, shared across sessions, saved to `~/.zsh_history`.

---

## Completion

- **Case-insensitive** — `cd proj<Tab>` matches `project/`
- **Menu-driven** — Tab cycles through options, arrow keys to navigate
- **Grouped** — completions are grouped by type with purple headers
- **Partial matching** — `cd m-p<Tab>` can match `my-project`

Completion cache rebuilds once per day (fast startup).

---

## Zsh Plugins

| Plugin | Source | What it does |
|--------|--------|-------------|
| zsh-autosuggestions | brew | Ghost-text suggestions from history (right arrow to accept) |
| zsh-syntax-highlighting | brew | Colours commands as you type: green = valid, red = invalid |

**Tip:** Autosuggestions show a grey ghost of the most recent matching command. Press `Right arrow` or `End` to accept the whole suggestion, or `C-f` to accept one word at a time.

---

## Lazy Loading

nvm is lazy-loaded — it only initialises when you first run `nvm`, `node`, `npm`, or `npx`. This saves ~500ms on every shell startup. You won't notice any difference in usage.

---

## Tips

### Use history aggressively

`Ctrl+R` with fzf is your best friend. You'll never need to remember exact commands again. Start typing any fragment — a filename, a flag, part of a command — and fzf finds it.

Up/Down arrows also do prefix search: type `git` then press Up to cycle through recent git commands.

### Use zoxide instead of bookmarks

Stop typing full paths. After you've visited a directory a few times, just type `cd <fragment>`:

```bash
cd proj       # -> ~/dev/myproject
cd front      # -> ~/dev/myproject/frontend
cd terra      # -> ~/dev/myproject/infra (or wherever you go most)
```

### Pipe into bat

```bash
git diff | bat -l diff         # Syntax-highlighted diff
curl -s api.example.com | bat -l json  # Pretty JSON
rg "TODO" | bat                # Highlighted search results
```

### fd + fzf combo

```bash
nvim $(fd -t f "test_" | fzf)        # Find and open a test file
cd $(fd -t d | fzf)                    # Find and cd into a directory
bat $(fd -e py | fzf --preview 'bat --color=always {}')  # Preview files
```

### Quick directory stack

`AUTO_PUSHD` means every `cd` pushes onto a stack:

```bash
cd ~/dev/myproject/backend
cd ~/dev/myproject/frontend
cd -        # back to backend (like browser back button)
dirs -v     # show the full stack with numbers
cd ~2       # jump to stack entry 2
```
