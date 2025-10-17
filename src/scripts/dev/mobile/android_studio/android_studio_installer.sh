#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_android_studio_for_ubuntu_or_based(){

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing OpenJDK 17"
    printc "YELLOW" "-> Installing OpenJDK 17..."
    sudo apt install openjdk-17-jdk -y || handle_error "Failed to Install OpenJDK 17"

    log_message "INFO" "Checking Installed Java version"
    printc "YELLOW" "-> Checking Installed Java version..."
    java --version || handle_error "Failed to Check Installed Java Version"

    log_message "INFO" "Installing Required Dependencies"
    printc "YELLOW" "-> Installing Required Dependencies..."
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Importing Android Studio Repository"
    printc "YELLOW" "-> Importing Android Studio Repository..."
    sudo add-apt-repository ppa:maarten-fonville/android-studio -y || handle_error "Failed to Import Android Studio Repository"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Android Studio"
    printc "YELLOW" "-> Installing Android Studio..."
    sudo apt install android-studio -y || handle_error "Failed to Install Android Studio"
}

install_android_studio_for_fedora_or_based(){
    echo "To be Implemented..."
}

# Begin Android Studio Installation
echo "Continue script execution in Android Studio Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Android Studio for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Android Studio for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Android Studio Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Android Studio Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_android_studio_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_android_studio_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    echo "Script Execution in Android Studio Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Android Studio Installed Successfully"
    exec bash
else

    handle_error "No Connection Available ! Exiting..."

fi
# End Android Studio Installation