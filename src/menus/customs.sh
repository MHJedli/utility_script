#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_customs_menu(){
    log_message "INFO" "Displaying Customs Menu"
    local option=$(whiptail --title "Customs Menu" --menu "Choose an option" 30 80 16 \
    "Gaming Setup" "Prepare your Linux system to be game-ready" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Gaming Setup")
            log_message "INFO" "User chose Gaming Setup Menu"
            show_gaming_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

# Gaming Menu
show_gaming_menu(){
    options_menu "Gaming Setup" \
               "${scriptPaths["gaming_setup_installer"]}" \
               "${scriptPaths["gaming_setup_remover"]}" \
               "show_customs_menu"
}

# Begin custom Menu
show_customs_menu
# End custom Menu