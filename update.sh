#!/bin/bash
clear
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_system_os(){
    grep -E '^NAME=' /etc/os-release | sed 's/^NAME=//g' | tr -d '"' >/dev/null 2>&1
}

# Check which package manager to use based on the distribution
if command_exists dnf && check_system_os === Fedora; then
    echo "Detected Fedora or CentOS/RHEL"
    sudo dnf upgrade
elif command_exists apt-get && { [ "$check_system_os" == "Ubuntu" ] || [ "$check_system_os" == "Debian" ]; }; then
    # Commands for Ubuntu or Debian
    sudo apt-get update
    sudo apt-get upgrade
elif command_exists pacman && check_system_os === Arch Linux; then
    echo "Detected Arch"
    sudo pacman -Syu
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Update Snap
if command_exists snap; then
    echo "Cheking and updating Snap Updates"
    sudo snap refresh
fi

# Update Flatpak
if command_exists flatpak; then
    echo "Cheking and updating Flatpak Updates"
    sudo flatpak update
fi