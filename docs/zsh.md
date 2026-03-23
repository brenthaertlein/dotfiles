# Zsh

Zsh is the default shell on macOS and widely available on Linux. This config keeps things minimal — no plugin manager framework (no oh-my-zsh/zinit), just direct sourcing of a few high-value plugins.

## Current Config

**File:** `zsh/.zshrc` → `~/.zshrc`

### Shell Options

- `AUTO_CD` — type a directory name to cd into it
- `CORRECT` — suggest corrections for typos
- `MENU_COMPLETE` — cycle through completions with tab
- Emacs keybindings (`bindkey -e`) — standard readline behavior

### Integrations

| Tool | What it does |
|---|---|
| [starship](starship.md) | Prompt — `eval "$(starship init zsh)"` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` — `eval "$(zoxide init zsh)"`, use `z` to jump to frecent directories |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — Ctrl+R for history, Ctrl+T for files, Alt+C for directories |
| [fzf-tab](https://github.com/Aloxaf/fzf-tab) | Replaces zsh's tab completion menu with fzf — fuzzy search with previews via eza/bat |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Completion loaded if kubectl is installed |
| [Google Cloud SDK](https://cloud.google.com/sdk) | PATH and completion sourced from `$HOME/google-cloud-sdk/` |

### Plugins

Sourced directly from Homebrew or system paths (no plugin manager):

- **fzf-tab** — replaces the default completion menu with fzf, adding fuzzy search and file/directory previews (via eza and bat)
- **zsh-autosuggestions** — ghost text suggestions from history as you type
- **zsh-syntax-highlighting** — colors commands green/red as you type based on validity

All check Homebrew (`/opt/homebrew/`) and Linux system (`/usr/share/zsh/plugins/`) paths. Load order matters: fzf-tab must come after `compinit` but before other plugins.

### Aliases

| Alias | Replaces | Why |
|---|---|---|
| `ls` | `eza --icons --group-directories-first` | Better output, icons, sorting |
| `cat` | `bat` | Syntax highlighting, line numbers, paging |
| `k` | `kubectl` | Less typing |

### PATH

- `$HOME/.local/bin` is prepended to PATH
