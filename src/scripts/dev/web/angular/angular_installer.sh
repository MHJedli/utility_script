#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$SCRIPTS_PATH"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_angular(){
    local angular_version=$1
    log_message "INFO" "Installing Angular version ${angular_version}"
    printc "YELLOW" "-> Installing Angular version ${angular_version}..."
    npm install -g @angular/cli@${angular_version} || handle_error "Failed to Install Angular version ${angular_version}"
}

choose_angular(){

    log_message "INFO" "Displaying Angular Installer Options Menu"
    if whiptail --title "Angular Installer" --yesno "Do you want to install The Latest Version of Angular CLI ?" $HEIGHT $WIDTH; then

        log_message "INFO" "Installing Latest Angular Version"
        printc "YELLOW" "-> Installing Latest Angular Version..."
        npm install @angular/cli --location=global || handle_error "Failed to Install Latest Angular Version"

    else

        log_message "INFO" "Displaying Available Angular Versions Menu"
        local option=$(whiptail --title "Angular Installer" --menu "Choose a Version to Install" $HEIGHT $WIDTH 6 \
        "Angular CLI 21" "" \
        "Angular CLI 20" "" \
        "Angular CLI 19" "" \
        "Angular CLI 18" "" \
        "Angular CLI 17" "" \
        "Angular CLI 16" "" \
        3>&1 1>&2 2>&3)

        case $option in
            "Angular CLI 21")
                install_angular "21"
                ;;
            "Angular CLI 20")
                install_angular "20"
                ;;
            "Angular CLI 19")
                install_angular "19"
                ;;
            "Angular CLI 18")
                install_angular "18"
                ;;
            "Angular CLI 17")
                install_angular "17"
                ;;
            "Angular CLI 16")
                install_angular "16"
                ;;
            *)
                handle_error "User chose to Exit Script"
                ;;
        esac  
    fi      
}

# Begin Angular Installation
echo "Continue script execution in Angular Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Angular for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Angular for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Angular Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Angular Installation..."

    log_message "INFO" "Note to show"
    print_msgbox "INFO" "Remember to install an even version of NodeJS (24, 22, 20; ...) for Angular to work"

    log_message "INFO" "Installing NodeJS"
    printc "YELLOW" "-> Installing NodeJS..."
    bash "${scriptPaths["nodejs_installer"]}"

    log_message "INFO" "Activating NVM"
    printc "YELLOW" "-> Activating NVM..."
    \. "$HOME/.nvm/nvm.sh"

    log_message "INFO" "Installing Angular"
    printc "YELLOW" "-> Installing Angular..."
    choose_angular

    log_message "INFO" "Displaying Angular Version Check Menu"
    if whiptail --title "Angular Installed Successfully" --yesno "Do Want to check your Installed Version ?" $HEIGHT $WIDTH; then
        log_message "INFO" "Printing Installed Angular Version"
        ng version || handle_error "Failed to Print Installed Angular Version"
    fi

    echo "Script Execution in Angular Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Angular Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Angular Installation