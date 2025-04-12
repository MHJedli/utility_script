#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"
CODENAME=$(. /etc/os-release && echo "$UBUNTU_CODENAME")


trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Wine Installation at $(date)" >> "$LOG_FILE"

install_for_ubuntu_or_based(){

    log_message "INFO" "Enabling 32-bit Architecture"
    printc "YELLOW" "-> Enabling 32-bit Architecture..."
    sudo dpkg --add-architecture i386 || handle_error "Failed to Enable 32-bit Architecture"

    log_message "INFO" "Downloading Wine Repository"
    printc "YELLOW" "-> Downloading Wine Repository..."
    sudo mkdir -pm755 /etc/apt/keyrings
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - || handle_error "Failed to Download Wine Repository"

    log_message "INFO" "Adding Wine Repository"
    printc "YELLOW" "-> Adding Wine Repository..."
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/${CODENAME}/winehq-${CODENAME}.sources || handle_error "Failed to Add Wine Repository"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Wine Development branch"
    printc "YELLOW" "-> Installing Wine Development branch..."
    sudo apt install --install-recommends winehq-devel -y || handle_error "Failed to Install Wine"

    log_message "INFO" "Printing Installed Wine Version"
    printc "YELLOW" "-> Printing Installed Wine Version..."
    wine --version || handle_error "Failed to Print Installed Wine Version"
}

install_for_fedora_or_based(){

}

# Begin Wine Installation
log_message "INFO" "Installing for ${DISTRIBUTION_NAME}..."
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Wine Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Wine Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "Wine Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "Wine Installed Successfully !"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Wine Installation