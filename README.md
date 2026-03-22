# dotfiles

Portable terminal environment for macOS and Linux (Arch, Fedora, Debian/Ubuntu), managed with [GNU Stow](https://www.gnu.org/software/stow/) and [Ansible](https://www.ansible.com/). Catppuccin Mocha theme across all tools.

## Quick Start

```bash
git clone <your-dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

Then manually:

1. Set terminal font to **MesloLGS Nerd Font** (iTerm2: Preferences → Profiles → Text → Font)
2. Open vim → `:PlugInstall`
3. Open tmux → `prefix + I` to install plugins
4. Authenticate cloud CLIs (`aws configure`, `gcloud auth login`)

## What's Included

### Stow Packages

Each directory is a [stow package](docs/stow.md) — symlinked into `$HOME` via `stow.sh`.

| Package | Target | Docs |
|---|---|---|
| **zsh** | `~/.zshrc` | [docs/zsh.md](docs/zsh.md) |
| **vim** | `~/.vimrc` | [docs/vim.md](docs/vim.md) |
| **tmux** | `~/.tmux.conf` | [docs/tmux.md](docs/tmux.md) |
| **starship** | `~/.config/starship.toml` | [docs/starship.md](docs/starship.md) |

### Brewfile

| Category | Packages |
|---|---|
| **Shell & TUI** | tmux, starship, fzf, ripgrep, bat, zoxide, eza, tree, jq |
| **System** | curl, wget, stow |
| **Development** | git, gh, python, node (via n) |
| **Cloud & Infra** | awscli, kubectl, k9s, helm, terraform, ansible |
| **Casks** | font-meslo-lg-nerd-font, iTerm2, OrbStack |

## Structure

```
dotfiles/
├── zsh/.zshrc                          →  ~/.zshrc
├── vim/.vimrc                          →  ~/.vimrc
├── tmux/.tmux.conf                     →  ~/.tmux.conf
├── starship/.config/starship.toml      →  ~/.config/starship.toml
├── docs/                               documentation per tool
├── ansible/                            playbook + inventory
├── bootstrap.sh                        entry point (Homebrew + brew bundle + Ansible)
├── stow.sh                             deploys symlinks
├── macos.sh                            macOS system preferences
└── Brewfile                            package manifest
```

## Resources

| Resource | What it is |
|---|---|
| [awesome-tuis](https://github.com/rothgar/awesome-tuis) | Curated list of TUI tools |
| [terminal-apps.dev](https://terminal-apps.dev/) | Searchable directory of terminal applications |
| [VimAwesome](https://vimawesome.com/) | Searchable vim plugin directory |
| [amix/vimrc](https://github.com/amix/vimrc) | Popular curated vim configuration |
| [awesome-tmux](https://github.com/rothgar/awesome-tmux) | Curated list of tmux plugins and resources |
| [awesome-sysadmin](https://github.com/awesome-foss/awesome-sysadmin) | Curated list of sysadmin tools and resources |

## Known Issues

- **macOS-only assumptions** — `pbcopy` in tmux, Homebrew-only fzf paths, `macos.sh` called unconditionally in bootstrap. (Tracked in Phase 1)

---

## Roadmap

### Phase 0: Foundation ✅

- Catppuccin Mocha theme aligned across starship, tmux, and vim
- Fixed missing vim colorscheme plugin, invalid tmux status plugin, hardcoded paths
- Nerd Font (Meslo LG) added to Brewfile
- Rounded powerline prompt and tmux tabs, prefix-aware session indicator

### Phase 1: Cross-Platform Support (Arch, Fedora, Debian)

- [ ] OS detection in `bootstrap.sh` — support pacman/yay (Arch), dnf (Fedora), apt (Debian/Ubuntu) alongside Homebrew
- [ ] Per-distro package lists in a `packages/` directory
- [ ] Multi-path fzf sourcing in `.zshrc` (add `/usr/share/fzf/`, linuxbrew paths)
- [ ] Cross-platform clipboard in tmux — `tmux-yank` plugin or conditional `pbcopy`/`xclip`/`wl-copy`
- [ ] Guard `macos.sh` behind `$OSTYPE` check in `bootstrap.sh`
- [ ] Expand Ansible with per-OS roles/tasks

### Phase 2: Enhanced Configs

- [ ] **Neovim migration** — `nvim/.config/nvim/init.lua` stow package with lazy.nvim, LSP, treesitter, telescope, catppuccin. Keep `.vimrc` functional for remote servers.
- [ ] **Tmux** — tmux-resurrect + tmux-continuum (session persistence), tmux-yank (cross-platform clipboard), vim-style pane navigation
- [ ] **Starship transient prompt** — zsh `zle-line-init` hook workaround or upstream `transient_prompt` feature
- [ ] **SSH config** — New stow package with `Include ~/.ssh/config.d/*`, split by environment, sensible defaults. Host IPs in gitignored templates.
- [ ] **Git config** — `defaultBranch = main`, `pull.rebase = true`, `push.autoSetupRemote = true`, git-delta pager, aliases, `includeIf` for per-directory identity

### Phase 3: Homelab / Infrastructure

- [ ] Ansible inventory with homelab hosts grouped by role (proxmox, VMs, containers, K8s nodes)
- [ ] Playbook to push dotfiles to remote hosts
- [ ] Generate `~/.ssh/config.d/homelab` from Ansible inventory
- [ ] Proxmox CLI (`pvesh`) documentation and scripts
- [ ] Add `kubectx`/`kubens` to Brewfile
- [ ] Network topology documentation or discovery script

### Phase 4: TUI Tool Adoption

| Category | Recommended | Alternatives | Notes |
|---|---|---|---|
| File manager | **yazi** | ranger, nnn, lf | Async I/O, image preview, vim keybinds |
| Git TUI | **lazygit** | tig | Staging, rebase, conflict resolution |
| Diff viewer | **git-delta** | diff-so-fancy | Better diffs everywhere |
| Network | **bandwhich** | nethogs | Bandwidth by process |
| Traceroute | **trippy** | mtr | Live-updating TUI |
| Ping | **gping** | — | Ping with graph |
| Disk usage | **dust** | ncdu, duf | Visual bars, fast |
| Process viewer | **procs** | — | Modern `ps` with color + tree |
| SSH navigator | **sshs** | storm | Fuzzy search SSH config hosts |
| K8s dashboard | **kdash** | — | Complement to k9s |
| JSON viewer | **fx** or **jless** | — | Interactive exploration |
| Benchmarking | **hyperfine** | — | Statistical CLI benchmarks |
| Code stats | **tokei** | scc, cloc | Lines of code by language |
| Containers | lazydocker *(in use)* | ctop, dry | — |
| System monitor | btop *(in use)* | bottom, glances | — |

See [awesome-tuis](https://github.com/rothgar/awesome-tuis) and [terminal-apps.dev](https://terminal-apps.dev/) for discovery.

---

## License

MIT
