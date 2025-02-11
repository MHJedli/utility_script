#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
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
    
    log_message "INFO" "Removing VS Code"
    printc "YELLOW" "-> Removing VS Code..."
    sudo apt autoremove --purge code -y || handle_error "Failed to remove VS Code"

    echo "VS Code Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "VS Code Removed Successfully"

fi