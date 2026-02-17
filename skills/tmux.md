# Tmux Skills Reference

Quick reference for the modernised tmux setup. Config lives in `~/.tmux.conf`.

Prefix key is `C-b` (default).

---

## Pane Management

| Key | Action |
|-----|--------|
| `prefix + \|` | Split horizontally (inherits cwd) |
| `prefix + -` | Split vertically (inherits cwd) |
| `C-h/j/k/l` | Navigate panes (shared with nvim splits) |
| `prefix + z` | Zoom pane (toggle fullscreen) |
| `prefix + m` | Zoom pane (alias for z) |
| `prefix + R` | Respawn dead pane (restarts the process) |
| `prefix + x` | Kill current pane (with confirmation) |

### Resizing panes

| Key | Action |
|-----|--------|
| `prefix + Up/Down/Left/Right` | Resize by 5 cells (repeatable) |
| `prefix + S-Up/S-Down/S-Left/S-Right` | Resize by 1 cell (fine-tuning, repeatable) |
| Mouse drag on border | Resize with mouse |

**Tip:** The `-r` flag means these are repeatable — press prefix once, then tap the arrow key multiple times within 500ms without pressing prefix again.

## Window Management

| Key | Action |
|-----|--------|
| `prefix + c` | New window (inherits cwd) |
| `prefix + n` / `prefix + p` | Next / previous window |
| `prefix + 0-9` | Jump to window by number |
| `prefix + ,` | Rename current window |
| `prefix + &` | Kill current window |
| `prefix + w` | Visual window/session picker |

Windows auto-rename to the current directory name. They renumber automatically when closed (no gaps).

Activity in background windows shows as a highlighted tab — you won't miss output from long-running jobs.

## Session Management

| Key | Action |
|-----|--------|
| `prefix + s` | **fzf session switcher** — fuzzy-find with pane preview |
| `prefix + d` | Detach from session |
| `prefix + $` | Rename current session |

### fzf session switcher

`prefix + s` opens a popup with all sessions. Type to fuzzy-filter, arrow keys to navigate. The right side shows a preview of the session's current pane. Press Enter to switch, Esc to cancel.

### Session persistence

| Key | Action |
|-----|--------|
| `prefix + C-s` | Manual save (tmux-resurrect) |
| `prefix + C-r` | Manual restore (tmux-resurrect) |

Sessions auto-save every 15 minutes (tmux-continuum) and auto-restore when tmux starts. Survives devbox reboots.

**What's saved:** pane layout, working directories, running programs, pane contents.

### Session workflow

Create named sessions for different contexts:

```bash
tmux new -s pipeline      # ML pipeline work
tmux new -s product       # Next.js product work
tmux new -s infra         # Terraform / cloud
```

Then use `prefix + s` to jump between them. Each session remembers its own window layout and pane arrangement.

## Copy Mode (vi-style)

Enter copy mode with `prefix + Enter` (or `prefix + [`, or scroll up with mouse).

### Navigation in copy mode

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move cursor |
| `w/b/e` | Word forward / back / end |
| `0` / `$` | Start / end of line |
| `g` / `G` | Top / bottom of history |
| `C-u` / `C-d` | Half-page up / down |
| `H` / `M` / `L` | Top / middle / bottom of visible area |
| `/` | Search forward (incremental) |
| `?` | Search backward (incremental) |
| `n` / `N` | Next / previous search match |

### Selection and copying

| Key | Action |
|-----|--------|
| `v` | Begin character selection |
| `V` | Begin line selection |
| `C-v` | Begin rectangle (block) selection |
| `y` | Yank selection and exit copy mode |
| `Esc` / `q` | Exit copy mode |

**Tip:** tmux-yank plugin makes `y` copy to system clipboard automatically. Yanked text is available in vim via the `+` register (and vice versa, since nvim has `clipboard=unnamedplus`).

### Search highlighting

- **Matches** show as orange on dark background
- **Current match** shows as bold purple
- Same colours as the sourcerer theme

### Copy mode workflow

1. `prefix + Enter` to enter copy mode
2. Navigate to where you want (or `/` to search)
3. `v` to start selecting
4. Move to extend selection
5. `y` to yank — text goes to system clipboard
6. Paste anywhere with `C-v` (macOS) or middle-click

**Mouse alternative:** Click and drag to select, release to copy. Scroll wheel to enter copy mode and scroll history.

## Mouse Support

