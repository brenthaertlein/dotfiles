# Atuin

[Atuin](https://atuin.sh/) replaces shell history with a SQLite database and provides fuzzy search, sync across machines, and per-session filtering.

## Keybindings

| Key | Action |
|---|---|
| **Ctrl+R** | Atuin fuzzy search (all history) |
| **Up arrow** | Atuin session-filtered search (current session only) |
| **Ctrl+T** | fzf file finder (unchanged) |
| **Alt+C** | fzf directory jumper (unchanged) |

## Config

Config lives in `atuin/.config/atuin/config.toml`, deployed via stow to `~/.config/atuin/config.toml`.

Key settings:

- `sync_address` — URL of your self-hosted atuin server
- `auto_sync = true` — sync after every command
- `search_mode = "fuzzy"` — fuzzy matching (also supports `prefix`, `fulltext`, `skim`)
- `filter_mode_shell_up_key_binding = "session"` — up arrow only searches current session

Full config reference: https://docs.atuin.sh/configuration/config/

## Self-Hosted Sync

Atuin server runs as a Docker container. Official image: `ghcr.io/atuinsh/atuin`.

### First-time setup (after server is running)

```bash
# Register an account on your server
atuin register -u <username> -e <email> -p <password>

# On additional machines, login instead
atuin login -u <username> -p <password>
```

### Import existing history

```bash
# Auto-detect and import from zsh/bash/fish history
atuin import auto
```

## Server Reference

Docker Compose example and server docs: https://docs.atuin.sh/self-hosting/docker/

The server needs:
- A PostgreSQL database
- Port 8888 (default)
- `ATUIN_HOST` and `ATUIN_DB_URI` environment variables

Server infra lives in your homelab repo, not in dotfiles.
