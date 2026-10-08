# LazyVim keybinds

A quick reference for my Neovim setup. The config itself lives in
[`mac/private_dot_config/nvim`](../mac/private_dot_config/nvim).

`Space` is the leader key. Press keys one after another, not together:
`Space b d` means Space, then b, then d. Pause after `Space` and a menu
shows every option.

## Layout

```
┌──────────────┬─────────────────────────────────┬──────────────┐
│  Explorer    │  Editor                         │  Terminals   │
│              │                                 │   1  2  3    │
│  󰝰 src       │                                 │              │
│    󰈔 main.py │                                 │  $ _         │
│    󰈔 util.py │                                 │              │
│              │                                 │              │
└──────────────┴─────────────────────────────────┴──────────────┘
     Opt+A   ◀──────────────  Opt+W / Opt+S  ──────────────▶   Opt+D
```

## My keybinds

These are custom, on top of LazyVim's defaults.

### Moving between panels

| Keys | Action |
|---|---|
| `Opt+A` | Go left |
| `Opt+D` | Go right |
| `Opt+W` | Go up |
| `Opt+S` | Go down |

These also work inside tmux, moving between tmux panes and Neovim windows.

### Terminal panel (right side)

| Keys | Action |
|---|---|
| `` Opt+` `` | Show / hide the terminal panel |
| `Opt+T` | New terminal |
| `Opt+↑` / `Opt+↓` | Previous / next terminal |
| `Opt+X` | Close the current terminal |
| `Ctrl+\` `Ctrl+n` | Leave typing mode in the terminal (to scroll or copy) |

### Theme

| Keys | Action |
|---|---|
| `Space u C` | Pick a colorscheme (Nord by default, TokyoNight installed). The pick is remembered. |

## Modes

`Esc` always gets you back to Normal mode.

| Mode | Get in with | For |
|---|---|---|
| Normal | `Esc` | Moving around and running commands |
| Insert | `i` before cursor, `a` after, `o` new line below, `O` new line above | Typing |
| Visual | `v` characters, `V` whole lines | Selecting |
| Command | `:` | Commands like `:w` |

## Editing basics (Normal mode)

| Keys | Action |
|---|---|
| `w` / `b` | Next / previous word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `u` / `Ctrl+r` | Undo / redo |
| `x` | Delete character |
| `dd` | Delete (cut) line |
| `yy` | Copy line |
| `p` | Paste |
| `ciw` | Change the word under the cursor |
| `.` | Repeat last change |
| `gcc` | Comment / uncomment line |
| `/text` then `Enter` | Search; `n` / `N` for next / previous match |
| `Ctrl+s` | Save |
| `:w` / `:q` / `:wq` / `:q!` | Save / quit / save and quit / quit without saving |

## Files and buffers

An open file is a buffer, like a tab in VS Code.

| Keys | Action |
|---|---|
| `Space Space` | Find a file |
| `Space /` | Search text in the project |
| `Space f r` | Recent files |
| `Space e` | Toggle the explorer |
| `Shift+H` / `Shift+L` | Previous / next buffer |
| `Space b d` | Close this buffer (keeps the window) |
| `Space b o` | Close all other buffers |
| `Space b b` | Jump to the last buffer |

### Inside the explorer

| Keys | Action |
|---|---|
| `Enter` | Open file / expand folder |
| `/` | Filter files |
| `a` | New file (end with `/` for a folder) |
| `r` | Rename |
| `d` | Delete |
| `c` / `m` / `p` | Copy / move / paste |
| `H` | Show hidden files |
| `?` | Show all explorer keys |

## Code

| Keys | Action |
|---|---|
| `g d` | Go to definition |
| `g r` | Find references |
| `K` | Show docs for what's under the cursor |
| `Space c a` | Code actions (quick fixes) |
| `Space c r` | Rename symbol |
| `Space c f` | Format file |
| `] d` / `[ d` | Next / previous diagnostic |
| `Space c d` | Show the diagnostic on this line |

## Windows

| Keys | Action |
|---|---|
| `Space \|` | Split right |
| `Space -` | Split below |
| `Space w d` | Close window |
| `Ctrl+←` / `Ctrl+→` | Narrower / wider |

## Git and more

| Keys | Action |
|---|---|
| `Space g g` | Lazygit |
| `Space g b` | Blame this line |
| `Space s k` | Search all keybinds |
| `Space l` | Plugin manager (Lazy) |
| `Space q q` | Quit everything |
