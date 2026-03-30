cw() {
  local repo
  repo=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not in a git repo"; return 1; }

  local clean=false force=false remove=false branch=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --clean) clean=true ;;
      --remove) remove=true ;;
      --force|-f) force=true ;;
      -*) echo "Unknown option: $1"; return 1 ;;
      *) branch="$1" ;;
    esac
    shift
  done

  if $remove; then
    if [ -z "$branch" ]; then
      case "$PWD" in
        "$repo"/.worktrees/*)
          branch="${PWD#$repo/.worktrees/}"
          branch="${branch%%/*}"
          ;;
        *)
          echo "Not inside a worktree — specify a branch name: cw --remove <branch>"
          return 1
          ;;
      esac
    fi
    local wt="$repo/.worktrees/$branch"
    if [ ! -d "$wt" ]; then
      echo "No worktree found for branch: $branch"
      return 1
    fi
    if ! $force; then
      if [ -n "$(git -C "$wt" status --porcelain 2>/dev/null)" ]; then
        echo "Worktree '$branch' has uncommitted changes — use --force to remove anyway"
        return 1
      fi
      local upstream
      upstream=$(git -C "$wt" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
      if [ -n "$upstream" ] && [ -n "$(git -C "$wt" log "$upstream..HEAD" 2>/dev/null)" ]; then
        echo "Worktree '$branch' has unpushed commits — use --force to remove anyway"
        return 1
      fi
    fi
    if [ "${PWD#$wt}" != "$PWD" ]; then
      cd "$repo" || return 1
    fi
    local force_flag=""
    $force && force_flag="--force"
    git -C "$repo" worktree remove $force_flag "$wt"
    git -C "$repo" branch -D "$branch" 2>/dev/null
    git -C "$repo" worktree prune
    echo "Removed worktree and branch: $branch"
    return
  fi

  if $clean; then
    local force_flag=""
    $force && force_flag="--force"
    local merged=$(git -C "$repo" branch --merged main)
    for wt in "$repo"/.worktrees/*/; do
      local b=$(basename "$wt")
      if echo "$merged" | grep -q "$b"; then
        echo "Removing merged worktree: $b"
        git -C "$repo" worktree remove $force_flag "$wt"
        git -C "$repo" branch -D "$b" 2>/dev/null
      fi
    done
    git -C "$repo" worktree prune
    return
  fi

  if [ -z "$branch" ]; then
    git -C "$repo" worktree list
    return
  fi

  local wt="$repo/.worktrees/$branch"

  if ! grep -qx '.worktrees/' "$repo/.gitignore" 2>/dev/null; then
    echo "warning: .worktrees/ is not in $repo/.gitignore"
  fi

  if [ ! -d "$wt" ]; then
    git -C "$repo" fetch origin
    if git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
      git -C "$repo" worktree add "$wt" "$branch"
    elif git -C "$repo" show-ref --verify --quiet "refs/heads/$branch"; then
      git -C "$repo" worktree add "$wt" "$branch"
    else
      git -C "$repo" worktree add "$wt" -b "$branch" origin/main
    fi
    if [ -f "$wt/package.json" ]; then
      (cd "$wt" && npm install)
    elif [ -f "$wt/requirements.txt" ] || [ -f "$wt/pyproject.toml" ]; then
      (cd "$wt" && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt 2>/dev/null; pip install -e '.[dev]' 2>/dev/null)
    fi
  fi

  cd "$wt" || return 1
  if [ -f "$wt/.venv/bin/activate" ]; then
    source "$wt/.venv/bin/activate"
  fi
  if command -v claude >/dev/null; then
    claude
  else
    echo "claude is not installed — dropped into worktree at $wt"
  fi
}
