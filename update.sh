#!/bin/bash

clear
# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para obter o nome do sistema operacional
get_system_os() {
    grep -E '^NAME=' /etc/os-release | sed 's/^NAME=//g' | tr -d '"'
}

os_name="$(get_system_os)"

# Verifica qual gerenciador de pacotes usar
if command_exists dnf && [[ "$os_name" == "Fedora Linux" || "$os_name" == "CentOS Linux" || "$os_name" == "Red Hat Enterprise Linux" ]]; then
    echo "Detected Fedora/CentOS/RHEL"
    sudo dnf upgrade -y
elif command_exists apt-get && [[ "$os_name" == "Ubuntu" || "$os_name" == "Debian GNU/Linux" ]]; then
    echo "Detected Ubuntu/Debian"
    sudo apt-get update -y
    sudo apt-get upgrade -y
elif command_exists yay && [[ "$os_name" == "Arch Linux" ]]; then
    echo "Detected Arch Linux"
    yay -Syu --noconfirm
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Atualiza Snap
if command_exists snap; then
    echo "Checking and updating Snap packages"
    sudo snap refresh
fi

# Atualiza Flatpak
if command_exists flatpak; then
    echo "Checking and updating Flatpak packages"
    flatpak update -y
fi
    echo "System update completed."