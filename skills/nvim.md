# Neovim Skills Reference

Quick reference for the modernised nvim + tmux setup. Config lives in `~/.config/nvim/`.

## Navigation

| Key | Action | Plugin |
|-----|--------|--------|
| `,b` | Find files (fuzzy) | fzf.vim `:Files` |
| `,n` | Search file contents (ripgrep) | fzf.vim `:Rg` |
| `,m` | Search current buffer lines | fzf.vim `:BLines` |
| `gd` | Go to definition | LSP |
| `gr` | Find all references | LSP |
| `K` | Hover docs / type info | LSP |
| `C-h/j/k/l` | Navigate between vim splits and tmux panes | vim-tmux-navigator |
| `,]` / `,[` | Next / previous buffer | built-in |
| `:Ex` | Open file explorer (netrw) | built-in |

## Editing

| Key | Action | Plugin |
|-----|--------|--------|
| `gcc` | Toggle comment on line | Comment.nvim |
| `gc` (visual) | Toggle comment on selection | Comment.nvim |
| `cs'"` | Change surrounding `'` to `"` | nvim-surround |
| `ds"` | Delete surrounding `"` | nvim-surround |
| `ysiw)` | Surround word with `()` | nvim-surround |
| `C-n` / `C-p` | Navigate completion menu | nvim-cmp |
| `CR` | Confirm completion | nvim-cmp |
| `C-Space` | Trigger completion manually | nvim-cmp |
| `Tab` | Accept Copilot ghost text | copilot.vim |
| `C-e` | Dismiss completion menu | nvim-cmp |

## Multi-cursor

| Key | Action |
|-----|--------|
| `C-n` (normal) | Select word under cursor, repeat to add next match |
| `C-Down/Up` | Add cursor below/above |
| `q` | Skip current match, go to next |
| `Q` | Remove current cursor |

Note: vim-visual-multi — see `:help visual-multi` for full docs.

## Diagnostics & LSP

| Key | Action |
|-----|--------|
| `,l` | Show diagnostics for current line (floating window) |
| `,q` | Send all diagnostics to location list |
| `[d` / `]d` | Jump to previous / next diagnostic |
| `,rn` | Rename symbol under cursor |
| `,ca` | Code action (quick fix, refactor) |
| `,f` | Format buffer (ruff for .py, eslint for .ts, clangd for .c, terraformls for .tf) |

## Git

| Key / Command | Action | Plugin |
|---------------|--------|--------|
| Signs in gutter | `+` added, `~` changed, `_` deleted | gitsigns.nvim |
| `:Git blame` | Inline git blame | vim-fugitive |
| `:Git log` | Git log | vim-fugitive |
| `:Git diff` | Git diff in vim | vim-fugitive |

## vim-slime (send to tmux REPL)

| Key | Action |
|-----|--------|
| `C-c C-c` | Send current paragraph to tmux pane |
| `C-c v` | Reconfigure target tmux pane |

First use will prompt for target pane (e.g. `{right-of}`). Useful for sending Python to an ipython session.

## Escape behaviour

Pressing `Esc` in normal mode clears: search highlights, quickfix window, and preview window. Muscle memory from the old config — double-escape if something doesn't clear.

## Arrow keys

Disabled in normal mode. Use `h/j/k/l`.

---

## Tips & Techniques

### Motions — the vim superpower

Vim commands follow a grammar: **verb + noun**. Learn the nouns (motions/text objects) and every verb works with them.

**Verbs:** `d` (delete), `c` (change), `y` (yank/copy), `v` (visual select), `>` (indent), `<` (dedent), `gU` (uppercase), `gu` (lowercase)

**Nouns (motions):**

| Motion | Meaning | Example with `d` |
|--------|---------|-------------------|
| `w` / `W` | Next word / WORD (includes punctuation) | `dw` — delete to next word |
| `b` / `B` | Back a word / WORD | `db` — delete back a word |
| `e` | End of word | `de` — delete to end of word |
| `0` / `$` | Start / end of line | `d$` — delete to end of line |
| `^` | First non-blank character | `d^` — delete to first non-blank |
| `gg` / `G` | Top / bottom of file | `dG` — delete to end of file |
| `{` / `}` | Previous / next blank line (paragraph) | `d}` — delete to next blank line |
| `%` | Matching bracket/paren | `d%` — delete to matching bracket |
| `f<char>` / `t<char>` | Find / till character on line | `dt)` — delete till `)` |
| `/<pattern>` | Search forward | `d/def` — delete up to next `def` |

