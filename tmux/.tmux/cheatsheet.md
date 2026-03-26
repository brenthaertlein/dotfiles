# Tmux Cheatsheet

Prefix is `Ctrl-b`. Entries marked `*` in the picker are executable.

## Sessions
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `prefix + O`  | SessionX — fuzzy session switcher           |                                            |
| `prefix + d`  | Detach from session                         | detach-client                              |
| `prefix + $`  | Rename session                              | command-prompt -I "#S" "rename-session %%" |
| `prefix + s`  | List sessions (built-in tree)               | choose-tree -s                             |
| `prefix + (`  | Switch to previous session                  | switch-client -p                           |
| `prefix + )`  | Switch to next session                      | switch-client -n                           |
| `prefix + L`  | Switch to last session                      | switch-client -l                           |

## Windows
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `prefix + c`  | New window                                  | new-window                                 |
| `prefix + ,`  | Rename window                               | command-prompt -I "#W" "rename-window %%" |
| `prefix + &`  | Kill window                                 | confirm-before -p "kill window? (y/n)" kill-window |
| `prefix + n`  | Next window                                 | next-window                                |
| `prefix + p`  | Previous window                             | previous-window                            |
| `prefix + w`  | List windows (built-in tree)                | choose-tree -w                             |
| `prefix + 1-9`| Jump to window by number                    |                                            |
| `prefix + .`  | Move window to another session (by index)   | command-prompt "move-window -t '%%'"       |
| `prefix + S`  | Send window to a new session (prompts name) |                                            |

## Panes
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `prefix + \|` | Split horizontally                          | split-window -h                            |
| `prefix + -`  | Split vertically                            | split-window -v                            |
| `prefix + j`  | Move pane to another window (picker)        | choose-window "join-pane -t '%%'"          |
| `prefix + B`  | Break pane into its own window              | break-pane                                 |
| `prefix + x`  | Kill pane                                   | confirm-before -p "kill pane? (y/n)" kill-pane |
| `prefix + z`  | Toggle pane zoom (fullscreen)               | resize-pane -Z                             |
| `prefix + q`  | Show pane numbers (type number to jump)     | display-panes                              |
| `prefix + {`  | Swap pane up                                | swap-pane -U                               |
| `prefix + }`  | Swap pane down                              | swap-pane -D                               |
| `prefix + Space` | Cycle pane layouts                       | next-layout                                |

## Copy Mode (Vi)
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `prefix + [`  | Enter copy mode                             | copy-mode                                  |
| `v`           | Begin selection (in copy mode)              |                                            |
| `y`           | Yank selection (in copy mode)               |                                            |
| `prefix + ]`  | Paste buffer                                | paste-buffer                               |

## Custom
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `Ctrl-x`      | Toggle pane broadcast                      | setw synchronize-panes                     |
| `prefix + r`  | Reload config                               | source-file ~/.tmux.conf                   |
| `prefix + h`  | This cheatsheet                             |                                            |

## Plugins
| Binding       | Action                                      | Command                                    |
|---------------|---------------------------------------------|--------------------------------------------|
| `prefix + I`  | Install TPM plugins                         |                                            |
| `prefix + U`  | Update TPM plugins                          |                                            |
