cw() {
  local repo
  repo=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo"; return 1; }

  if [ "$1" = "--clean" ]; then
    local merged=$(git -C "$repo" branch --merged main)
    for wt in "$repo"/.worktrees/*/; do
      local branch=$(basename "$wt")
      if echo "$merged" | grep -q "$branch"; then
        echo "Removing merged worktree: $branch"
        git -C "$repo" worktree remove "$wt"
        git -C "$repo" branch -d "$branch"
      fi
    done
    git -C "$repo" worktree prune
    return
  fi

  if [ -z "$1" ]; then
    git -C "$repo" worktree list
    return
  fi

  local branch="$1"
  local wt="$repo/.worktrees/$branch"

  if ! grep -qx '.worktrees/' "$repo/.gitignore" 2>/dev/null; then
    echo "warning: .worktrees/ is not in $repo/.gitignore"
  fi

  if [ ! -d "$wt" ]; then
    git -C "$repo" fetch origin
    if git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      git -C "$repo" worktree add "$wt" "$branch"
    else
      git -C "$repo" worktree add "$wt" -b "$branch" origin/main
    fi
    (cd "$wt" && npm install)
  fi

  cd "$wt" || return 1
  if command -v claude >/dev/null; then
    claude
  else
    echo "claude is not installed — dropped into worktree at $wt"
  fi
}
