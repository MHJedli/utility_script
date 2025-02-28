#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in IntelliJ IDEA Community Removal at $(date)" >> "$LOG_FILE"

remove_for_ubuntu_or_based(){
    log_message "INFO" "Removing IntelliJ IDEA Community"
    printc "YELLOW" "-> Removing IntelliJ IDEA Community..."
    sudo apt autoremove --purge intellij-idea-community -y || handle_error "Failed to remove IntelliJ IDEA Community"
}

remove_for_fedora_or_based(){

}

log_message "INFO" "Checking for IntelliJ IDEA Community Before Removing"
printc "YELLOW" "-> Checking for IntelliJ IDEA Community Before Removing..."

if ! command -v idea-community &> /dev/null; then

    log_message "INFO" "IntelliJ IDEA Community is not installed. Exiting..."
    printc "RED" "IntelliJ IDEA Community is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "IntelliJ IDEA Community is installed. Continue..."
    printc "GREEN" "-> IntelliJ IDEA Community is installed."
    echo -n "Press [ENTER] To Continue..."
    
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported OS: ${DISTRIBUTION_NAME}. Exiting..."
    fi

    echo "IntelliJ IDEA Community Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success" "IntelliJ IDEA Community Removed Successfully"

fi