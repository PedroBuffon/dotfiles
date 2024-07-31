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
    dnf upgrade
elif command_exists apt-get && { [ "$check_system_os" == "Ubuntu" ] || [ "$check_system_os" == "Debian" ]; }; then
    # Commands for Ubuntu or Debian
    apt-get update
    apt-get upgrade
elif command_exists yay && check_system_os === Arch Linux; then
    echo "Detected Arch"
    yay -Syu
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Update Snap
if command_exists snap; then
    echo "Cheking and updating Snap Updates"
    snap refresh
fi

# Update Flatpak
if command_exists flatpak; then
    echo "Cheking and updating Flatpak Updates"
    flatpak update
fi