**Text objects** (use with `i` for inner, `a` for around):

| Object | Meaning | Example |
|--------|---------|---------|
| `iw` / `aw` | Inner word / a word (includes space) | `ciw` — change inner word |
| `i"` / `a"` | Inside quotes / including quotes | `ci"` — change inside quotes |
| `i(` / `a(` | Inside parens / including parens | `di(` — delete inside parens |
| `i{` / `a{` | Inside braces / including braces | `da{` — delete block including braces |
| `it` / `at` | Inside HTML tag / including tag | `cit` — change inside tag |
| `ip` / `ap` | Inner paragraph / a paragraph | `yap` — yank paragraph |
| `ii` / `ai` | Inner indent / an indent level | `dai` — delete indented block (treesitter) |

**Tip:** These all compose. `cs"'` (change surrounding `"` to `'`), `ysiw]` (surround word with `[]`), `gUiw` (uppercase word). Learning 5 verbs and 10 nouns gives you 50 commands.

### Repeating and undoing

| Key | Action |
|-----|--------|
| `.` | Repeat last change — the single most powerful key in vim |
| `u` / `C-r` | Undo / redo |
| `@:` | Repeat last ex command (`:` command) |
| `&` | Repeat last `:s` substitution |
| `;` / `,` | Repeat last `f`/`t` motion forward / backward |
| `n` / `N` | Repeat last search forward / backward |

**The dot formula:** Make a change that's repeatable, then use `.` to apply it everywhere. For example: `ciw` (change word) then type replacement, then `n` to find next occurrence, `.` to apply same change. This is often faster than multi-cursor or search-replace.

### Registers (clipboard slots)

Vim has 26 named registers (`a`-`z`) plus special ones:

| Register | What it holds |
|----------|---------------|
| `"` | Default (last delete/yank) |
| `+` | System clipboard (synced via `clipboard=unnamedplus`) |
| `0` | Last yank only (not affected by deletes) |
| `_` | Black hole — delete without overwriting register |
| `/` | Last search pattern |
| `.` | Last inserted text |
| `%` | Current filename |

**Usage:** `"ayw` yanks word into register `a`. `"ap` pastes from register `a`. `:reg` shows all registers.

**Common pattern:** You yank something, then delete something (which overwrites the default register), then want to paste the original yank. Use `"0p` to paste from the yank register, or `"_dd` to delete into the black hole without overwriting.

### Marks (bookmarks in code)

| Key | Action |
|-----|--------|
| `ma` | Set mark `a` at cursor position |
| `'a` | Jump to line of mark `a` |
| `` `a `` | Jump to exact position of mark `a` |
| `''` | Jump back to where you were before last jump |
| `` `` `` | Same but exact position |
| `:marks` | List all marks |

Lowercase marks (`a`-`z`) are per-buffer. Uppercase marks (`A`-`Z`) are global — set `mA` in one file and `` `A `` jumps there from anywhere. Useful for bouncing between two files you're editing together.

### Macros (record and replay)

| Key | Action |
|-----|--------|
| `qa` | Start recording into register `a` |
| `q` | Stop recording |
| `@a` | Play macro from register `a` |
| `@@` | Repeat last macro |
| `5@a` | Play macro 5 times |

**Tip:** Macros are stored in registers — `"ap` pastes the macro as text so you can edit it, then `"ayy` yanks it back. Start macros with `0` or `^` so they work from any cursor position.

### Splits and buffers

| Key / Command | Action |
|---------------|--------|
| `:vs <file>` | Vertical split |
| `:sp <file>` | Horizontal split |
| `C-w =` | Equalise split sizes |
| `C-w _` | Maximise current split height |
| `C-w \|` | Maximise current split width |
| `C-w r` | Rotate splits |
| `C-w T` | Move split to its own tab |
| `:ls` | List open buffers |
| `:b <partial>` | Switch buffer by partial name |
| `:bd` | Close current buffer |

**Workflow:** Use `,b` (fzf Files) to open files into buffers. Use `,]`/`,[` to cycle. Use splits when you need to see two files side by side. `C-h/j/k/l` moves between splits and tmux panes seamlessly.

### Search and replace

| Command | Action |
|---------|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `*` | Search for word under cursor (forward) |
| `#` | Search for word under cursor (backward) |
| `:s/old/new/` | Replace first on current line |
| `:s/old/new/g` | Replace all on current line |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace all in file with confirmation |
| `:'<,'>s/old/new/g` | Replace all in visual selection |

