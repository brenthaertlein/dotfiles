
#!/usr/bin/env bash
set -e

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

brew bundle --file=Brewfile || true

./macos.sh || true

cd ansible
ansible-playbook -i inventory/local.ini playbooks/terminal.yml
