#!/bin/bash

echo "THIS SCRIPT IS STILL IN DEVELOPMENT. DON'T USE IT IF YOU DON'T KNOW WHAT YOU'RE DOING"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function that detects which OS is running
check_system_os(){
    grep -E '^NAME=' /etc/os-release | sed 's/^NAME=//g' | tr -d '"'
}

dependencies="zsh fzf stow eza btop git yazi"

# Check the OS and print it for debugging
check_os=$(check_system_os)

# Check which package manager to use based on the distribution
if command_exists dnf && [ "$check_os" = "Fedora" ]; then
    echo "Detected Fedora or CentOS/RHEL"
    dnf install $dependencies
elif command_exists apt-get && { [ "$check_os" = "Ubuntu" ] || [ "$check_os" = "Debian" ] || [ "$check_os" = "Debian GNU/Linux" ]; }; then
    echo "Detected Ubuntu or Debian"
    apt-get update && apt-get install $dependencies
elif command_exists yay && [ "$check_os" = "Arch Linux"]; then
    echo "Detected Arch"
    yay -Syu
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Clone the repository
echo "Cloning the repository..."
git clone https://github.com/PedroBuffon/dotfiles.git ~/dotfiles

# Display the ports to the user
echo "Setup completed. Please log out and log in"