**Tip:** After searching with `/` or `*`, use `cgn` to change the next match, then `.` to repeat on subsequent matches. This is like a manual find-and-replace where you control each one — faster than `:%s` with `c` flag for scattered changes.

### The quickfix list

The quickfix list is a central list of locations — think of it as "search results you can jump through":

| Command | Action |
|---------|--------|
| `,q` | Send diagnostics to location list |
| `:Rg pattern` | Search results go to quickfix |
| `:cnext` / `:cprev` | Next / previous quickfix entry |
| `:copen` / `:cclose` | Open / close quickfix window |
| `gr` | LSP references go to quickfix |

**Workflow for bulk edits:** `:Rg old_name` to find all occurrences, then `:cdo s/old_name/new_name/g` to replace across all files in the quickfix list. Finish with `:cdo update` to save all changed files.

### Visual mode tricks

| Key | Action |
|-----|--------|
| `v` | Character-wise visual |
| `V` | Line-wise visual |
| `C-v` | Block (column) visual |
| `gv` | Re-select last visual selection |
| `o` | Move to other end of selection |

**Block visual (`C-v`) is underused:** Select a column, then `I` to insert at the start of each line, or `A` to append at the end. `d` deletes the column. Great for editing aligned data, adding/removing indentation on specific columns, or commenting out a block.

### Command-line tricks

| Command | Action |
|---------|--------|
| `:!cmd` | Run shell command |
| `:r !cmd` | Insert shell command output below cursor |
| `:.!cmd` | Filter current line through command |
| `:'<,'>!sort` | Sort visual selection |
| `:'<,'>!python3 -c "..."` | Filter selection through Python |
| `:earlier 5m` | Undo to 5 minutes ago |
| `:later 5m` | Redo to 5 minutes in the future |
| `C-a` / `C-x` | Increment / decrement number under cursor |

### Daily workflow recommendations

1. **Navigating code:** `gd` (go to definition) + `C-o` (jump back) is your bread and butter. `gr` (references) when you need to understand all callers.
2. **Quick edits:** `ciw` (change word), `ci"` (change inside quotes), `cc` (change entire line). Then `.` to repeat.
3. **Moving around a file:** `{`/`}` to jump by paragraph. `C-d`/`C-u` to scroll half-page. `zz` to centre screen on cursor.
4. **Opening files:** `,b` to fuzzy-find by name. `,n` to search by content. `:b <partial>` to switch to an already-open buffer.
5. **Fixing diagnostics:** `]d` to jump to next error, `,ca` for code action (auto-fix), `,f` to format.
6. **Bulk renames:** `,rn` for LSP rename (updates all references). For non-symbol renames, use quickfix + `:cdo`.
7. **Git:** `:Git blame` to find who changed a line. `:Git diff` to review before committing. Gutter signs show what you've changed.

---

## LSP Servers Installed

Managed by Mason (`:Mason` to check status), except ty which is configured manually:

| Server | Languages | Use case |
|--------|-----------|----------|
| ruff | Python (lint + format) | Python projects |
| ty | Python (type checking) | Python projects |
| ts_ls | TypeScript/JavaScript | TypeScript projects |
| eslint | TS/JS linting | TypeScript projects |
| clangd | C/C++ | C/C++ projects |
| cmake | CMake | C/C++ projects |
| rust_analyzer | Rust | Rust projects |
| terraformls | Terraform/HCL | Terraform configs |
| yamlls | YAML + GitHub Actions | YAML files, .github/workflows/ |
| jsonls | JSON | JSON files |
| dockerls | Dockerfile | Dockerised projects |
| lua_ls | Lua | ~/.config/nvim/ |

### .venv binary resolution

Both ruff and ty use a `find_venv_bin()` helper that runs at nvim startup:

1. Walks upward from cwd looking for `.venv/bin/<name>`
2. Checks immediate subdirectories (monorepo pattern)
3. Falls back to the bare name (Mason / PATH)

This ensures both tools match the exact versions pinned in `pyproject.toml`. ty is not in Mason — it comes from the project `.venv` only.

**Important:** Start nvim from the repo root (or a subdirectory containing `.venv/`) so the helper can find the binaries. Verify with `:checkhealth lsp`.

### How diagnostics work

- **ruff**: lint diagnostics (inline markers + floating window on CursorHold)
- **ty**: type-checking diagnostics in workspace mode (checks the whole project, not just open files)
- Diagnostic float appears after 300ms of cursor hold (set via `updatetime`)
- Float windows use sourcerer-matching colours (dark grey background, not black)

### How formatting works

