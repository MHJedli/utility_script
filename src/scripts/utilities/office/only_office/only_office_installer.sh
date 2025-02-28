#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in ONLY OFFICE Installation at $(date)" >> "$LOG_FILE"

install_for_ubuntu_or_based(){
    log_message "INFO" "Configuring ONLY OFFICE GPG Key"
    printc "YELLOW" "-> Configuring ONLY OFFICE GPG Key..."
    mkdir -p -m 700 ~/.gnupg
    gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
    chmod 644 /tmp/onlyoffice.gpg
    sudo chown root:root /tmp/onlyoffice.gpg
    sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

    log_message "INFO" "Adding ONLY OFFICE Repository"
    printc "YELLOW" "-> Adding ONLY OFFICE Repository..."
    echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

    log_message "INFO" "Updating Package List"
    printc "YELLOW" "-> Updating Package List..."
    sudo apt update || handle_error "Failed to update package list"

    log_message "INFO" "Installing ONLY OFFICE"
    printc "YELLOW" "-> Installing ONLY OFFICE..."
    sudo apt install onlyoffice-desktopeditors -y || handle_error "Failed to install ONLY OFFICE"
}

install_for_fedora_or_based(){

}

printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with ONLY OFFICE Installation"
	printc "GREEN" "-> Internet Connection Detected. Proceeding with ONLY OFFICE Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS : ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "ONLY OFFICE Installer Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "ONLY OFFICE Installed Successfully"
    
else
    
    handle_error "No Internet Connection Available, Exiting..."

fi