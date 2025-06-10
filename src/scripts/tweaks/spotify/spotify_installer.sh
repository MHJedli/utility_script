#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){

    log_message "INFO" "Fetching the security key"
    printc "YELLOW" "-> Fetching the security key..."
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo tee /etc/apt/keyrings/spotify.asc || handle_error "Failed to Fetch Spotify Security Key"

    log_message "INFO" "Adding Spotify APT Repository"
    printc "YELLOW" "-> Adding Spotify APT Repository..."
    echo 'deb [signed-by=/etc/apt/keyrings/spotify.asc] http://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list || handle_error "Failed to Add Spotify APT Repository"

    log_message "INFO" "Removing Old Key (If Existed)"
    printc "YELLOW" "Removing Old Key (If Existed)..."
    if [[ -f /etc/apt/trusted.gpg.d/spotify.gpg ]]; then
        sudo rm /etc/apt/trusted.gpg.d/spotify.gpg
    fi

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Spotify"
    printc "YELLOW" "-> Installing Spotify..."
    sudo apt install spotify-client -y || handle_error "Failed to Install Spotify"

}

install_for_fedora_or_based(){

    log_message "INFO" "Installing Spotify using Flatpak"
    printc "YELLOW" "-> Installing Spotify using Flatpak..."
    if ! command -v flatpak &> /dev/null; then
        handle_error "Flatpak is not installed. Please install Flatpak first."
    fi
    sudo flatpak install flathub com.spotify.Client -y  || handle_error "Failed to Install Spotify using Flatpak"

}

# Begin Spotify Installation
echo "Continue script execution in Spotify Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}..."
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Spotify Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Spotify Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    if whiptail --title "Spotify Installed" --yesno "Do you Want to Install Adblocker for it ?" 8 78; then

        log_message "INFO" "Installing Spotify Ad Blocker"
        printc "YELLOW" "-> Installing Spotify Ad Blocker..."
        bash <(curl -sSL https://spotx-official.github.io/run.sh) -f || handle_error "Failed to Install Spotify Ad Blocker"
        printc "GREEN" "-> Spotify Ad Blocker Installed Successfully..."
        echo -e "Credits for ${CYAN}https://github.com/SpotX-Official/SpotX-Bash${RESET} for the Ad Blocker"

    fi


    echo "Spotify Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "Spotify Installed Successfully !"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Spotify Installation