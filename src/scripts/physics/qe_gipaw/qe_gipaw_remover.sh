#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

delete_qe(){
    log_message "INFO" "Searching for Quantum Espresso Installation"
    printc "YELLOW" "-> Searching for Quantum Espresso Installation..."
    local qe_path=$(find $HOME -type d -iname "q-e-qe-*")

    if [[ -z "$qe_path" ]]; then
        handle_error "No Quantum Espresso Installation Found !"
    else
        log_message "INFO" "Found Quantum Espresso Installation : $qe_path"
        printc "GREEN" "Quantum Espresso Installation Found : $qe_path"
        echo -n "Press [ENTER] to Continue..."
        read

        log_message "INFO" "Deleting Quantum Espresso Installation"
        printc "YELLOW" "-> Deleting Quantum Espresso Installation..."
        rm -rf "$qe_path"

        log_message "INFO" "Removing Quantum Espresso from PATH"
        printc "YELLOW" "-> Removing Quantum Espresso from PATH..."
        sed -i '/q-e-qe-/d' ~/.bashrc

        log_message "INFO" "Quantum Espresso Deleted Successfully"
        printc "GREEN" "Quantum Espresso Deleted Successfully"
    fi
}

delete_gipaw(){
    log_message "INFO" "Searching for GIPAW Installation"
    printc "YELLOW" "-> Searching for GIPAW Installation..."

    local gipaw_path=$(find $HOME -type d -iname "qe-gipaw-*")
    if [[ -z "$gipaw_path" ]]; then
        handle_error "No GIPAW Installation Found !"
    else
        log_message "INFO" "Found GIPAW Installation : $gipaw_path"
        printc "GREEN" "GIPAW Installation Found : $gipaw_path"
        echo -n "Press [ENTER] to Continue..."
        read

        log_message "INFO" "Deleting GIPAW Installation"
        printc "YELLOW" "-> Deleting GIPAW Installation..."
        rm -rf "$gipaw_path"

        log_message "INFO" "Removing GIPAW from PATH"
        printc "YELLOW" "-> Removing GIPAW from PATH..."
        sed -i '/qe-gipaw-/d' ~/.bashrc
        log_message "INFO" "GIPAW Deleted Successfully"
        printc "GREEN" "GIPAW Deleted Successfully"
    fi
}

# Begin Quantum Espresso & GIPAW Removal

log_message "INFO" "Removing Quantum Espresso & GIPAW for ${DISTRIBUTION_NAME}"
printc "YELLOW" "-> Removing Quantum Espresso & GIPAW for ${DISTRIBUTION_NAME}..."
delete_qe
delete_gipaw
echo "Quantum Espresso & GIPAW Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
print_msgbox "Success !" "Quantum Espresso & GIPAW Removed Successfully"

# End Quantum Espresso & GIPAW Removal
