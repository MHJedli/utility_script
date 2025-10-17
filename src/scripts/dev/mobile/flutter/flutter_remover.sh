#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin Flutter Removal
echo "Continue script execution in Flutter Removal at $(date)" >> "$LOG_FILE"

FLUTTER_PATH=$(whiptail --inputbox "Type the path where the flutter is located :" $HEIGHT $WIDTH --title "Flutter Path" 3>&1 1>&2 2>&3)
EXIT_STATUS=$?
if [ $EXIT_STATUS = 0 ]; then

	if [[ -z $FLUTTER_PATH ]]; then

        log_message "INFO" "Flutter Path not provided"
        printc "YELLOW" "-> Flutter Path not provided"
        log_message "INFO" "Defaulting to ${HOME}/flutter"    
        printc "YELLOW" "-> Defaulting to ${HOME}/flutter"
        DEFAULT_FLUTTER_PATH="${HOME}/flutter"

    else

        log_message "INFO" "Flutter Path provided: ${FLUTTER_PATH}"
        printc "GREEN" "-> Flutter Path provided: ${FLUTTER_PATH}"
        DEFAULT_FLUTTER_PATH="${HOME}/${FLUTTER_PATH}/flutter"

    fi

    log_message "INFO" "Checking if Flutter is installed at ${DEFAULT_FLUTTER_PATH}"
    printc "YELLOW" "-> Checking if Flutter is installed at ${DEFAULT_FLUTTER_PATH}"
    if [[ -d "$DEFAULT_FLUTTER_PATH" ]]; then

        log_message "INFO" "Flutter is installed at ${DEFAULT_FLUTTER_PATH}"
        printc "GREEN" "Flutter is installed at ${DEFAULT_FLUTTER_PATH}"

        log_message "INFO" "Deleting Flutter"
        printc "YELLOW" "-> Deleting Flutter..."
        rm -rf "$DEFAULT_FLUTTER_PATH"

        log_message "INFO" "Checking if Flutter is declared from PATH (bash)"
        printc "YELLOW" "-> Checking if Flutter is declared from PATH (bash)..."
        if grep 'flutter/bin' ~/.bashrc; then
            log_message "INFO" "Flutter is declared in PATH (bash)"
            printc "GREEN" "Flutter is declared in PATH (bash)"
            log_message "INFO" "Removing Flutter from PATH (bash)"
            printc "YELLOW" "-> Removing Flutter from PATH (bash)..."
            sed -i '/flutter\/bin/d' ~/.bashrc
        else
            log_message "INFO" "Flutter is not declared in PATH (bash)"
            printc "YELLOW" "-> Flutter is not declared in PATH (bash)"
        fi 

        echo "Flutter Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
        print_msgbox "Success !" "Flutter Removed Successfully"
        source ~/.bashrc

    else
        handle_error "Flutter not found at ${DEFAULT_FLUTTER_PATH}"
    fi
fi
# End Flutter Removal