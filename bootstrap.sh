#!/usr/bin/env bash
set -e

DOTFILES_ROOT="$(cd "$(dirname "$0")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
  "$DOTFILES_ROOT/bootstrap/macos.sh"
  "$DOTFILES_ROOT/macos.sh" || true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  "$DOTFILES_ROOT/bootstrap/ubuntu.sh"
else
  echo "Unsupported OS: $OSTYPE" >&2
  exit 1
fi

"$DOTFILES_ROOT/stow.sh"

# ── plugin installs (headless, after stow so configs are in place) ───────────

# tmux: clone TPM + install plugins
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins"

# vim: install plugins headless
vim -es -u "$HOME/.vimrc" +PlugInstall +qall
