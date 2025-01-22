#!/bin/zsh

# Get the current directory
currentDirectory=$(pwd)

# Create symbolic link for .ideavimrc
ideavimrcLocation="$currentDirectory/rider/.ideavimrc"
ln -sf "$ideavimrcLocation" "$HOME/.ideavimrc"

# Create symbolic link for .vimrc
vimrcLocation="$currentDirectory/vim/.vimrc"
ln -sf "$vimrcLocation" "$HOME/.vimrc"

# Create the .config directory if it doesn't exist
mkdir -p "$HOME/nvim/.config"
nvimDirectory="$currentDirectory/nvim/.config/nvim"
ln -sf "$nvimDirectory" "$HOME/.config/nvim"

# Set XDG_CONFIG_HOME environment variable
export XDG_CONFIG_HOME="$HOME/.config"

# Create the .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Create symbolic link for whkdrc
whkdrcLocation="$currentDirectory/komorebi/whkdrc"
ln -sf "$whkdrcLocation" "$HOME/.config/whkdrc"

# Copy komorebi.json and applications.json
komorebiLocation="$currentDirectory/komorebi/komorebi.json"
cp "$komorebiLocation" "$HOME/komorebi.json"
komorebiApplicationsLocation="$currentDirectory/komorebi/applications.json"
cp "$komorebiApplicationsLocation" "$HOME/applications.json"

# Create symbolic link for komorebi.bar.json
komorebiBarLocation="$currentDirectory/komorebi/komorebi.bar.json"
ln -sf "$komorebiBarLocation" "$HOME/komorebi.bar.json"

# Create symbolic link for lazygit
lazygitDirectory="$currentDirectory/lazygit"
ln -sf "$lazygitDirectory" "$HOME/.config/lazygit"

# Create symbolic link for aichat (on macOS, environment variables are set differently)
aichatDirectory="$currentDirectory/aichat"
ln -sf "$aichatDirectory" "$HOME/aichat"

# For Windows Terminal settings, there's no direct equivalent on macOS, so we skip this step

