#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Spotify Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Spotify Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Spotify Installation..."

    log_message "INFO" "fetching the security key"
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

    log_message "INFO" "Installing Spotify Ad Blocker"
    printc "YELLOW" "-> Installing Spotify Ad Blocker..."
    bash <(curl -sSL https://spotx-official.github.io/run.sh) -f || handle_error "Failed to Install Spotify Ad Blocker"
    printc "GREEN" "-> Spotify Ad Blocker Installed Successfully..."
    echo -e "Credits for ${CYAN}https://github.com/SpotX-Official/SpotX-Bash${RESET} for the Ad Blocker"

    echo "Spotify Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Spotify Installed Successfully"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

