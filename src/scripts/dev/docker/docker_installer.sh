#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Docker Installation at $(date)" >> "$LOG_FILE"

install_for_ubuntu_or_based(){
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
}

install_for_fedora_or_based(){
    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo dnf check-update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Required Packages"
    printc "YELLOW" "-> Installing Required Packages..."
    sudo dnf install dnf-plugins-core || handle_error "Failed to Install Required Packages"
    
    log_message "INFO" "Adding Docker's Official Repository"
    printc "YELLOW" "-> Adding Docker's Official Repository..."
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || handle_error "Failed to Add Docker's Official Repository"

    log_message "INFO" "Installing Docker"
    printc "YELLOW" "-> Installing Docker..."
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y || handle_error "Failed to Install Docker"

    log_message "INFO" "Starting Docker Service"
    printc "YELLOW" "-> Starting Docker Service..."
    sudo systemctl enable --now docker || handle_error "Failed to Start Docker Service"

    log_message "INFO" "Verifying Installation"
    printc "YELLOW" "-> Verifying Installation..."
    sudo docker run hello-world || handle_error "Failed to Verify Docker"
}

rootless_docker(){
    log_message "INFO" "Setting Up Rootless Docker"
    printc "YELLOW" "-> Setting Up Rootless Docker..."
    sudo groupadd docker
    sudo usermod -aG docker $USER || handle_error "Failed to Set Up Rootless Docker"
    newgrp docker

    log_message "INFO" "Verifying Rootless Docker"
    printc "YELLOW" "-> Verifying Rootless Docker..."
    docker run hello-world || handle_error "Failed to Verify Rootless Docker"
}

# Begin Docker Installation
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with Docker Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Docker Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n $UBUNTU_BASE ]]; then install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n $FEDORA_BASE ]]; then install_for_fedora_or_based
    else handle_error "Unsupported Distribution: $DISTRIBUTION"
    fi

    rootless_docker
    
    echo "Script Execution in Docker Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Docker Installed Successfully..."
    echo "Press [ENTER] To Exit..."
    read
else
    handle_error "No Internet Connection Available, Exiting..."
fi
# End Docker Installation