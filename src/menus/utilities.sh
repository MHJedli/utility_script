#!/usr/bin/env bash
source $(pwd)/src/utils.sh

show_utilities_menu(){
    log_message "INFO" "Displaying Drivers Menu"
    local option=$(whiptail --title "Utilities Menu" --menu "Choose an option" 30 80 16 \
    "OFFICE" "" \
    "VS Code" "" \
    "JetBrains IDE" "" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "VS Code")
            log_message "INFO" "User chose VS Code Menu"
            show_vscode_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
    esac
}

show_vscode_menu(){
    options_menu "VS CODE" \
       "${scriptPaths["vscode_installer"]}" \
       "${scriptPaths["vscode_remover"]}" \
       "show_utilities_menu"
}