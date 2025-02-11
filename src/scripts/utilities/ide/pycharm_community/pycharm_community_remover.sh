#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pycharm Community Removal at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Pycharm Community Before Removing"
printc "YELLOW" "-> Checking for Pycharm Community Before Removing..."

if ! command -v pycharm-community &> /dev/null; then

    log_message "INFO" "Pycharm Community is not installed. Exiting..."
    printc "RED" "Pycharm Community is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Pycharm Community is installed. Continue..."
    printc "GREEN" "-> Pycharm Community is installed."
    echo -n "Press [ENTER] To Continue..."
    
    log_message "INFO" "Removing Pycharm Community"
    printc "YELLOW" "-> Removing Pycharm Community..."
    sudo apt autoremove --purge pycharm-community -y || handle_error "Failed to remove Pycharm Community"

    echo "Pycharm Community Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "Pycharm Community Removed Successfully"

fi