#!/usr/bin/env bash
modules=(zsh starship tmux vim cw bat)
for m in "${modules[@]}"; do stow --no-folding --target="$HOME" "$m"; done
