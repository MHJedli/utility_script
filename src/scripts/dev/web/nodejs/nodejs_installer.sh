#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_nodejs(){
    log_message "INFO" "Downloading and Installing NVM"
    printc "YELLOW" "-> Downloading and Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash || handle_error "Failed to install NVM"

    log_message "INFO" "Activating NVM"
    printc "YELLOW" "-> Activating NVM..."
    . "$HOME/.nvm/nvm.sh" || handle_error "Failed to source NVM script"

    log_message "INFO" "Selecting NodeJS Version"
    printc "YELLOW" "-> Selecting NodeJS Version..."
    while true; do
        local node_version=$(whiptail --title "NodeJS Installation" --inputbox "Please enter the NodeJS version to install: (Example: 24,23,22,...)" \
        10 50 3>&1 1>&2 2>&3)
        if [[ "$node_version" -gt 0 && "$node_version" -lt 25 ]]; then
            log_message "INFO" "Installing NodeJS v${node_version} with NVM"
            printc "GREEN" "-> Installing NodeJS v${node_version} with NVM..."
            nvm install "$node_version" || handle_error "Failed to install NodeJS v${node_version}"
            break
        else
            log_message "ERROR" "Invalid NodeJS version entered: ${node_version}"
            print_msgbox "Error" "Invalid NodeJS version entered. Please enter a valid version between 1 and 25."            
        fi
    done

    log_message "INFO" "Verifying NodeJS Installation"
    printc "YELLOW" "-> Verifying NodeJS Installation..."
    print_msgbox "NodeJS Version" "
    Node Version: $(node -v)
    NVM Version: $(nvm current)
    NPM Version: $(npm -v)
    " || handle_error "Failed to Verify NodeJS Version"

    print_msgbox "INFO" "Close and Reopen the Terminal to use NodeJS"
}

# Begin nodejs Installation
echo "Continue script execution in NodeJS Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing NodeJS for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing NodeJS for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with NodeJS Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with NodeJS Installation..."

    log_message "INFO" "Removing Previous NVM and NPM Installation"
    printc "YELLOW" "-> Removing Previous NVM and NPM Installation..."
    rm -rf "$HOME/.nvm" "$HOME/.npm"

    install_nodejs

    echo "Script Execution in NodeJS Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "NodeJS Installed Successfully"
else
    handle_error "No Connection Available ! Exiting..."
fi
# End nodejs Installation
