#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "Removing Spotify Installation"
    printc "YELLOW" "-> Removing Spotify Installation..."
    sudo apt autoremove spotify-client --purge -y || handle_error "Failed to Remove Spotify"

    log_message "INFO" "Removing Spotify Directory"
    printc "YELLOW" "-> Removing Spotify Directory..."
    sudo rm -rf /usr/share/spotify

}

remove_for_fedora_or_based(){

}

# Begin Spotify Removal
echo "Continue script execution in Spotify Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Spotify Before Removing"
printc "YELLOW" "-> Checking for Spotify Before Removing..."

if ! command -v spotify &> /dev/null; then

    log_message "INFO" "Spotify is not installed. Exiting..."
    printc "RED" "Spotify is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Spotify is installed. Continue..."
    printc "GREEN" "-> Spotify is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi



    echo "Spotify Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "Spotify Removed Successfully !"
fi
# End Spotify Removal