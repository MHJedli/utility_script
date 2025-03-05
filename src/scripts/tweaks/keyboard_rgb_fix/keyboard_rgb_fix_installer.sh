#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin Keyboard RGB Backlight Fixer Installation
echo "Continue script execution in Keyboard RGB Backlight Fixer Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Printing Keyboard RGB Fixer Note"
print_msgbox "WARNING !" "This solution May NOT Work for You !"

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Keyboard RGB Backlight Fixer Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Keyboard RGB Backlight Fixer Installation"

    log_message "INFO" "Downloading Keyboard RGB Fix Script"
    printc "YELLOW" "-> Downloading Script..."
    DOWNLOAD_LINK="https://github.com/wessel-novacustom/clevo-keyboard/raw/master/kb.sh"
    DOWNLOAD_PATH="$(pwd)/tmp"
    wget -c -P "$DOWNLOAD_PATH/" "$DOWNLOAD_LINK" || handle_error "Failed to Download Script"

    log_message "INFO" "Setting Keyboard RGB Fix Script Permissions"
    printc "YELLOW" "-> Setting Keyboard RGB Fix Script Permissions..."
    chmod +x "$DOWNLOAD_PATH/kb.sh" || handle_error "Failed to Set up Script Permissions"
    
    log_message "INFO" "Executing Keyboard RGB Fix Script"
    printc "YELLOW" "-> Executing Keyboard RGB Fix Script..."
    sudo bash "$DOWNLOAD_PATH/kb.sh" || handle_error "Failed to Execute Keyboard RGB Fix Script"

    echo "Keyboard RGB Backlight Fixer Installation Completed Successfully at $(date)" >> "$LOG_FILE"
    if whiptail --title "Keyboard RGB Backlight Fixer Installed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    fi

else

    handle_error "No Connection Available ! Exiting..."

fi
# End Keyboard RGB Backlight Fixer Installation