#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "Removing Virtual Machine Manager"
    printc "YELLOW" "-> Removing Virtual Machine Manager..."
    sudo apt autoremove virt-manager -y || handle_error "Failed to remove Virtual Machine Manager"

}

remove_for_fedora_or_based(){

    log_message "INFO" "Removing Virtual Machine Manager"
    printc "YELLOW" "-> Removing Virtual Machine Manager..."
    sudo dnf remove @virtualization -y || handle_error "Failed to remove Virtual Machine Manager"

}

# Begin Virtual Machine Manager Removal
echo "Continue script execution in Virtual Machine Manager Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Virtual Machine Manager Before Removing"
printc "YELLOW" "-> Checking for Virtual Machine Manager Before Removing..."

if ! command -v virt-manager &> /dev/null; then

    log_message "INFO" "Virtual Machine Manager is not installed. Exiting..."
    printc "RED" "Virtual Machine Manager is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Virtual Machine Manager is installed. Continue..."
    printc "GREEN" "-> Virtual Machine Manager is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing Virtual Machine Manager for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing Virtual Machine Manager for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    echo "Virtual Machine Manager Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Virtual Machine Manager Removed Successfully"

fi
# End Virtual Machine Manager Removal