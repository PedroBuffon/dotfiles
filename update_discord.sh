#!/bin/bash

# Check if curl is installed; if not, install it
command -v curl &>/dev/null || sudo apt-get -y install curl

# Get the current installed version of Discord
current_version=$(apt-cache show discord | grep '^Version:')
current_version=${current_version##Version: }

# URL to check for the latest Discord version for Linux in .deb format
update_url="https://discord.com/api/download?platform=linux&format=deb"

# Get the actual download URL which contains the version number
download_url=$(curl -w "%{url_effective}" -ILSs "$update_url" -o /dev/null)

# Extract the version number from the download URL
upstream_version=$(awk -F/ '{print $6}' <<<"$download_url")

# Determine the higher version between the current and upstream version
higher_version=$(
    printf "%s\n" "$upstream_version" "$current_version" |
    sort --version-sort --reverse | head -1
)

# If the upstream version is higher, update the application
if [[ $current_version != $higher_version ]]; then
    # Close the Discord app if it is running
    pkill -f discord
    
    # Download the new version
    curl -sO "$download_url"
    filename=${download_url##*/}
    
    # Install the new version
    sudo apt-get -y --fix-broken install ./"$filename"
    
    # Restart the Discord app
    discord &
else
    # If no new version is available, print a message
    echo "No new Discord version available"
fi
