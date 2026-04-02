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

cd "$DOTFILES_ROOT/ansible"
ansible-playbook -i inventory/local.ini playbooks/terminal.yml
