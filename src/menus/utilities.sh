#!/usr/bin/env bash
source $(pwd)/src/utils.sh

show_utilities_menu(){
    log_message "INFO" "Displaying Utilities Menu"
    local option=$(whiptail --title "Utilities Menu" --menu "Choose an option" 30 80 16 \
    "OFFICE" "" \
    "VS Code" "" \
    "IDE" "" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "OFFICE")
            log_message "INFO" "User chose OFFICE Menu"
            show_office_menu
            ;;
        "VS Code")
            log_message "INFO" "User chose VS Code Menu"
            show_vscode_menu
            ;;
        "IDE")
            log_message "INFO" "User chose IDE Menu"
            show_ide_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
    esac
}

show_ide_menu(){
    log_message "INFO" "Displaying IDE Menu"
    local option=$(whiptail --title "IDE" --menu "Choose an option" 30 80 16 \
    "Intellij IDEA Community" "" \
    "Pycharm Community" "" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Intellij IDEA Community")
            log_message "INFO" "User chose Intellij IDEA Community Menu"
            show_intellij_community_menu
            ;;
        "Pycharm Community")
            log_message "INFO" "User chose Pycharm Community Menu"
            show_pycharm_community_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_utilities_menu
            ;;
    esac
}

show_intellij_community_menu(){
    options_menu "Intellij IDEA Community" \
        "${scriptPaths["intellij_community_installer"]}" \
        "${scriptPaths["intellij_community_remover"]}" \
        "show_utilities_menu"
}

show_pycharm_community_menu(){
    options_menu "Pycharm Community" \
        "${scriptPaths["pycharm_community_installer"]}" \
        "${scriptPaths["pycharm_community_remover"]}" \
        "show_utilities_menu"
}

show_office_menu(){
    log_message "INFO" "Displaying Office Menu"
    local option=$(whiptail --title "OFFICE" --menu "Choose an option" 30 80 16 \
    "ONLY OFFICE" "" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "ONLY OFFICE")
            log_message "INFO" "User chose ONLY OFFICE Menu"
            show_onlyoffice_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_utilities_menu
            ;;
    esac
}

show_onlyoffice_menu(){
    options_menu "ONLY OFFICE" \
        "${scriptPaths["onlyoffice_installer"]}" \
        "${scriptPaths["onlyoffice_remover"]}" \
        "show_utilities_menu"
}

show_vscode_menu(){
    options_menu "VS CODE" \
       "${scriptPaths["vscode_installer"]}" \
       "${scriptPaths["vscode_remover"]}" \
       "show_utilities_menu"
}