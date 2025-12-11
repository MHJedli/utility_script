#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_physics_menu(){
    log_message "INFO" "Displaying Physics Menu"
    local option=$(whiptail --title "Physics Menu" --menu "Choose an option" $HEIGHT $WIDTH 2 \
    "Quantum Espresso & GIPAW" "electronic-structure calculations and materials modeling" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Quantum Espresso & GIPAW")
            log_message "INFO" "User chose Physics Menu"
            show_qe_gipaw_menu
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

show_qe_gipaw_menu(){
    options_menu "Quantum Espresso & GIPAW" \
               "${scriptPaths["qe_gipaw_installer"]}" \
               "${scriptPaths["qe_gipaw_remover"]}" \
               "show_physics_menu"   
}

# Begin Drivers Menu
show_physics_menu
# End Drivers Menu