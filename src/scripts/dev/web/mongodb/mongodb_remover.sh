#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){
    sudo apt purge mongo* -y || handle_error "Failed to remove MongoDB for Ubuntu or based distributions"
}

remove_for_fedora_or_based(){
    sudo dnf remove mongo* -y || handle_error "Failed to remove MongoDB for Fedora or based distributions"
}

# Begin MongoDB Removal
if ! command -v mongosh &> /dev/null; then

    log_message "INFO" "MongoDB shell is not installed. Exiting..."
    printc "RED" "MongoDB shell is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "MongoDB shell is installed. Continue..."
    printc "GREEN" "-> MongoDB shell is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Stopping MongoDB Service"
    printc "YELLOW" "-> Stopping MongoDB Service..."
    sudo service mongod stop

    log_message "INFO" "Removing MongoDB for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing MongoDB for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    log_message "INFO" "Removing Data Directories"
    printc "YELLOW" "-> Removing Data Directories..."
    sudo rm -rf /var/log/mongodb
    sudo rm -rf /var/lib/mongodb

    echo "MongoDB Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "MongoDB Removed Successfully"

fi
# End MongoDB Removal