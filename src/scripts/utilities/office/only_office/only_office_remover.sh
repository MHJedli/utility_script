#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "ONLY OFFICE is installed. Proceeding with Removal..."
    printc "GREEN" "-> ONLY OFFICE is installed. Proceeding with Removal..."
    sudo apt autoremove --purge onlyoffice-desktopeditors -y || handle_error "Failed to remove ONLY OFFICE"

    log_message "INFO" "Removing ONLY OFFICE Key"
    printc "YELLOW" "-> Removing ONLY OFFICE Key..."
    sudo rm /usr/share/keyrings/onlyoffice.gpg

    log_message "INFO" "Removing ONLY OFFICE Repository"
    printc "YELLOW" "-> Removing ONLY OFFICE Repository..."
    sudo rm /etc/apt/sources.list.d/onlyoffice.list

    log_message "INFO" "Updating Package List"
    printc "YELLOW" "-> Updating Package List..."
    sudo apt update || handle_error "Failed to update package list"
    
}

remove_for_fedora_or_based(){

}

# Begin ONLY OFFICE Removal
echo "Continue script execution in ONLY OFFICE Removal at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for ONLY OFFICE Before Removing"
printc "YELLOW" "-> Checking for ONLY OFFICE Before Removing..."
if ! command -v onlyoffice-desktopeditors &> /dev/null; then

    log_message "INFO" "ONLY OFFICE is not installed ! Exiting..."
    printc "RED" "ONLY OFFICE is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported OS: ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "ONLY OFFICE Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "ONLY OFFICE Removed Successfully"

fi
# End ONLY OFFICE Removal