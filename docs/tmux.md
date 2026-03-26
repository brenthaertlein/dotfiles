# Tmux

[Tmux](https://github.com/tmux/tmux) is a terminal multiplexer — it lets you run multiple terminal sessions inside one window, detach and reattach to sessions, and split panes. Used locally as the primary workspace manager.

## Current Config

**File:** `tmux/.tmux.conf` → `~/.tmux.conf`

### Theme

**Catppuccin Mocha** with rounded bubble-style window tabs. The status bar shows:

- **Left:** Session name (turns red when prefix is active — acts as a prefix mode indicator)
- **Center:** Window tabs with dynamic titles (`#T` — programs like Claude can set these)
- **Right:** Current directory + date/time

### Key Bindings

Default prefix is `Ctrl-b` (from tmux-sensible).

For the full list, press `prefix + h` inside tmux to open the interactive cheatsheet (fzf picker — select a command to execute it). Source: [`tmux/.tmux/cheatsheet.md`](../tmux/.tmux/cheatsheet.md).

| Binding | Action |
|---|---|
| `prefix + h` | Open cheatsheet — browse and execute commands via fzf |
| `prefix + O` | Open SessionX — fuzzy session switcher (fzf popup) |
| `prefix + \|` | Split pane horizontally |
| `prefix + -` | Split pane vertically |
| `prefix + j` | Move a pane into another window (interactive picker) |
| `prefix + B` | Break current pane into its own window |
| `prefix + S` | Send current window to a new session (prompts for name) |
| `prefix + L` | Switch to last session |
| `Ctrl-x` | Toggle pane broadcast (type in all panes simultaneously) |
| `prefix + r` | Reload config |
| `prefix + I` | Install TPM plugins |
| `prefix + U` | Update TPM plugins |

### Settings

- **Vi mode** for copy-mode and status keys
- **Mouse support** enabled (click panes, resize, scroll)
- **True color** support (`tmux-256color` + `Tc` override)
- **Base index 1** for windows and panes (no window 0)
- **Dynamic titles** — `allow-rename on` lets programs set window names
- **Clipboard** — cross-platform via tmux-yank plugin

### Plugins (via TPM)

| Plugin | Purpose |
|---|---|
| [tpm](https://github.com/tmux-plugins/tpm) | Tmux Plugin Manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults (larger history, better key bindings) |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore tmux sessions across restarts |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save sessions every 15 min, auto-restore on tmux start |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Cross-platform clipboard support (replaces hardcoded pbcopy) |
| [tmux-sessionx](https://github.com/omerxx/tmux-sessionx) | Fuzzy session manager — switch, create, rename, delete sessions via fzf popup |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin theme with status modules |

**Installing plugins:** Open tmux, press `prefix + I`. TPM clones plugins to `~/.tmux/plugins/`.

See [awesome-tmux](https://github.com/rothgar/awesome-tmux) for more plugins and resources.
