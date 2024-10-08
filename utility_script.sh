#!/bin/bash

# External Functions/Files
source src/utils.sh
source src/menus/dev.sh
source src/menus/ai.sh
source src/menus/tweaks.sh

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting script execution at $(date)" > "$LOG_FILE"

# Show Main Menu
showMainMenu(){
    clear
    log_message "INFO" "Displaying Main Menu"
    showMenu \
    "         Linux Utility Menu" \
    "Development" \
    "AI" \
    "System Tweaks" \
    "Quit" 

    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Main Menu"

    case $option in
        1)
            log_message "INFO" "User chose Development"
            showDevelopmentMenu
            ;;
        2)
            log_message "INFO" "User chose AI"
            showAIMenu
            ;;
        3)
            log_message "INFO" "User chose System Tweaks"
            showSystemTweaksMenu
            ;;
        4)
            log_message "INFO" "User chose to quit"
            return
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showMainMenu
            ;;
    esac
}

showMainMenu