| Action | What it does |
|--------|-------------|
| Click on pane | Switch to that pane |
| Click on window tab | Switch to that window |
| Drag pane border | Resize pane |
| Scroll wheel | Enter copy mode + scroll history |
| Click + drag | Select text (auto-copies on release) |

Mouse is enabled but keyboard-first workflow is faster for everything except casual scrolling and resizing.

## Status Bar

```
┌────────────────────────────────────────────────────────────────────┐
│ SESSION  │ 0:nvim  1:zsh  2:logs │  branch | ~/path | host | HH:MM │
└────────────────────────────────────────────────────────────────────┘
```

- **Position:** top of screen
- **Left:** session name (purple accent)
- **Centre:** window tabs (purple = active, dim = inactive, orange = activity)
- **Right:** git branch (green) | pane path (grey) | hostname | time (purple)

The hostname is visible so you know which devbox you're on when SSH'd.

## Colour Scheme — sourcerer

Everything matches the nvim sourcerer colourscheme:

| Element | Colour |
|---------|--------|
| Background | `#1a1a1a` (near-black) |
| Text | `#918175` (warm grey) |
| Accent (session, active tab, time, active border) | `#a88af8` (muted purple) |
| Git branch | `#87af87` (sage green) |
| Activity indicator | `#d7875f` (warm orange) |
| Search matches | `#d7875f` bg (orange) |
| Current search match | `#a88af8` bg (purple, bold) |
| Pane borders | `#333333` (inactive), `#a88af8` (active) |
| Popups | `#a88af8` border, rounded corners |
| Clock (prefix + t) | `#a88af8` (purple), 24h |

## Environment

SSH agent, AWS credentials, and display variables are preserved across reattach:

```
SSH_AUTH_SOCK SSH_CONNECTION SSH_AGENT_PID DISPLAY AWS_PROFILE AWS_DEFAULT_REGION
```

This means `ssh-add` and `aws` commands keep working after you detach and reattach on a devbox.

---

## Tips & Techniques

### Pane zoom is your friend

`prefix + z` (or `prefix + m`) toggles a pane to fullscreen and back. Use it constantly:
- Zoom into vim to focus, zoom out to see your REPL/logs alongside
- Zoom into a log pane to read it, zoom back to continue working
- The zoomed state is shown as `Z` in the window tab

### Named sessions for context switching

Instead of cramming everything into one session, use separate sessions per workstream. `prefix + s` (fzf picker) makes switching instant. Your brain maps each session to a task.

### Respawning panes

`prefix + R` kills the current process and restarts the pane's shell. Useful when:
- A dev server crashes and you want to restart it
- A training run finishes and you want to start another
- A hung SSH connection needs to be reset

### Sending commands to other panes

```bash
tmux send-keys -t {right-of} "make test" Enter
```

You can script this — send a command to your REPL pane without leaving vim. This is what vim-slime does under the hood (`C-c C-c`).

### Capturing pane output

```bash
tmux capture-pane -p -S -100 > /tmp/output.txt    # Last 100 lines
tmux capture-pane -p -S - > /tmp/full_output.txt   # Full history
```

Useful for grabbing training logs or error output. Also works on other panes: `tmux capture-pane -t {right-of} -p`.

### Layouts

| Command | Layout |
|---------|--------|
| `prefix + M-1` | Even horizontal (all panes side by side) |
| `prefix + M-2` | Even vertical (all panes stacked) |
| `prefix + M-3` | Main horizontal (big top, small bottom) |
| `prefix + M-4` | Main vertical (big left, small right) |
| `prefix + M-5` | Tiled (grid) |

**Tip:** `prefix + M-4` (main vertical) is great for the classic "vim left, terminal right" layout.

### Reloading config

After editing `~/.tmux.conf`:

```
prefix + : then type "source-file ~/.tmux.conf"
```

Or from the shell: `tmux source-file ~/.tmux.conf`

### Common tmux commands

```bash
tmux ls                              # List sessions
tmux new -s name                     # New named session
tmux attach -t name                  # Attach to session
tmux kill-session -t name            # Kill session
tmux kill-server                     # Kill everything
```

---

## Plugins Installed

| Plugin | Purpose |
|--------|---------|
| tpm | Plugin manager (`prefix + I` to install) |
| tmux-sensible | Sensible defaults (utf8, history, key repeat) |
| tmux-yank | System clipboard integration for copy mode |
| tmux-resurrect | Save/restore sessions (layout, cwd, programs) |
| tmux-continuum | Auto-save every 15min, auto-restore on start |

---

## Config location

`~/.tmux.conf` — single file, no subdirectories.

Backup at `~/.tmux.conf.bak`.
