
export EDITOR=vim
export VISUAL=vim
autoload -Uz compinit && compinit
setopt AUTO_CD CORRECT MENU_COMPLETE INTERACTIVE_COMMENTS NO_BEEP NO_LIST_BEEP
bindkey -e

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# fzf-tab (must come after compinit, before other plugins)
for p in /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh; do
  [[ -f $p ]] && source $p
done
zstyle ':fzf-tab:*' fzf-flags '--bind=esc:abort'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --icons --color=always $realpath 2>/dev/null'

# fzf key-bindings only (Ctrl+R history, Ctrl+T files, Alt+C dirs)
# fzf-tab handles tab completion — do not source fzf's completion.zsh
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# autosuggestions
for p in /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -f $p ]] && source $p
done

# syntax highlighting
for p in /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -f $p ]] && source $p
done

if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
fi

alias ls='eza --icons --group-directories-first'
alias cat='bat'
alias k='kubectl'
[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ] && alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
export PATH="$HOME/.local/bin:$PATH"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Source modular shell functions from ~/.zshrc.d/
for f in ~/.zshrc.d/*.zsh(N); do source "$f"; done
