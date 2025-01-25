#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Docker Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Docker Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Docker Installation..."

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Required Packages"
    printc "YELLOW" "-> Installing Required Packages..."
    sudo apt install apt-transport-https curl -y || handle_error "Failed to Install Required Packages"

    log_message "INFO" "Adding Docker's Official GPG Key"
    printc "YELLOW" "-> Adding Docker's Official GPG Key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || handle_error "Failed to Add Docker's Official GPG Key"

    log_message "INFO" "Setting Up Docker's Stable Repository"
    printc "YELLOW" "-> Setting Up Docker's Stable Repository..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || handle_error "Failed to Set Up Docker's Stable Repository"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Docker"
    printc "YELLOW" "-> Installing Docker..."
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y || handle_error "Failed to Install Docker"

    log_message "INFO" "Verifying Installation"
    printc "YELLOW" "-> Verifying Installation..."
    sudo docker run hello-world || handle_error "Failed to Verify Docker"

    echo "Script Execution in Docker Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    echo -e "${GREEN}Docker Installed Successfully...${RESET}"
    printc "GREEN" "-> Docker Installed Successfully..."
    echo "Press [ENTER] To Exit..."
    read
else

    handle_error "No Internet Connection Available, Exiting..."

fi