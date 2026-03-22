# dotfiles

macOS/Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and [Ansible](https://www.ansible.com/).

## Overview

This repository manages shell, editor, terminal multiplexer, git, and prompt configurations using GNU Stow for symlink management and Ansible for orchestration. The goal is a portable, reproducible terminal environment across macOS and Linux (Arch, Fedora, Debian/Ubuntu).

### Stow Package Layout

Each top-level directory is a Stow "package." Running `stow <package>` creates symlinks from the package contents into `$HOME`, mirroring the directory structure:

```
dotfiles/
├── zsh/.zshrc                          →  ~/.zshrc
├── vim/.vimrc                          →  ~/.vimrc
├── tmux/.tmux.conf                     →  ~/.tmux.conf
└── starship/.config/starship.toml      →  ~/.config/starship.toml
```

### Automation

| File | Purpose |
|---|---|
| `bootstrap.sh` | Entry point — installs Homebrew (macOS), runs `brew bundle`, runs `macos.sh`, runs Ansible |
| `stow.sh` | Loops through all stow modules and deploys symlinks to `$HOME` |
| `macos.sh` | macOS-specific system preferences (screenshot directory) |
| `Brewfile` | Homebrew package manifest (formulae + casks) |
| `ansible/` | Playbook that calls `stow.sh` to deploy dotfiles |

## Prerequisites

- `git` and `curl`
- macOS: Xcode Command Line Tools (`xcode-select --install`)

Everything else is installed by `bootstrap.sh`.

## Quick Start

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

**What bootstrap does:**
1. Installs [Homebrew](https://brew.sh) if not already present (macOS)
2. Runs `brew bundle --file=Brewfile` to install all packages
3. Runs `macos.sh` to configure macOS system preferences
4. Runs the Ansible playbook, which calls `stow.sh` to create all symlinks

## What's Included

### Stow Packages

| Package | Config File | Key Features |
|---|---|---|
| **zsh** | `.zshrc` | Starship prompt, zoxide, fzf key bindings + completion, zsh-autosuggestions, zsh-syntax-highlighting, eza/bat aliases, kubectl completion, Google Cloud SDK |
| **vim** | `.vimrc` | vim-plug, NERDTree, fzf.vim, lightline, coc.nvim, catppuccin mocha colorscheme, relative line numbers |
| **tmux** | `.tmux.conf` | TPM (Tmux Plugin Manager), tmux-sensible, catppuccin mocha theme, vi mode, mouse support, 256-color + true color, pane broadcast toggle (Ctrl-x) |
| **starship** | `.config/starship.toml` | Catppuccin Mocha powerline preset, Kubernetes context, OS icon, git status, language runtimes, clock |

### Brewfile Contents

| Category | Packages |
|---|---|
| **Shell & TUI** | tmux, starship, fzf, ripgrep, bat, zoxide, eza, tree, jq |
| **System** | curl, wget, stow |
| **Development** | git, gh, python, node (via n) |
| **Cloud & Infra** | awscli, kubectl, k9s, helm, terraform, ansible |
| **Casks** | iTerm2, OrbStack |

## How Stow Works

GNU Stow creates symlinks from a "package directory" into a target directory. Each package mirrors the structure of `$HOME`:

```
# The package directory:
dotfiles/zsh/.zshrc

# After running `stow --target=$HOME zsh`:
~/.zshrc → dotfiles/zsh/.zshrc
```

The key insight: **the top-level directory name (e.g., `zsh/`) is the package name and gets "peeled off."** Everything inside it maps directly to the target. So `starship/.config/starship.toml` becomes `~/.config/starship.toml`.

To add a new package:
1. Create a directory: `mkdir -p newpkg/.config/newpkg/`
2. Add your config: `vim newpkg/.config/newpkg/config.toml`
3. Add it to `stow.sh`
4. Run `stow --target=$HOME newpkg`

To remove a package's symlinks: `stow --target=$HOME -D pkgname`

## Manual Steps After Bootstrap

These steps are not automated and must be run once after initial setup:

1. **Vim plugins**: Open vim and run `:PlugInstall`
2. **Tmux plugins**: Open tmux and press `prefix + I` (capital I) to install TPM plugins
3. **Credentials**: Authenticate cloud CLIs (`aws configure`, `gcloud auth login`), set up SSH keys, etc.

## Known Issues

1. **macOS-only assumptions** — `pbcopy` in tmux clipboard binding, Homebrew-only fzf paths, `macos.sh` called unconditionally in bootstrap. (Tracked in Phase 1)

---

## Roadmap

### Phase 0: Foundation — Fix Known Bugs

- [x] Align on Catppuccin Mocha theme across starship, tmux, and vim
- [x] Add `Plug 'catppuccin/vim'` to `.vimrc` with `colorscheme catppuccin_mocha`
- [x] Replace invalid `tmux-plugins/tmux-status` with `catppuccin/tmux` (mocha flavor)
- [x] Apply Catppuccin Powerline preset to starship with kubernetes, docker, and language modules
- [x] Replace hardcoded home directory path with `$HOME/` in gcloud paths in `.zshrc`

### Phase 1: Cross-Platform Support (Arch, Fedora, Debian)

- [ ] Add OS detection in `bootstrap.sh` — support pacman/yay (Arch), dnf (Fedora), apt (Debian/Ubuntu) alongside Homebrew (macOS)
- [ ] Create per-distro package lists in a `packages/` directory mapping Brewfile entries to native package names
- [ ] Add multi-path fzf sourcing in `.zshrc` (add `/usr/share/fzf/`, linuxbrew paths alongside existing homebrew paths)
- [ ] Cross-platform clipboard in tmux — use `tmux-yank` plugin or conditional `pbcopy`/`xclip`/`wl-copy`
- [ ] Guard `macos.sh` behind `$OSTYPE` check in `bootstrap.sh`
- [ ] Expand Ansible with per-OS roles/tasks for package installation

### Phase 2: Enhanced Configs

- [ ] **Neovim migration** — Create `nvim/.config/nvim/init.lua` stow package with lazy.nvim, LSP, treesitter, telescope, gruvbox theme. Keep a minimal compatibility shim so the config degrades gracefully on servers without full neovim. Add `neovim` to Brewfile/package lists. Remove the vim stow package once migrated.
- [ ] **Tmux** — Add tmux-resurrect + tmux-continuum (session persistence across reboots), tmux-yank (cross-platform clipboard), vim-style pane navigation (`M-h/j/k/l`). Add a status theme plugin with hostname and k8s context.
- [ ] **Starship transient prompt** — Investigate transient prompt via zsh `zle-line-init` hook (community workaround) or starship's `transient_prompt` feature if added upstream
- [ ] **SSH config** — New stow package `ssh/.ssh/config` with `Include ~/.ssh/config.d/*`, split by environment (homelab, cloud, work). Sensible defaults: `ServerAliveInterval 60`, `AddKeysToAgent yes`, `IdentitiesOnly yes`. Keep host IPs in gitignored templates.
- [ ] **Git config** — Add `[init] defaultBranch = main`, `[pull] rebase = true`, `[push] autoSetupRemote = true`, git-delta as pager, useful aliases, `[includeIf]` for per-directory identity (work vs personal email)

### Phase 3: Homelab / Infrastructure

- [ ] Expand `ansible/inventory/` with homelab hosts grouped by role (proxmox hosts, VMs, containers, k8s nodes, storage)
- [ ] Ansible playbook to push dotfiles to remote hosts (clone repo + run stow.sh via SSH)
- [ ] Script to generate `~/.ssh/config.d/homelab` from Ansible inventory (single source of truth for host definitions)
- [ ] Proxmox CLI integration — document `pvesh` usage for common tasks (list VMs, start/stop, snapshots), consider `proxmoxer` Python scripts in a `scripts/` directory
- [ ] Add `kubectx`/`kubens` to Brewfile, leverage starship k8s context display
- [ ] Network topology documentation or discovery script for homelab hosts and running services

### Phase 4: TUI Tool Adoption

Tools to evaluate, add to Brewfile/package lists, and configure via new stow packages:

| Category | Recommended | Alternatives | Notes |
|---|---|---|---|
| File manager | **yazi** | ranger, nnn, lf | Async I/O, image preview in iTerm2, vim keybinds, active development |
| Git TUI | **lazygit** | tig | Full git workflow: staging hunks, interactive rebase, conflict resolution |
| Diff viewer | **git-delta** | diff-so-fancy | Better diffs in CLI, lazygit, and git log |
| Network monitor | **bandwhich** | nethogs | Real-time bandwidth usage by process/connection |
| Traceroute | **trippy** | mtr | Live-updating TUI traceroute, great for network debugging |
| Ping | **gping** | — | Ping with a live graph |
| Disk usage | **dust** | ncdu, duf | Visual bar output, fast Rust implementation |
| Process viewer | **procs** | — | Modern `ps` replacement with color, tree view, and search |
| SSH navigator | **sshs** | storm | TUI for `~/.ssh/config` — fuzzy search and connect to hosts |
| K8s dashboard | **kdash** | — | Dashboard-style complement to k9s |
| JSON viewer | **fx** or **jless** | — | Interactive JSON exploration (vs jq for scripting) |
| Benchmarking | **hyperfine** | — | CLI command benchmarking with statistical analysis |
| Code stats | **tokei** | scc, cloc | Lines of code by language, fast |
| Containers | lazydocker *(already using)* | ctop, dry | — |
| System monitor | btop *(already using)* | bottom, glances | — |

Resource: [awesome-tuis](https://github.com/rothgar/awesome-tuis) for ongoing discovery.

---

## License

MIT
