#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin Intel OneAPI Base Toolkit Removal
echo "Continue script execution in Intel OneAPI Base Toolkit Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Removing Intel OneAPI Base Toolkit for ${DISTRIBUTION_NAME}"
printc "YELLOW" "-> Removing Intel OneAPI Base Toolkit for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Removing Intel OneAPI Base Toolkit Installation Directory"
printc "YELLOW" "-> Removing Intel OneAPI Base Toolkit Installation Directory..."
sudo rm -rf /opt/intel/ 

log_message "INFO" "Removing Installer cache"
printc "YELLOW" "-> Removing Installer cache..."
sudo rm -rf /var/intel/*

log_message "INFO" "Removing Intel OneAPI Base Toolkit Environment Variables if existed"
printc "YELLOW" "-> Removing Intel OneAPI Base Toolkit Environment Variables if existed..."
if grep 'source /opt/intel/oneapi/setvars.sh' ~/.bashrc &> /dev/null; then
    sed -i '/source \/opt\/intel\/oneapi\/setvars.sh/d' ~/.bashrc
fi

echo "Intel OneAPI Base Toolkit Removal Script Completed Successfully at $(date)" >> "$LOG_FILE"
print_msgbox "Success !" "Intel OneAPI Base Toolkit Removal Completed Successfully"
# End Intel OneAPI Base Toolkit Removal