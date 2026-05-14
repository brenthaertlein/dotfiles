
export EDITOR=vim
export VISUAL=vim
export PATH="$HOME/.local/bin:$PATH"

# asdf version manager completions
if command -v asdf >/dev/null; then
  fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
fi

autoload -Uz compinit && compinit
setopt AUTO_CD CORRECT MENU_COMPLETE INTERACTIVE_COMMENTS NO_BEEP NO_LIST_BEEP
bindkey -e

# Alt+Backspace / Ctrl+W: treat "/" as a word boundary (path segments, URLs).
# zsh default is *?_-.[]~=/&;!#$%^(){}<> — "/" glues path segments into one "word".
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# fzf-tab (must come after compinit, before other plugins)
for p in /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh \
         /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh \
         "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"; do
  [[ -f $p ]] && source $p && break
done
zstyle ':fzf-tab:*' fzf-flags '--bind=esc:abort'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:50 $realpath 2>/dev/null || eza -1 --icons --color=always $realpath 2>/dev/null'

# fzf key-bindings (Ctrl+T files, Alt+C dirs)
# fzf-tab handles tab completion — do not source fzf's completion.zsh
# Note: atuin takes over Ctrl+R below; fzf's Ctrl+T and Alt+C still work
for p in /opt/homebrew/opt/fzf/shell/key-bindings.zsh \
         /usr/share/doc/fzf/examples/key-bindings.zsh; do
  [[ -f $p ]] && source $p && break
done

# atuin — shell history sync & search (takes over Ctrl+R from fzf)
if command -v atuin >/dev/null; then
  eval "$(atuin init zsh)"
fi

# autosuggestions
for p in /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
         /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
         /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -f $p ]] && source $p && break
done

# syntax highlighting
for p in /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
         /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
         /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  [[ -f $p ]] && source $p && break
done

if command -v kubectl >/dev/null; then
  source <(kubectl completion zsh)
fi

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --classify'
alias la='eza -a --icons --group-directories-first --classify'
alias l='eza -l --icons --group-directories-first --classify'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cat='bat'
alias k='kubectl'
[ -x /Applications/Tailscale.app/Contents/MacOS/Tailscale ] && alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Source modular shell functions from ~/.zshrc.d/
for f in ~/.zshrc.d/*.zsh(N); do source "$f"; done
