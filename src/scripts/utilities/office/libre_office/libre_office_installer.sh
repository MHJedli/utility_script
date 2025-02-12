#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Libre Office Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Libre Office Installation"
	printc "GREEN" "-> Internet Connection Detected. Proceeding with Libre Office Installation..."
	
    log_message "INFO" "Installing Required Packages : software-properties-common"
    printc "YELLOW" "-> Installing Required Packages : software-properties-common..."
    sudo apt-get update && sudo apt-get install -y software-properties-common || handle_error "Failed to install required packages"

    log_message "INFO" "Adding Libre Office Repository"
    printc "YELLOW" "-> Adding Libre Office Repository..."
    sudo add-apt-repository ppa:libreoffice/ppa -y || handle_error "Failed to add Libre Office Repository"

    log_message "INFO" "Updating Package List after Adding Repository"
    printc "YELLOW" "-> Updating Package List after Adding Repository..."
    sudo apt update || handle_error "Failed to update package list"

    log_message "INFO" "Installing Libre Office"
    printc "YELLOW" "-> Installing Libre Office..."
    sudo apt install -y libreoffice || handle_error "Failed to install Libre Office"

    echo "Libre Office Installer Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Libre Office Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi