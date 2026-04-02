#!/usr/bin/env bash
set -e

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# ── apt packages (all sudo usage consolidated here) ──────────────────────────

echo "==> Installing apt packages..."
sudo apt-get update
sudo apt-get install -y \
  zsh \
  tmux \
  git \
  fzf \
  ripgrep \
  bat \
  zoxide \
  tree \
  btop \
  cmatrix \
  mtr \
  curl \
  wget \
  jq \
  stow \
  ansible \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  python3 \
  python3-pip \
  python3-venv \
  unzip

echo "==> Adding external apt repos..."

# GitHub CLI
if ! command -v gh >/dev/null; then
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y gh
fi

# eza
if ! command -v eza >/dev/null; then
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y eza
fi

# Node.js (prebuilt via NodeSource)
if ! command -v node >/dev/null; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi

# Set zsh as default shell (last sudo operation)
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

# ── user-local installs (no sudo beyond this point) ──────────────────────────

echo "==> Installing user-local tools..."

# bat is installed as 'batcat' on Ubuntu — symlink to expected name
[ ! -e "$LOCAL_BIN/bat" ] && ln -s /usr/bin/batcat "$LOCAL_BIN/bat"

# starship
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$LOCAL_BIN"
fi

# fastfetch (extract binary from deb without sudo)
if ! command -v fastfetch >/dev/null; then
  FASTFETCH_VERSION=$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r .tag_name)
  curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -o /tmp/fastfetch.deb
  dpkg-deb -x /tmp/fastfetch.deb /tmp/fastfetch-extract
  cp /tmp/fastfetch-extract/usr/bin/fastfetch "$LOCAL_BIN/fastfetch"
  rm -rf /tmp/fastfetch.deb /tmp/fastfetch-extract
fi

# k9s
if ! command -v k9s >/dev/null; then
  K9S_VERSION=$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
  curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" -o /tmp/k9s.tar.gz
  tar -xzf /tmp/k9s.tar.gz -C "$LOCAL_BIN" k9s
  rm /tmp/k9s.tar.gz
fi

# AWS CLI (install or update to ~/.local)
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -qo /tmp/awscliv2.zip -d /tmp
/tmp/aws/install --install-dir "$HOME/.local/aws-cli" --bin-dir "$LOCAL_BIN" --update
rm -rf /tmp/aws /tmp/awscliv2.zip

# fzf-tab (zsh plugin — no apt package)
FZF_TAB_DIR="$HOME/.zsh/fzf-tab"
if [ ! -d "$FZF_TAB_DIR" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
fi

# ── asdf (user-local version manager) ────────────────────────────────────────

echo "==> Installing asdf..."

# asdf 0.16+ is a Go binary, not a bash script
if ! command -v asdf >/dev/null; then
  ASDF_VERSION=$(curl -fsSL https://api.github.com/repos/asdf-vm/asdf/releases/latest | jq -r .tag_name)
  curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-amd64.tar.gz" -o /tmp/asdf.tar.gz
  tar -xzf /tmp/asdf.tar.gz -C "$LOCAL_BIN"
  rm /tmp/asdf.tar.gz
fi

export PATH="$LOCAL_BIN:$PATH"

# Install asdf plugins and versions from .tool-versions, set as global defaults
TOOL_VERSIONS="$DOTFILES_ROOT/.tool-versions"
if [ -f "$TOOL_VERSIONS" ]; then
  while IFS=' ' read -r plugin version; do
    [[ -z "$plugin" || "$plugin" == \#* ]] && continue
    asdf plugin add "$plugin" 2>/dev/null || true
    asdf install "$plugin" "$version"
    asdf set --home "$plugin" "$version"
  done < "$TOOL_VERSIONS"
fi

echo "==> Ubuntu bootstrap complete."
