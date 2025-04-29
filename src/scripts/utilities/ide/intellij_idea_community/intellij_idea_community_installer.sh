#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){

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

    log_message "INFO" "Installing Intellij IDEA Community"
    printc "YELLOW" "-> Installing Intellij IDEA Community..."
    sudo apt install intellij-idea-community -y || handle_error "Failed to Install Intellij IDEA Community"

}

install_for_fedora_or_based(){
    
    log_message "INFO" "Verifying for Flatpak Installation"
    printc "YELLOW" "-> Verifying for Flatpak Installation..."
    verify_packages "flatpak"

    log_message "INFO" "Installing Intellij IDEA Community from flathub"
    printc "YELLOW" "-> Installing Intellij IDEA Community from flathub..."
    flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community -y || handle_error "Failed to Install Intellij IDEA Community"

}

# Begin Intellij IDEA Community Installation
echo "Continue script execution in Intellij IDEA Community Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}..."
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Intellij IDEA Community Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Intellij IDEA Community Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "Intellij IDEA Community Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Intellij IDEA Community Installed Successfully"
    
else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Intellij IDEA Community Installation