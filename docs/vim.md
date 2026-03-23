# Vim

Vim is configured as a comfortable editing environment — not a full IDE, but enough to be productive for config editing, quick scripts, and remote server work. A neovim migration with LSP/treesitter is planned for Phase 2.

## Current Config

**File:** `vim/.vimrc` → `~/.vimrc`

### Theme

**Catppuccin Mocha** — matches starship and tmux. Requires `:PlugInstall` on first run.

### Key Settings

| Setting | Value | Why |
|---|---|---|
| Line numbers | `number relativenumber` | Absolute on current line, relative for easy motion counts |
| Tabs | 4 spaces, expandtab | Consistent indentation |
| Search | `ignorecase smartcase` | Case-insensitive unless you type uppercase |
| Mouse | Enabled | Click to position cursor, scroll |
| True color | `termguicolors` | Full color theme support in modern terminals |
| Regex engine | `regexpengine=0` | Auto-select engine to prevent syntax highlighting timeout |
| Redraw time | `redrawtime=10000` | Longer timeout before disabling syntax highlighting on large files |

### Plugins (via vim-plug)

[vim-plug](https://github.com/junegunn/vim-plug) auto-installs itself on first vim launch if missing.

| Plugin | What it does |
|---|---|
| [catppuccin/vim](https://github.com/catppuccin/vim) | Catppuccin colorscheme |
| [vim-sensible](https://github.com/tpope/vim-sensible) | Universal sensible defaults |
| [fzf + fzf.vim](https://github.com/junegunn/fzf.vim) | Fuzzy file/buffer/line finder inside vim |
| [NERDTree](https://github.com/preservim/nerdtree) | File tree sidebar |
| [lightline](https://github.com/itchyny/lightline.vim) | Lightweight status line |
| [coc.nvim](https://github.com/neoclide/coc.nvim) | LSP client for code completion and diagnostics |

**Installing plugins:** Open vim, run `:PlugInstall`.

### Neovim Migration (Phase 2)

The plan is to create a separate `nvim/.config/nvim/init.lua` stow package using lazy.nvim with LSP, treesitter, and telescope. The current `.vimrc` will be kept functional for use on remote servers without neovim.

### Resources

- [VimAwesome](https://vimawesome.com/) — searchable plugin directory
- [amix/vimrc](https://github.com/amix/vimrc) — popular curated vim config for inspiration
