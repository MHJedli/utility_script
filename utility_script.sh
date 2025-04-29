#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
DEV_MENU="${DIRECTORY_PATH}/src/menus/dev.sh"
AI_MENU="${DIRECTORY_PATH}/src/menus/ai.sh"
TWEAKS_MENU="${DIRECTORY_PATH}/src/menus/tweaks.sh"
DRIVERS_MENU="${DIRECTORY_PATH}/src/menus/drivers.sh"
UTILITIES_MENU="${DIRECTORY_PATH}/src/menus/utilities.sh"
source "$UTILS"

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting Utility Script GUI Execution at $(date)" > "$LOG_FILE"

show_system_info(){
    local distro_name=$(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
    local system_arch=$(uname -m)
    echo ${distro_name} - ${system_arch}
}

# Show Main Menu
show_main_menu(){
    local system_info=$(show_system_info)
    log_message "INFO" "Displaying The Main Menu"
    local option=$(whiptail --title "Linux Utility Script" --menu "Choose an option\n(Currently using : ${system_info})" 30 80 16 \
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
            source "$DEV_MENU"
            ;;
        "Utilities")
            log_message "INFO" "User chose the Utilities Menu"
            source "$UTILITIES_MENU"
            ;;
        "AI")
            log_message "INFO" "User chose the AI Menu"
            source "$AI_MENU"
            ;;
        "Drivers")
            log_message "INFO" "User chose the Drivers Menu"
            source "$DRIVERS_MENU"
            ;;
        "System Tweaks")
            log_message "INFO" "User chose the System Tweaks Menu"
            source "$TWEAKS_MENU"
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

# Begin Utility Script
log_message "INFO" "Checking for Required Packages : whiptail"
printc "YELLOW" "-> Checking for Required Packages : whiptail..."
verify_packages "whiptail"
show_main_menu
# End Utility Script