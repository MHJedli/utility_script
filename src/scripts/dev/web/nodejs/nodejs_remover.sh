#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_nodejs(){
    log_message "INFO" "Removing NPM and NVM Installation"
    printc "YELLOW" "-> Removing NPM and NVM Installation..."
    rm -rf "${HOME}/.nvm" "${HOME}/.npm"   
}

# Begin nodejs Removal
if ! command -v node &> /dev/null; then

    log_message "INFO" "nodejs is not installed. Exiting..."
    printc "RED" "nodejs is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "nodejs is installed. Continue..."
    printc "GREEN" "-> nodejs is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing nodejs for ${DISTRIBUTION}"
    printc "YELLOW" "-> Removing nodejs for ${DISTRIBUTION}..."

    remove_nodejs

    echo "nodejs Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "nodejs Removed Successfully"

fi
# End nodejs Removal
