#!/usr/bin/env bash
set -e

DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

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

# bat is installed as 'batcat' on Ubuntu — symlink to expected name
mkdir -p "$HOME/.local/bin"
[ ! -e "$HOME/.local/bin/bat" ] && ln -s /usr/bin/batcat "$HOME/.local/bin/bat"

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

echo "==> Installing tools via direct install..."

# starship
if ! command -v starship >/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# fastfetch
if ! command -v fastfetch >/dev/null; then
  FASTFETCH_VERSION=$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | jq -r .tag_name)
  curl -fsSL "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -o /tmp/fastfetch.deb
  sudo dpkg -i /tmp/fastfetch.deb
  rm /tmp/fastfetch.deb
fi

# k9s
if ! command -v k9s >/dev/null; then
  K9S_VERSION=$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
  curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" -o /tmp/k9s.tar.gz
  tar -xzf /tmp/k9s.tar.gz -C /tmp k9s
  sudo mv /tmp/k9s /usr/local/bin/k9s
  rm /tmp/k9s.tar.gz
fi

# fzf-tab (zsh plugin — no apt package)
FZF_TAB_DIR="$HOME/.zsh/fzf-tab"
if [ ! -d "$FZF_TAB_DIR" ]; then
  git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
fi

echo "==> Installing asdf..."

if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.16.7
fi

source "$HOME/.asdf/asdf.sh"

# Install asdf plugins and versions from .tool-versions
TOOL_VERSIONS="$DOTFILES_ROOT/.tool-versions"
if [ -f "$TOOL_VERSIONS" ]; then
  while IFS=' ' read -r plugin version; do
    [[ -z "$plugin" || "$plugin" == \#* ]] && continue
    asdf plugin add "$plugin" 2>/dev/null || true
    asdf install "$plugin" "$version"
  done < "$TOOL_VERSIONS"
fi

# AWS CLI
if ! command -v aws >/dev/null; then
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -qo /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

echo "==> Ubuntu bootstrap complete."
