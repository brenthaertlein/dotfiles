#!/usr/bin/env bash
# Claude Code status line — mirrors Starship Catppuccin Mocha segments
# Receives JSON via stdin

input=$(cat)

# --- Data extraction ---
user=$(whoami)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$dir" ] && dir=$(pwd)
# If inside a .worktrees/ directory, show the project root name instead
case "$dir" in
  */.worktrees/*)
    basename_dir=$(basename "${dir%%/.worktrees/*}")
    ;;
  *)
    basename_dir=$(basename "$dir")
    ;;
esac

model=$(echo "$input" | jq -r '.model.display_name // empty')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Git info (skip optional locks)
git_branch=""
git_status_str=""
pr_number=""
pr_url=""
if git_output=$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_output"
  dirty=$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" status --porcelain 2>/dev/null)
  if [ -n "$dirty" ]; then
    git_status_str="*"
  fi
  # Show PR number only inside worktrees (Claude Code shows it elsewhere)
  case "$dir" in
    */.worktrees/*)
      cache_dir="${TMPDIR:-/tmp}/claude-statusline"
      cache_key=$(echo "$dir:$git_branch" | md5 -q 2>/dev/null || echo "$dir:$git_branch" | md5sum | cut -d' ' -f1)
      cache_file="$cache_dir/$cache_key"
      if [ -f "$cache_file" ] && [ "$(( $(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file" 2>/dev/null || echo 0) ))" -lt 60 ]; then
        pr_number=$(head -1 "$cache_file")
        pr_url=$(tail -1 "$cache_file")
      else
        mkdir -p "$cache_dir"
        pr_json=$(gh pr view --json number,url -R "$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" remote get-url origin 2>/dev/null)" "$git_branch" 2>/dev/null || echo "")
        if [ -n "$pr_json" ]; then
          pr_number=$(echo "$pr_json" | jq -r '.number // empty')
          pr_url=$(echo "$pr_json" | jq -r '.url // empty')
        fi
        printf '%s\n%s' "$pr_number" "$pr_url" > "$cache_file"
      fi
      ;;
  esac
fi

time_str=$(date +%H:%M)

# --- Catppuccin Mocha colors (ANSI) ---
RED="\033[38;2;243;139;168m"
PEACH="\033[38;2;250;179;135m"
YELLOW="\033[38;2;249;226;175m"
GREEN="\033[38;2;166;227;161m"
SAPPHIRE="\033[38;2;116;199;236m"
LAVENDER="\033[38;2;180;190;254m"
OVERLAY="\033[38;2;108;112;134m"
RESET="\033[0m"

# --- Build status line ---
parts=()

# User segment
parts+=("$(printf "${RED}%s${RESET}" "$user")")

# Directory segment
parts+=("$(printf "${PEACH}%s${RESET}" "$basename_dir")")

# Git segment
if [ -n "$git_branch" ]; then
  if [ -n "$pr_number" ]; then
    seg=""
    seg+=$(printf "${YELLOW}%s%s${RESET}" "$git_branch" "$git_status_str")
    seg+=" "
    seg+=$(printf "${OVERLAY}·${RESET}")
    seg+=" "
    seg+=$(printf "${OVERLAY}PR ${RESET}")
    seg+=$(printf '\033]8;;%s\033\\' "$pr_url")
    seg+=$(printf "${YELLOW}#%s${RESET}" "$pr_number")
    seg+=$(printf '\033]8;;\033\\')
    parts+=("$seg")
  else
    parts+=("$(printf "${YELLOW}%s%s${RESET}" "$git_branch" "$git_status_str")")
  fi
fi

# Model segment
if [ -n "$model" ]; then
  parts+=("$(printf "${SAPPHIRE}%s${RESET}" "$model")")
fi

# Context window segment
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  if [ "$used_int" -ge 80 ]; then
    ctx_color="$RED"
  elif [ "$used_int" -ge 50 ]; then
    ctx_color="$YELLOW"
  else
    ctx_color="$GREEN"
  fi
  parts+=("$(printf "${ctx_color}ctx:%s%%${RESET}" "$used_int")")
fi

# Time segment
parts+=("$(printf "${LAVENDER}%s${RESET}" "$time_str")")

# Join with separator
sep="$(printf "${OVERLAY} | ${RESET}")"
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="$result$sep$part"
  fi
done

# Update tmux pane title (shows in window tabs via #T)
if [ -n "$TMUX" ]; then
  title="Claude: ${basename_dir}"
  [ -n "$git_branch" ] && title="$title [$git_branch]"
  printf '\033Ptmux;\033\033]2;%s\007\033\\' "$title" > /dev/tty
fi

printf '%s\n' "$result"
