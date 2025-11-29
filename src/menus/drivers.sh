#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_drivers_menu(){
    log_message "INFO" "Displaying Drivers Menu"
    local option=$(whiptail --title "Drivers Menu" --menu "Choose an option" $HEIGHT $WIDTH 2 \
    "NVIDIA Driver" "Install The Proprietary NVIDIA Driver" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "NVIDIA Driver")
            log_message "INFO" "User chose NVIDIA Driver Menu"
            show_nvidia_driver_menu
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

show_nvidia_driver_menu(){
    options_menu "NVIDIA Driver" \
               "${scriptPaths["nvidia_driver_installer"]}" \
               "${scriptPaths["nvidia_driver_remover"]}" \
               "show_drivers_menu"   
}

# Begin Drivers Menu
show_drivers_menu
# End Drivers Menu