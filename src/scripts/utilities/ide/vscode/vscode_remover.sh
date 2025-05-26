#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "Removing VS Code"
    printc "YELLOW" "-> Removing VS Code..."
    sudo apt autoremove --purge code -y || handle_error "Failed to remove VS Code"

}

remove_for_fedora_or_based(){

    log_message "INFO" "Removing VS Code for Fedora"
    printc "YELLOW" "-> Removing VS Code for Fedora..."
    sudo dnf remove code -y || handle_error "Failed to remove VS Code for Fedora"

}

# Begin VS Code Removal
echo "Continue script execution in VS Code Removal at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for VS Code Before Removing"
printc "YELLOW" "-> Checking for VS Code Before Removing..."

if ! command -v code &> /dev/null; then

    log_message "INFO" "VS Code is not installed. Exiting..."
    printc "RED" "VS Code is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "VS Code is installed. Continue..."
    printc "GREEN" "-> VS Code is installed."
    echo -n "Press [ENTER] To Continue..."
    read
    
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "VS Code Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "VS Code Removed Successfully"

fi
# End VS Code Removal