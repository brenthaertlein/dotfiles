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

| Binding | Action |
|---|---|
| `prefix + \|` | Split pane horizontally |
| `prefix + -` | Split pane vertically |
| `prefix + r` | Reload config |
| `Ctrl-x` | Toggle pane broadcast (type in all panes simultaneously) |
| `prefix + I` | Install TPM plugins |
| `prefix + U` | Update TPM plugins |

### Settings

- **Vi mode** for copy-mode and status keys
- **Mouse support** enabled (click panes, resize, scroll)
- **True color** support (`tmux-256color` + `Tc` override)
- **Base index 1** for windows and panes (no window 0)
- **Dynamic titles** — `allow-rename on` lets programs set window names
- **Clipboard** — `pbcopy` integration (macOS-only, tracked for cross-platform fix in Phase 1)

### Plugins (via TPM)

| Plugin | Purpose |
|---|---|
| [tpm](https://github.com/tmux-plugins/tpm) | Tmux Plugin Manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults (larger history, better key bindings) |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin theme with status modules |

**Installing plugins:** Open tmux, press `prefix + I`. TPM clones plugins to `~/.tmux/plugins/`.

See [awesome-tmux](https://github.com/rothgar/awesome-tmux) for more plugins and resources.
