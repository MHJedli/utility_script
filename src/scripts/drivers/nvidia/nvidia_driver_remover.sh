#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){

    log_message "INFO" "Removing NVIDIA Driver"
    printc "YELLOW" "-> Removing NVIDIA Driver..."
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Remove NVIDIA Driver"

}

remove_for_fedora_or_based(){

    log_message "INFO" "Removing NVIDIA Driver"
    printc "YELLOW" "-> Removing NVIDIA Driver..."
    sudo dnf remove nvidia* --allowerasing -y || handle_error "Failed to Remove NVIDIA Driver"
    
}

# Begin NVIDIA Driver Removal
echo "Continue script execution in NVIDIA Driver Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for NVIDIA Driver Before Removing"
printc "YELLOW" "-> Checking for NVIDIA Driver Before Removing..."
if ! command -v nvidia-smi &> /dev/null; then

    log_message "INFO" "NVIDIA Driver is not installed. Exiting..."
    printc "RED" "NVIDIA Driver is not installed !"
    echo -n "Press [ENTER] To Exit Script..."

else

    log_message "INFO" "NVIDIA Driver is installed. Continue..."
    printc "GREEN" "-> NVIDIA Driver is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing NVIDIA Driver for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing NVIDIA Driver for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi
    
    echo "NVIDIA Driver Removal Script Completed Successfully at $(date)" >> "$LOG_FILE"
    if whiptail --title "NVIDIA Driver Removed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    fi

fi
# End NVIDIA Driver Removal