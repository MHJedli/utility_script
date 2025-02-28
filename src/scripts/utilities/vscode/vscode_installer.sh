#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in VS Code Installation at $(date)" >> "$LOG_FILE"

download_and_install_for_ubuntu_or_based(){

    log_message "INFO" "Downloading VS Code"
    printc "YELLOW" "-> Downloading VS Code..."
    DOWNLOAD_LINK=$(echo $LATEST_VSCODE_VERSION | jq -r '.products[] | select(.platform.os=="linux-deb-x64" and .build == "stable") | .url')
    DOWNLOAD_PATH=$(pwd)/tmp/ 
    wget -c -P $DOWNLOAD_PATH $DOWNLOAD_LINK || handle_error "Failed to Download VS Code"

    log_message "INFO" "Installing VS Code"
    printc "YELLOW" "-> Installing VS Code..."
    sudo dpkg -i $DOWNLOAD_PATH/code_*.deb || handle_error "Failed To Install VS Code"
}

download_and_install_for_fedora_or_based(){

    log_message "INFO" "Downloading VS Code"
    printc "YELLOW" "-> Downloading VS Code..."
    DOWNLOAD_LINK=$(echo $LATEST_VSCODE_VERSION | jq -r '.products[] | select(.platform.os=="linux-rpm-x64" and .build == "stable") | .url')
    DOWNLOAD_PATH=$(pwd)/tmp/ 
    wget -c -P $DOWNLOAD_PATH $DOWNLOAD_LINK || handle_error "Failed to Download VS Code"

    log_message "INFO" "Installing VS Code"
    printc "YELLOW" "-> Installing VS Code..."
    sudo dnf install $DOWNLOAD_PATH/code*.rpm -y || handle_error "Failed To Install VS Code"
}

printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with VS Code Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with VS Code Installation..."

    verify_packages "jq" "curl"

    log_message "INFO" "Fetching The Latest VS Code Version"
    printc "YELLOW" "-> Fetching The Latest VS Code Version..."
    LATEST_VSCODE_VERSION=$(curl -s https://code.visualstudio.com/sha/) || handle_error "Failed to Fetch Latest VS Code Version"

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then

        log_message "INFO" "Refreshing Package Cache"
        printc "YELLOW" "-> Refreshing Package Cache..."
        sudo apt update || handle_error "Failed to Refresh Package Cache"
        download_and_install_for_ubuntu_or_based

    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then

        log_message "INFO" "Refreshing Package Cache"
        printc "YELLOW" "-> Refreshing Package Cache..."
        sudo dnf update -y || handle_error "Failed to Refresh Package Cache"
        download_and_install_for_fedora_or_based

    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "VS Code Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "VS Code Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi