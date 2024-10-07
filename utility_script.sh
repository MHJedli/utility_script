#!/bin/bash

# External Functions
source src/utils.sh

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting script execution at $(date)" > "$LOG_FILE"

show

# Show Development Menu
showDevelopmentMenu(){

}

# Show AI Menu
showAIMenu(){

}

# Show System Tweaks Menu
showSystemTweaksMenu(){
    
}

# Show Main Menu
showMainMenu(){
    clear
    log_message "INFO" "Displaying Main Menu"
    echo "--------------------------------------"
    echo "         Linux Utility Menu           "
    echo "--------------------------------------"
    echo '1. Development'
    echo '2. AI'
    echo '3. System Tweaks'
    echo 'q. Quit'
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
        q)
            log_message "INFO" "User chose to quit"
            exit 1
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showMainMenu
            ;;
    esac
}

showMainMenu