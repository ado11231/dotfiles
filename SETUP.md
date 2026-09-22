# setup

### layout

```
dot_bashrc              → ~/.bashrc
dot_gitconfig           → ~/.gitconfig
private_dot_config/     → ~/.config
  fontconfig/fonts.conf   font rendering (hinting, subpixel, synthetic bold/italic)
  gh/config.yml           GitHub CLI
  git/ignore              global gitignore
  gtk-3.0, gtk-4.0        GTK theme/font settings for non-GNOME apps
  mise/config.toml        default runtime versions
  starship.toml           prompt
gnome/                  not deployed — reference dumps
  dconf.ini               full GNOME settings dump
  extensions.txt          enabled shell extensions
system/                 not deployed — root-owned files
  keyd/default.conf     → /etc/keyd/default.conf
pkglist.txt             explicitly installed packages
```

Everything outside `private_dot_config/`, `dot_bashrc` and `dot_gitconfig` is listed in
`.chezmoiignore`, so chezmoi never writes it to `$HOME`. Those files are applied by hand
(see below).

### install

```bash
# packages first (yay for the AUR entries in pkglist.txt)
yay -S --needed - < pkglist.txt

# dotfiles
chezmoi init --apply https://github.com/ado11231/dotfiles.git
```

Then the pieces chezmoi does not manage:

```bash
# GNOME settings and extensions
dconf load / < gnome/dconf.ini
xargs -n1 gnome-extensions enable < gnome/extensions.txt

# caps lock arrow layer
sudo install -Dm644 system/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
```

Log out and back in after loading the dconf dump.

### updating

```bash
chezmoi re-add                                  # pull config changes back into the repo
pacman -Qqe > pkglist.txt                       # refresh package list
dconf dump / > gnome/dconf.ini                  # refresh GNOME settings
gnome-extensions list --enabled > gnome/extensions.txt
```

`dconf.ini` is a full dump, so it carries window sizes and other per-machine state — it is
meant as a reference to diff against, not something to load on an unrelated machine without
reading it first.
