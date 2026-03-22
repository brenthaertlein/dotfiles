# Starship

[Starship](https://starship.rs) is a cross-shell prompt written in Rust. It replaced powerlevel10k which is no longer maintained. It's fast, highly configurable, and works across zsh, bash, fish, and more.

## Current Config

**File:** `starship/.config/starship.toml` → `~/.config/starship.toml`

### Theme

**Catppuccin Mocha** powerline preset — rounded bubble-style segments with Nerd Font icons. This matches the catppuccin theme used in tmux and vim.

### Font Requirement

Requires a [Nerd Font](https://www.nerdfonts.com/) for the powerline separators and icons. **Meslo LG Nerd Font** is included in the Brewfile and must be set as the font in your terminal:

**iTerm2:** Preferences → Profiles → Text → Font → "MesloLGS Nerd Font"

### Prompt Segments

Left to right:

| Segment | Color | Shows |
|---|---|---|
| OS icon | Red | macOS, Ubuntu, Arch, Fedora, etc. |
| Username | Red | Current user |
| Directory | Peach | Current path (truncated to 3 levels) |
| Git branch + status | Yellow | Branch name, dirty/clean/ahead/behind |
| Language runtime | Green | Node, Python, Go, Rust, Java, etc. (only when relevant files detected) |
| Docker / K8s | Sapphire | Docker context, Kubernetes context + namespace |
| Time | Lavender | Current time (HH:MM) |
| Command duration | — | Shows after slow commands |

### Switching Palettes

The config defines the palette inline. To switch flavors, change the `palette` line:

```toml
palette = 'catppuccin_mocha'    # dark
# palette = 'catppuccin_frappe' # darker mid-tone (define the palette section too)
```

Additional palettes must be defined as `[palettes.<name>]` sections. See the [starship palette docs](https://starship.rs/config/#palettes) and [starship presets](https://starship.rs/presets/) for options.
