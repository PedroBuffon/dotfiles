#!/bin/bash

# Verifica se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "Por favor, execute como root (sudo $0)"
    exit 1
fi

echo "THIS SCRIPT IS STILL IN DEVELOPMENT. DON'T USE IT IF YOU DON'T KNOW WHAT YOU'RE DOING"

# Ask if the user wants to change the UID and GID for the mediarr stack
read -p "Do you want to set locale? (default: en_US.UTF-8) (y/n): " change_locale
if [ "$change_locale" = "y" ] || [ "$change_locale" = "Y" ]; then
    read -p "Enter the locale (default: en_US.UTF-8): " locale
    locale=${locale:-en_US.UTF-8}

    echo "Updating locale"
    update-locale LANG="$locale"
    dpkg-reconfigure -f noninteractive locales
else
    update-locale LANG=en_US.UTF-8
    dpkg-reconfigure -f noninteractive locales
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function that detects which OS is running
check_system_os(){
    grep -E '^NAME=' /etc/os-release | sed 's/^NAME=//g' | tr -d '"'
}

# Check the OS and print it for debugging
check_os=$(check_system_os)

# Check which package manager to use based on the distribution
if command_exists dnf && [ "$check_os" = "Fedora" ]; then
    echo "Detected Fedora or CentOS/RHEL"
    dnf install -y yazi ffmpegthumbnailer p7zip jq poppler fd ripgrep fzf zsh zoxide imagemagick stow eza btop git fastfetch || { echo "Falha ao instalar pacotes"; exit 1; }
elif command_exists apt-get && { [ "$check_os" = "Ubuntu" ] || [ "$check_os" = "Debian" ] || [ "$check_os" = "Debian GNU/Linux" ]; }; then
    echo "Detected Ubuntu or Debian"
    apt-get update && apt-get install -y zsh fzf stow exa btop git zoxide || { echo "Falha ao instalar pacotes"; exit 1; }
    echo "Installing fastfetch"
    curl -L --output fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb && dpkg -i fastfetch.deb || { echo "Falha ao instalar fastfetch"; exit 1; }
elif command_exists yay && [ "$check_os" = "Arch Linux"]; then
    echo "Detected Arch"
    yay -S --noconfirm yazi ffmpegthumbnailer p7zip jq poppler fd ripgrep fzf zsh zoxide imagemagick stow eza btop git fastfetch || { echo "Falha ao instalar pacotes"; exit 1; }
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Clone the repository
echo "Cloning the repository..."
if [ -d "$REPO_DIR" ]; then
    echo "Pasta $REPO_DIR já existe. Pulando clone."
else
    echo "Clonando o repositório..."
    git clone https://github.com/PedroBuffon/dotfiles.git "$REPO_DIR" || { echo "Falha ao clonar repositório"; exit 1; }
fi

echo "making backup for .zshrc .bashrc and .profile"

for file in .zshrc .bashrc .profile; do
    if [ -f "$HOME/$file" ]; then
        echo "Fazendo backup de $file"
        mv "$HOME/$file" "$HOME/${file}bk"
    fi
done

cd "$REPO_DIR" || { echo "Falha ao acessar pasta do repositório"; exit 1; }
stow . || { echo "Falha ao rodar stow"; exit 1; }

echo "Installing Oh My ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || { echo "Falha ao instalar Oh My ZSH"; exit 1; }

if [ -f "$HOME/.zshrc" ]; then
    rm "$HOME/.zshrc"
    stow .
fi

echo "Installing Auto Suggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || echo "Auto Suggestions já instalado ou falhou"

echo "Installing Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || echo "Syntax Highlighting já instalado ou falhou"

echo "Installing Atuin"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh || echo "Falha ao instalar Atuin"

# Display the ports to the user
echo "Setup completed. Please log out and log in"