`,f` calls `vim.lsp.buf.format()` which delegates to the right server:
- **Python**: ruff (respects `pyproject.toml` settings)
- **TypeScript**: eslint --fix (respects `eslint.config.mjs`)
- **C/C++**: clangd (uses clang-format)
- **Terraform**: terraform fmt
- **JSON/YAML**: jsonls / yamlls

### GitHub Actions support

yamlls provides schema-based completion and validation for:
- `.github/workflows/*.yml` — workflow files (jobs, steps, `runs-on`, `uses`, etc.)
- `action.yml` / `action.yaml` — action definition files

---

## Treesitter Parsers

Syntax highlighting via treesitter for: python, lua, javascript, typescript, tsx, rust, c, cpp, cmake, html, css, json, yaml, toml, bash, markdown, markdown_inline, terraform, hcl, dockerfile, sql, make.

---

## Completion Stack

No conflicts (the old config had three competing completers):

| Layer | What it does | Trigger |
|-------|-------------|---------|
| nvim-cmp | Popup menu: LSP symbols, buffer words, file paths, snippets | `C-n`/`C-p` to navigate, `CR` to confirm |
| copilot.vim | Inline ghost text suggestions | `Tab` to accept |
| LSP | Feeds into nvim-cmp via cmp-nvim-lsp | Automatic |

These don't conflict: cmp owns the popup menu (`C-n`/`C-p`/`CR`), copilot owns ghost text (`Tab`).

---

## fzf Ignore Rules

Both `:Files` and `:Rg` respect:
1. `.gitignore` (per-repo, automatic)
2. `~/.ignore` (global — `.venv`, `node_modules`, `__pycache__`, `build/`, `.terraform/`, etc.)
3. `.ignore` in any project root (project-specific overrides)

`:Files` uses `rg --files --hidden` under the hood (set via `FZF_DEFAULT_COMMAND`).

---

## Tmux

### Key bindings

| Key | Action |
|-----|--------|
| `prefix + \|` | Split pane horizontally (inherits cwd) |
| `prefix + -` | Split pane vertically (inherits cwd) |
| `prefix + c` | New window (inherits cwd) |
| `C-h/j/k/l` | Navigate panes (shared with nvim splits) |
| `prefix + I` | Install tmux plugins (TPM) |

### Status bar (sourcerer theme)

Left: `[session name]` — Right: `git-branch | hostname | HH:MM`

Hostname is visible so you know which devbox you're on when SSH'd.

### Session persistence

- **tmux-resurrect**: saves/restores sessions (pane layout, working directories, running programs)
- **tmux-continuum**: auto-saves every 15 minutes, auto-restores on tmux start

Sessions survive devbox reboots. Manual save: `prefix + C-s`. Manual restore: `prefix + C-r`.

### Terminal colours

True colour enabled (`tmux-256color` + RGB). Nvim colourscheme renders correctly inside tmux.

---

## Config File Layout

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua         # vim.opt settings, filetype indentation
│   │   ├── lazy.lua            # lazy.nvim bootstrap
│   │   └── keymaps.lua         # Non-plugin keybindings
│   └── plugins/
│       ├── colourscheme.lua    # sourcerer.vim
│       ├── lsp.lua             # Mason + LSP servers + keymaps
│       ├── cmp.lua             # nvim-cmp completion
│       ├── treesitter.lua      # Syntax highlighting
│       ├── fzf.lua             # Fuzzy finding (fzf.vim)
│       ├── git.lua             # fugitive + gitsigns
│       ├── editor.lua          # Comment, surround, slime, multi-cursor
│       ├── ui.lua              # lualine (sourcerer theme)
│       ├── copilot.lua         # GitHub Copilot
│       └── tmux.lua            # vim-tmux-navigator
~/.tmux.conf                    # Tmux config
~/.ignore                       # Global ripgrep ignore patterns
```

## Backups

Old configs backed up at:
- `~/.vimrc.bak`
- `~/.config/nvim/init.vim.bak`
- `~/.tmux.conf.bak`

Restore with: `cp ~/.vimrc.bak ~/.vimrc && cp ~/.config/nvim/init.vim.bak ~/.config/nvim/init.vim && rm ~/.config/nvim/init.lua && cp ~/.tmux.conf.bak ~/.tmux.conf`

---

## Upgrades performed

- neovim: 0.9.5 -> 0.11.6
- tree-sitter CLI: 0.20.9 -> 0.26.5
- ripgrep: installed 15.1.0 (was only available as Claude Code alias)
- TPM: installed (was declared but missing)
