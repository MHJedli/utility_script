#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){

    log_message "INFO" "Installing Required Packages : software-properties-common"
    printc "YELLOW" "-> Installing Required Packages : software-properties-common..."
    sudo apt update && sudo apt install -y software-properties-common || handle_error "Failed to install required packages"

    log_message "INFO" "Adding Libre Office Repository"
    printc "YELLOW" "-> Adding Libre Office Repository..."
    sudo add-apt-repository ppa:libreoffice/ppa -y || handle_error "Failed to add Libre Office Repository"

    log_message "INFO" "Updating Package List after Adding Repository"
    printc "YELLOW" "-> Updating Package List after Adding Repository..."
    sudo apt update || handle_error "Failed to update package list"

    log_message "INFO" "Installing Libre Office"
    printc "YELLOW" "-> Installing Libre Office..."
    sudo apt install -y libreoffice || handle_error "Failed to install Libre Office"

}

install_for_fedora_or_based(){

    log_message "INFO" "Updating System Packages"
    printc "YELLOW" "-> Updating System Packages..."
    sudo dnf update -y || handle_error "Failed to update system packages"

    log_message "INFO" "Verifying Required Packages : wget"
    printc "YELLOW" "-> Verifying Required Packages : wget"
    verify_packages "wget"

    log_message "INFO" "Downloading Libreoffice"
    printc "YELLOW" "-> Downloading Libreoffice..."
    local ver=25.2.1
    local download_path=$WORK_DIR/tmp/
    local download_link=https://download.documentfoundation.org/libreoffice/stable/${ver}/rpm/x86_64/LibreOffice_${ver}_Linux_x86-64_rpm.tar.gz
    wget -c -P "$download_path" "$download_link" || handle_error "Failed to download Libreoffice"

    log_message "INFO" "Installing Libreoffice"
    printc "YELLOW" "-> Installing Libreoffice..."
    tar -xvf $download_path/LibreOffice_${ver}_Linux_x86-64_rpm.tar.gz
    cd $download_path/LibreOffice_${ver}_Linux_x86-64_rpm && cd RPM/ && sudo dnf install *.rpm -y || handle_error "Failed to install Libreoffice"
    
}

# Begin Libre Office Installation
echo "Continue script execution in Libre Office Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}..."
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Libre Office Installation"
	printc "GREEN" "-> Internet Connection Detected. Proceeding with Libre Office Installation..."
	
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "Libre Office Installer Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Libre Office Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Libre Office Installation