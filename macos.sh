
#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"
killall SystemUIServer || true
