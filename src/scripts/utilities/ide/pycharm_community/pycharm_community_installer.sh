#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pycharm Community Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Pycharm Community Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pycharm Community Installation..."

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing the following packages: software-properties-common"
    printc "YELLOW" "-> Installing the following packages: software-properties-common..."
    sudo apt install software-properties-common -y || handle_error "Failed to Install Required Packages"

    log_message "INFO" "Adding xtradeb Repository"
    printc "YELLOW" "-> Adding xtradeb Repository..."
    sudo add-apt-repository ppa:xtradeb/apps -y || handle_error "Failed to add repository"

    log_message "INFO" "Updating Package Cache After Adding Repository"
    printc "YELLOW" "-> Updating Package Cache After Adding Repository..."
    sudo apt update || handle_error "Failed to Refresh Package Cache After Adding Repository"

    log_message "INFO" "Installing Pycharm Community"
    printc "YELLOW" "-> Installing Pycharm Community..."
    sudo apt install pycharm-community -y || handle_error "Failed to Install Pycharm Community"

    echo "Pycharm Community Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Pycharm Community Installed Successfully"
    
else

    handle_error "No Internet Connection Available, Exiting..."

fi