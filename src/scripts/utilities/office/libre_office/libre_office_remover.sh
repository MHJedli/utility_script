#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Libre Office Removal at $(date)" >> "$LOG_FILE"

remove_for_ubuntu_or_based(){
    log_message "INFO" "Libre Office is installed. Proceeding with removal."
    printc "GREEN" "-> Libre Office is installed. Proceeding with removal..."
    sudo apt autoremove --purge libreoffice -y || handle_error "Failed to remove Libre Office"

    log_message "INFO" "Removing Libre Office Repository"
    printc "YELLOW" "-> Removing Libre Office Repository..."
    sudo add-apt-repository --remove ppa:libreoffice/ppa -y || handle_error "Failed to remove Libre Office Repository"

    log_message "INFO" "Updating Package List"
    printc "YELLOW" "-> Updating Package List..."
    sudo apt update || handle_error "Failed to update package list"

    log_message "INFO" "Cleaning up temporary files and configurations"
    printc "GREEN" "-> Cleaning up temporary files and configurations..."
    sudo apt clean || handle_error "Failed to clean up temporary files"
    sudo rm -rf ~/.cache/libreoffice/ ~/.config/libreoffice/
}

remove_for_fedora_or_based(){

}

log_message "INFO" "Checking for Libre Office Before Removing"
printc "YELLOW" "-> Checking for Libre Office Before Removing..."

if ! command -v libreoffice &> /dev/null; then

    log_message "INFO" "Libre Office is not installed ! Exiting..."
    printc "RED" "Libre Office is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported OS: ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "Libre Office Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"   
    print_msgbox "Success !" "Libre Office Removed Successfully" 

fi