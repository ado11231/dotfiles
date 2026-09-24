# setup

### layout

Paths are relative to `mac/`.

```
dot_zshenv              → ~/.zshenv      cargo env
dot_zprofile            → ~/.zprofile    Homebrew
dot_zshrc               → ~/.zshrc       PATH, history, completion, tools, plugins
dot_gitconfig           → ~/.gitconfig
dot_Brewfile            → ~/.Brewfile    formulae, casks, VS Code extensions, cargo/npm globals
bin/executable_dev      → ~/bin/dev      tmux project launcher
private_dot_config/     → ~/.config
  gh/config.yml           GitHub CLI
  git/ignore              global gitignore
  kitty/                  kitty.conf + light/dark/no-preference theme files
  macos/defaults.sh       Dock and Finder settings (run by hand)
  mise/config.toml        default runtime versions
  starship.toml           prompt
  tmux/tmux.conf          tmux
```

### install

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# dotfiles: clone, point chezmoi at the mac/ folder, apply
brew install chezmoi
git clone https://github.com/ado11231/dotfiles.git ~/.local/share/chezmoi
mkdir -p ~/.config/chezmoi
echo 'sourceDir = "~/.local/share/chezmoi/mac"' > ~/.config/chezmoi/chezmoi.toml
chezmoi apply

# packages, runtimes, macOS settings
brew bundle --global
mise install
bash ~/.config/macos/defaults.sh
```

Open a new terminal afterwards.

### updating

```bash
chezmoi re-add                          # pull config changes back into the repo
brew bundle dump --global --force       # refresh the Brewfile
chezmoi re-add ~/.Brewfile
```

New settings for `defaults.sh` are added to the script by hand.
