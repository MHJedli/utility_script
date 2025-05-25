#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){
    sudo apt remove waydroid -y || handle_error "Failed to remove Waydroid"
}

remove_for_fedora_or_based(){
    sudo dnf remove waydroid -y || handle_error "Failed to remove Waydroid"
}

# Begin Waydroid Removal
echo "Continue script execution in Waydroid Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Waydroid Before Removing"
printc "YELLOW" "-> Checking for Waydroid Before Removing..."

if ! command -v waydroid &> /dev/null; then

    log_message "INFO" "Waydroid is not installed. Exiting..."
    printc "RED" "Waydroid is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Waydroid is installed. Continue..."
    printc "GREEN" "-> Waydroid is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Stopping Waydroid"
    printc "YELLOW" "-> Stopping Waydroid..."
    waydroid session stop || handle_error "Failed to stop Waydroid session"
    sudo waydroid container stop || handle_error "Failed to stop Waydroid container"

    log_message "INFO" "Removing Waydroid for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing Waydroid for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    log_message "INFO" "Removing Leftovers"
    printc "YELLOW" "-> Removing Leftovers..."
    sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid

    echo "Waydroid Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Waydroid Removed Successfully"

fi
# End Waydroid Removal