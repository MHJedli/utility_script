#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Keyboard RGB Backlight Fixer Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "NOTE : This solution May NOT Work for You !"
echo "PRESS [ENTER] To Continue..."
read

printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Keyboard RGB Backlight Fixer Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Keyboard RGB Backlight Fixer Installation"

    log_message "INFO" "Downloading Keyboard RGB Fix Script"
    printc "YELLOW" "-> Downloading Script..."
    wget -c -P $(pwd)/tmp/ https://github.com/wessel-novacustom/clevo-keyboard/raw/master/kb.sh || handle_error "Failed to Download Script"

    log_message "INFO" "Setting Keyboard RGB Fix Script Permissions"
    printc "YELLOW" "-> Setting Keyboard RGB Fix Script Permissions..."
    chmod +x $(pwd)/tmp/kb.sh || handle_error "Failed to Set up Script Permissions"

    log_message "INFO" "Executing Keyboard RGB Fix Script"
    printc "YELLOW" "-> Executing Keyboard RGB Fix Script..."
    sudo bash $(pwd)/tmp/kb.sh || handle_error "Failed to Execute Keyboard RGB Fix Script"

    log_message "INFO" "Keyboard RGB Backlight Fixer Installation Completed Successfully"
    echo -n -e "${GREEN}Keyboard RGB Backlight Fixer Installation Completed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Reboot in 3 seconds..."
        reboot
    fi

else

    handle_error "No Connection Available ! Exiting..."

fi