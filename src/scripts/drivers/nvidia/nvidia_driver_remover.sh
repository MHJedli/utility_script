#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in NVIDIA Driver Removing at $(date)" >> "$LOG_FILE"

remove_for_ubuntu_or_based(){
    log_message "INFO" "Removing NVIDIA Driver"
    printc "YELLOW" "-> Removing NVIDIA Driver..."
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Remove NVIDIA Driver"
}

remove_for_fedora_or_based(){
    log_message "INFO" "Removing NVIDIA Driver"
    printc "YELLOW" "-> Removing NVIDIA Driver..."
    sudo dnf remove nvidia* --purge -y || handle_error "Failed to Remove NVIDIA Driver"
}

# Begin NVIDIA Driver Removal
log_message "INFO" "Checking for NVIDIA Driver Before Removing"
printc "YELLOW" "-> Checking for NVIDIA Driver Before Removing..."
if ! command -v nvidia-smi &> /dev/null; then

    log_message "INFO" "NVIDIA Driver is not installed. Exiting..."
    printc "RED" "NVIDIA Driver is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read
    show_drivers_menu

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

    log_message "INFO" "NVIDIA Driver Removed Successfully"
    echo -n -e "${GREEN}NVIDIA Driver Removed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Rebooting..."
        reboot
    else
        echo -n "Press [ENTER] To Exit Script..."
        read
        showDriversMenu
    fi

fi
# End NVIDIA Driver Removal