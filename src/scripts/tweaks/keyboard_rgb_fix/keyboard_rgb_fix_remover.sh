#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin Keyboard RGB Backlight Fixer Removal
echo "Continue script execution in Keyboard RGB Backlight Fixer Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Removing Keyboard RGB Backlight Fixer Installation"
printc "YELLOW" "-> Removing Keyboard RGB Backlight Fixer Installation..."

if [[ -d ~/clevo-keyboard/ && -f ~/kb.sh ]]; then

    log_message "INFO" "Removing Keyboard RGB Fix Script"
    printc "YELLOW" "-> Removing Keyboard RGB Fix Script..."
    sudo rm -rf ~/clevo-keyboard/
    rm ~/kb.sh

    echo "Keyboard RGB Backlight Fixer Installation Removed Successfully at $(date)" >> "$LOG_FILE"
    if whiptail --title "Keyboard RGB Backlight Fixer Installed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    fi

else

    log_message "WARN" "No Keyboard RGB Backlight Fixer Installation Found. Exiting..."
    print_msgbox "WARNING !" "No Keyboard RGB Backlight Fixer Installation Found !"
    
fi
# End Keyboard RGB Backlight Fixer Removal