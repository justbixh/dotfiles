#!/usr/bin/env zsh
# macos-defaults.sh
# Run once after a fresh macOS setup, or re-run at any time to reapply.

# Run 'defaults read NSGlobalDomain KeyRepeat' to view the current value.

echo "Setting macOS defaults..."

# set hostname
sudo scutil --set HostName "Bishnu-MacBook-Air"

# --- UI & Finder Preferences ---
defaults write com.apple.dock autohide -bool true                   # Dock: auto-hide (default: false)
defaults write com.apple.finder AppleShowAllExtensions -bool true   # Finder: always show file extensions (default: false)
defaults write com.apple.finder ShowPathbar -bool true              # Finder: show full path bar (default: false)
defaults write com.apple.finder FXPreferredViewStyle -string "clmv" # Finder: default to column view (default: icnv)

# Screenshot save location (default: ~/Desktop). Ensure the custom folder exists first!
mkdir -p ~/Pictures/screenshots
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"

# --- Terminal Performance & Keyboard Repeat Speeds ---
# KeyRepeat: The speed at which a character repeats after you hold it down. (default: 6)
# UI max is 2 (30ms). Setting it to 1 (15ms) doubles Vim navigation speed.
defaults write NSGlobalDomain KeyRepeat -int 2

# InitialKeyRepeat: The pause duration between your first physical keypress and when the key starts repeating. (default: 35)
# UI max is 15 (225ms). Lowering it to 10 (150ms) makes Vim cursor movements feel instantly responsive
# without causing accidental double-typing when you just want a single press.
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable press-and-hold accent menu (fixes severe key repeat lockups in Vim)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# remove the delay entirely (default = 0.5)
defaults write com.apple.dock autohide-delay -float 0

# make the sliding animation faster (default = 1.0)
defaults write com.apple.dock autohide-time-modifier -float 0.4

# --- Apply Changes ---
killall Dock
killall Finder

echo "Done. Some settings (key repeat) require logout/restart to fully apply."
