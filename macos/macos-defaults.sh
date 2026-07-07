#!/usr/bin/env bash
# macos-defaults.sh
# Run once after a fresh macOS setup, or re-run any time to reapply.

echo "Setting macOS defaults..."

# Finder: show all hidden files
# defaults delete com.apple.finder AppleShowAllFiles
# defaults write com.apple.finder AppleShowAllFiles TRUE

# Finder: show full path bar at bottom of window
# defaults delete com.apple.finder ShowPathbar
defaults write com.apple.finder ShowPathbar -bool true

# Disable "press and hold" accent picker (needed for key repeat to work in editors like vim)
# defaults delete -g ApplePressAndHoldEnabled
defaults write -g ApplePressAndHoldEnabled -bool false

# Key repeat: faster rate and shorter initial delay
# defaults delete NSGlobalDomain KeyRepeat
defaults write NSGlobalDomain KeyRepeat -int 1

# defaults delete NSGlobalDomain InitialKeyRepeat
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Restart affected services to apply changes immediately
killall Finder

echo "Done. Some settings (key repeat) require logout/restart to fully apply."
