#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in VS Code Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with VS Code Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with VS Code Installation..."

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing the following packages: jq, curl"
    printc "YELLOW" "-> Installing the following packages: jq, curl..."
    sudo apt install -y curl jq || handle_error "Failed to Install Required Packages"

    log_message "INFO" "Fetching The Latest VS Code Version"
    printc "YELLOW" "-> Fetching The Latest VS Code Version..."
    LATEST_VSCODE_VERSION=$(curl -s https://code.visualstudio.com/sha/) || handle_error "Failed to Fetch Latest VS Code Version"

    log_message "INFO" "Downloading VS Code"
    printc "YELLOW" "-> Downloading VS Code..."
    DOWNLOAD_LINK=$(echo $LATEST_VSCODE_VERSION | jq -r '.products[] | select(.platform.os=="linux-deb-x64" and .build == "stable") | .url')
    DOWNLOAD_PATH=$(pwd)/tmp/ 
    wget -c -P $DOWNLOAD_PATH $DOWNLOAD_LINK || handle_error "Failed to Download VS Code"

    log_message "INFO" "Installing VS Code"
    printc "YELLOW" "-> Installing VS Code..."
    sudo dpkg -i $DOWNLOAD_PATH/code_*.deb || handle_error "Failed To Install VS Code"

    echo "VS Code Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "VS Code Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi