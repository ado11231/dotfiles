# arch-dotfiles

My Arch Linux dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

- **Setup** — Arch Linux, GNOME on Wayland, i7-11700K + RTX 4060, bash
- **Tools** — [eza](https://github.com/eza-community/eza), [bat](https://github.com/sharkdp/bat), [zoxide](https://github.com/ajhaupt7/zoxide), [fzf](https://github.com/junegunn/fzf), [starship](https://starship.rs), [mise](https://mise.jdx.dev)

## Layout

```
.
├── dot_bashrc                 → ~/.bashrc
├── dot_gitconfig              → ~/.gitconfig
├── pkglist.txt                pacman packages (excluded from $HOME)
└── private_dot_config/        → ~/.config/
    ├── fontconfig/fonts.conf
    ├── gh/config.yml
    ├── gtk-3.0/settings.ini
    ├── gtk-4.0/settings.ini
    ├── mise/config.toml
    └── starship.toml
```

## Install

```bash
sudo pacman -S --needed - < pkglist.txt
chezmoi init --apply https://github.com/ado11231/arch-dotfiles.git
mise install
```