#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Docker Removing at $(date)" >> "$LOG_FILE"

remove_for_ubuntu_or_based(){
    log_message "INFO" "Removing Docker"
    printc "YELLOW" "-> Removing Docker..."
    sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y || handle_error "Failed to remove Docker"

    log_message "INFO" "Removing Leftovers"
    printc "YELLOW" "-> Removing Leftovers..."
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
}

remove_for_fedora_or_based(){
    log_message "INFO" "Removing Docker"
    printc "YELLOW" "-> Removing Docker..."
    sudo dnf remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y || handle_error "Failed to remove Docker"

    log_message "INFO" "Removing Leftovers"
    printc "YELLOW" "-> Removing Leftovers..."
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
}

log_message "INFO" "Checking for Docker Before Removing"
printc "YELLOW" "-> Checking for Docker Before Removing..."

if ! command -v docker &> /dev/null; then

    log_message "INFO" "Docker is not installed. Exiting..."
    printc "RED" "Docker is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Docker is installed. Continue..."
    printc "GREEN" "-> Docker is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing Docker for ${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing Docker for ${DISTRIBUTION_NAME}..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    echo "Docker Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Docker Removed Successfully..."
    echo -n "Press [ENTER] To Exit Script..."
    read

fi