# GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) manages symlinks from this repo into your home directory. Each top-level directory is a "package" that mirrors the target directory structure.

## How It Works

The key mental model: **the package directory name gets peeled off, and everything inside maps directly to the target.**

```
# Package directory structure:
dotfiles/zsh/.zshrc
dotfiles/starship/.config/starship.toml

# After `stow --target=$HOME zsh starship`:
~/.zshrc                    →  dotfiles/zsh/.zshrc
~/.config/starship.toml     →  dotfiles/starship/.config/starship.toml
```

Stow creates symlinks, not copies. Editing `~/.zshrc` edits the file in the repo — changes are immediately tracked by git.

## Current Packages

Deployed by `stow.sh`:

| Package | Creates symlink at |
|---|---|
| `zsh` | `~/.zshrc` |
| `vim` | `~/.vimrc` |
| `tmux` | `~/.tmux.conf` |
| `starship` | `~/.config/starship.toml` |

## Common Operations

**Deploy all packages:**
```bash
./stow.sh
```

**Add a new package:**
```bash
mkdir -p newpkg/.config/newpkg/
vim newpkg/.config/newpkg/config.toml
# Add "newpkg" to the modules array in stow.sh
stow --target="$HOME" newpkg
```

**Remove a package's symlinks:**
```bash
stow --target="$HOME" -D pkgname
```

## Gotchas

- **Dangling symlinks:** If you remove a package directory from the repo without unstowing first, the symlink in `$HOME` will point to nothing. You'll get "No such file or directory" errors from tools trying to read the config. Fix: `rm ~/.the-broken-symlink`
- **Conflicts:** If a real file already exists at the target location, stow will refuse to overwrite it. Back up or remove the existing file first.
- **Nested directories:** Stow creates intermediate directories as needed (e.g., `~/.config/` for the starship package). When unstowing, it removes empty directories it created.
