
export EDITOR=vim
export VISUAL=vim
autoload -Uz compinit && compinit
setopt AUTO_CD CORRECT MENU_COMPLETE INTERACTIVE_COMMENTS
bindkey -e

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# fzf
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh

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
export PATH="$HOME/.local/bin:$PATH"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
