# Set tmux pane title to "host @ ssh" during SSH sessions
# Resets pane title when SSH exits

_tmux_ssh_preexec() {
  [[ -z "$TMUX" ]] && return
  local cmd="$1"
  # Match ssh commands (ssh, autossh, etc.)
  if [[ "$cmd" =~ ^(auto)?ssh[[:space:]] ]]; then
    local host=""
    # Parse the hostname from the ssh command, skipping flags and their arguments
    local -a words=("${(z)cmd}")
    local skip_next=false
    for word in "${words[@]:1}"; do
      if $skip_next; then
        skip_next=false
        continue
      fi
      # Flags that take an argument
      if [[ "$word" =~ ^-[bcDEeFIiJLlmOopQRSWw]$ ]]; then
        skip_next=true
        continue
      fi
      # Flags that don't take an argument, or combined flag+value like -p22
      [[ "$word" == -* ]] && continue
      # user@host or just host
      host="${word##*@}"
      break
    done
    if [[ -n "$host" ]]; then
      printf '\e]2;%s @ ssh\e\\' "$host"
    fi
  fi
}

_tmux_ssh_precmd() {
  [[ -z "$TMUX" ]] && return
  # Reset pane title to default (current command/shell)
  printf '\e]2;%s\e\\' "${SHELL##*/}"
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_ssh_preexec
add-zsh-hook precmd _tmux_ssh_precmd
