#!/usr/bin/env bash

# External Functions/Files
source src/utils.sh
source src/menus/dev.sh
source src/menus/ai.sh
source src/menus/tweaks.sh
source src/menus/drivers.sh
source src/menus/utilities.sh

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting Utility Script GUI Execution at $(date)" > "$LOG_FILE"

# Show Main Menu
show_main_menu(){
    local distro_name=$(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
    local system_arch=$(uname -m)
    log_message "INFO" "Displaying The Main Menu"
    local option=$(whiptail --title "Linux Utility Script" --menu "Choose an option\n(Currently using : ${distro_name} - ${system_arch})" 30 80 16 \
    "Development" "Install Development Apps like Android Studio and Angular" \
    "Utilities" "Install Daily Use Apps like Office Apps, IDE, ..." \
    "AI" "Install Scientific Tools Like TensorFlow and Pytorch" \
    "Drivers" "Install FOSS/Proprietary Drivers Like NVIDIA Drivers" \
    "System Tweaks" "Install Some Goodies for Your System" \
    "Quit" "Exit Linux Utility Script" \
    3>&1 1>&2 2>&3)

    case $option in
        "Development")
            log_message "INFO" "User chose the Development Menu"
            show_development_menu
            ;;
        "Utilities")
            log_message "INFO" "User chose the Utilities Menu"
            show_utilities_menu
            ;;
        "AI")
            log_message "INFO" "User chose the AI Menu"
            show_ai_menu
            ;;
        "Drivers")
            log_message "INFO" "User chose the Drivers Menu"
            show_drivers_menu
            ;;
        "System Tweaks")
            log_message "INFO" "User chose the System Tweaks Menu"
            show_system_tweaks_menu
            ;;
        "Quit")
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting Script..."
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

show_main_menu