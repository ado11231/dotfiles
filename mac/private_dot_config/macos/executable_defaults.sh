#!/usr/bin/env bash
# macOS settings. Safe to re-run. Apply with: bash ~/.config/macos/defaults.sh

# --- Dock ---
defaults write com.apple.dock show-recents -bool false          # no "recent apps" section

# --- Finder ---
defaults write com.apple.finder ShowPathbar -bool true           # path bar at the bottom
defaults write com.apple.finder ShowStatusBar -bool true         # item count / free space
defaults write NSGlobalDomain AppleShowAllExtensions -bool true  # always show .pdf, .zip, ...

killall Dock Finder 2>/dev/null
echo "macOS settings applied."
