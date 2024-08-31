#!/bin/bash

echo "THIS SCRIPT IS STILL IN DEVELOPMENT. DON'T USE IT IF YOU DON'T KNOW WHAT YOU'RE DOING"

# Ask if the user wants to change the UID and GID for the mediarr stack
read -p "Do you want to set locale? (default: en_US.UTF-8) (y/n): " change_locale
if [ "$change_locale" = "y" ] || [ "$change_locale" = "Y" ]; then
    read -p "Enter the locale (default: en_US.UTF-8): " locale
    locale=${locale:-en_US.UTF-8}

    echo "Updating locale"
    sudo update-locale LANG="$locale"
    sudo dpkg-reconfigure -f noninteractive locales
else
    sudo update-locale LANG=en_US.UTF-8
    sudo dpkg-reconfigure -f noninteractive locales
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
    dnf install yazi ffmpegthumbnailer p7zip jq poppler fd ripgrep fzf zsh zoxide imagemagick stow eza btop git fastfetch
elif command_exists apt-get && { [ "$check_os" = "Ubuntu" ] || [ "$check_os" = "Debian" ] || [ "$check_os" = "Debian GNU/Linux" ]; }; then
    echo "Detected Ubuntu or Debian"
    apt-get update && apt-get install zsh fzf stow exa btop git zoxide
    echo "Installing fastfetch"
    curl -L --output fastfetch.deb https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb && sudo dpkg -i fastfetch.deb
elif command_exists yay && [ "$check_os" = "Arch Linux"]; then
    echo "Detected Arch"
    yay -S --noconfirm yazi ffmpegthumbnailer p7zip jq poppler fd ripgrep fzf zsh zoxide imagemagick stow eza btop git fastfetch
else
    echo "Unsupported distribution. Exiting."
    exit 1
fi

# Clone the repository
echo "Cloning the repository..."
git clone https://github.com/PedroBuffon/dotfiles.git ~/dotfiles

echo "making backup for .zshrc .bashrc and .profile"

mv ~/.zshrc ~/.zshrcbk
mv ~/.bashrc ~/.bashrcbk
mv ~/.profile ~/.profilebk

cd dotfiles
stow .

echo "Installing Oh My ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm ~/.zshrc
stow .

echo "Installing Auto Suggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing Atuin"
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Display the ports to the user
echo "Setup completed. Please log out and log in"