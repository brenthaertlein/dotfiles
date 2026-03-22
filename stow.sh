#!/usr/bin/env bash
modules=(zsh starship tmux vim)
for m in "${modules[@]}"; do stow --target="$HOME" "$m"; done
