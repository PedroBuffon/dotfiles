#!/bin/bash

# Check if the user has sudo privileges
if ! sudo -n true 2>/dev/null; then
    echo "You need to be sudo to run this script."
    exit 1
fi

# Installing dependencies
echo "Updating and Installing dependencies"
apt update && apt upgrade -y && apt install -y nala git curl fzf exa stow bat zsh gdu

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

# Function to create a backup of a file
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="${file}_backup_$timestamp"
        cp "$file" "$backup_file"
        echo "Backup of $file created as $backup_file"
    else
        echo "$file does not exist."
    fi
}

# Ask the user if they want to back up .bashrc
read -p "The script will delete your .bashrc do you want to back it up? (yes/no): " backup_bashrc
if [ "$backup_bashrc" == "yes" ]; then
    backup_file "$HOME/.bashrc"
else
    rm .bashrc
fi

# Ask the user if they want to back up .profile
read -p "The script will delete your .profile do you want to back it up? (yes/no): " backup_profile
if [ "$backup_profile" == "yes" ]; then
    backup_file "$HOME/.profile"
else
    rm .profile
fi

# Check if .zshrc exists and ask the user if they want to back it up
if [ -f "$HOME/.zshrc" ]; then
    read -p "The script found a .zshrc iot will be replaced do you want to back up .zshrc? (yes/no): " backup_zshrc
    if [ "$backup_zshrc" == "yes" ]; then
        backup_file "$HOME/.zshrc"
    else
        rm .zshrc
    fi
fi

echo "Backup process completed."

cd dotfiles/

stow .