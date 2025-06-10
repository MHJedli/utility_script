#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "Removing Wine Installation"
    printc "YELLOW" "-> Removing Wine Installation..."
    sudo apt autoremove winehq-devel --purge -y || handle_error "Failed to Remove Wine Installation"

}

remove_for_fedora_or_based(){
    log_message "INFO" "Removing Wine Installation"
    printc "YELLOW" "-> Removing Wine Installation..."
    sudo dnf remove wine* -y || handle_error "Failed to Remove Wine Installation"
}

# Begin Wine Removal
echo "Continue script execution in Wine Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Wine Before Removing"
printc "YELLOW" "-> Checking for Wine Before Removing..."

if ! command -v wine &> /dev/null; then

    log_message "INFO" "Wine is not installed. Exiting..."
    print_msgbox "WARNING !" "Wine is not installed !"

else

    log_message "INFO" "Wine is installed. Continue..."
    printc "GREEN" "-> Wine is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported OS: ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "Wine Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "Wine Removed Successfully !"

fi
# End Wine Removal