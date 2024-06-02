#!/bin/bash

# Check if the user has sudo privileges
if ! sudo -n true 2>/dev/null; then
    echo "You need to be sudo to run this script."
    exit 1
fi

# Installing dependencies
echo "Updating and Installing dependencies"
apt update && apt upgrade -y && apt install -y nala git curl fzf exa stow bat

# Check if zsh is installed
if command -v zsh >/dev/null 2>&1; then
    echo "zsh is installed."

    # Check if zsh is already the default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s $(which zsh)

        # Verify if the change was successful
        if [ "$SHELL" == "$(which zsh)" ]; then
            echo "Default shell changed to zsh."
            echo "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        else
            echo "Failed to change default shell to zsh."
        fi
    else
        echo "zsh is already the default shell."
    fi
fi

echo "Cloning dotfiles repo from github"

git clone https://github.com/PedroBuffon/dotfiles.git

cd ~/dotfiles

stow .