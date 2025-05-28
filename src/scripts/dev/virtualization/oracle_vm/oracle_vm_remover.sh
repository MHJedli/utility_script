#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){
    sudo apt autoremove VirtualBox-7.1 -y || handle_error "Failed to remove Oracle VirtualBox"
}

remove_for_fedora_or_based(){
    sudo dnf remove VirtualBox-7.1 -y || handle_error "Failed to remove Oracle VirtualBox"
}

# Begin Oracle VirtualBox Removal
echo "Continue script execution in Oracle VirtualBox Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Oracle VirtualBox Before Removing"
printc "YELLOW" "-> Checking for Oracle VirtualBox Before Removing..."

if ! command -v virtualbox &> /dev/null; then

    log_message "INFO" "Oracle VirtualBox is not installed. Exiting..."
    printc "RED" "Oracle VirtualBox is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Oracle VirtualBox is installed. Continue..."
    printc "GREEN" "-> Oracle VirtualBox is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing Oracle VirtualBox for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing Oracle VirtualBox for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    echo "Oracle VirtualBox Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Oracle VirtualBox Removed Successfully"

fi
# End Oracle VirtualBox Removal