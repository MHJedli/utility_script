#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_angular(){

    log_message "INFO" "Displaying Angular Installer Options Menu"
    if whiptail --title "Angular Installer" --yesno "Do you want to install The Latest Version of Angular CLI ?" 8 78; then

        log_message "INFO" "Installing Latest Angular Version"
        printc "YELLOW" "-> Installing Latest Angular Version..."
        if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then

            npm install @angular/cli --location=global || handle_error "Failed to Install Latest Angular Version"

        elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then

            sudo npm install @angular/cli --location=global || handle_error "Failed to Install Latest Angular Version"

        fi

    else

        log_message "INFO" "Displaying Available Angular Versions Menu"
        local option=$(whiptail --title "Angular Installer" --menu "Choose a Version to Install" 30 80 3 \
        "Angular CLI 18" "" \
        "Angular CLI 17" "" \
        "Angular CLI 16" "" \
        3>&1 1>&2 2>&3)
        if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then

            case $option in
                "Angular CLI 18")
                    log_message "INFO" "Installing Angular version 18"
                    printc "YELLOW" "-> Installing Angular version 18..."
                    npm install -g @angular/cli@18 || handle_error "Failed to Install Angular version 18"
                    ;;
                "Angular CLI 17")
                    log_message "INFO" "Installing Angular version 17"
                    printc "YELLOW" "-> Installing Angular version 17..."
                    npm install -g @angular/cli@17 || handle_error "Failed to Install Angular version 17"
                    ;;
                "Angular CLI 16")
                    log_message "INFO" "Installing Angular version 16"
                    printc "YELLOW" "-> Installing Angular version 16..."
                    npm install -g @angular/cli@16 || handle_error "Failed to Install Angular version 16"
                    ;;
                *)
                    handle_error "User chose to Exit Script"
                    ;;
            esac        

        elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then

            case $option in
                "Angular CLI 18")
                    log_message "INFO" "Installing Angular version 18"
                    printc "YELLOW" "-> Installing Angular version 18..."
                    sudo npm install -g @angular/cli@18 || handle_error "Failed to Install Angular version 18"
                    ;;
                "Angular CLI 17")
                    log_message "INFO" "Installing Angular version 17"
                    printc "YELLOW" "-> Installing Angular version 17..."
                    sudo npm install -g @angular/cli@17 || handle_error "Failed to Install Angular version 17"
                    ;;
                "Angular CLI 16")
                    log_message "INFO" "Installing Angular version 16"
                    printc "YELLOW" "-> Installing Angular version 16..."
                    sudo npm install -g @angular/cli@16 || handle_error "Failed to Install Angular version 16"
                    ;;
                *)
                    handle_error "User chose to Exit Script"
                    ;;
            esac

        fi

    fi
}

install_packages_for_ubuntu_or_based(){

    log_message "INFO" "Installing NVM"
    printc "YELLOW" "-> Installing NVM..."
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash || handle_error "Failed to install NVM"

    log_message "INFO" "Activating NVM Environment"
    printc "YELLOW" "-> Activating NVM Environment..."
    source $HOME/.bashrc || handle_error "Failed to Activate NVM Environment" 
    source ~/.nvm/nvm.sh || handle_error "Failed to Activate NVM Environment"
    source ~/.profile    

    log_message "INFO" "Installing Node.js 18 LTS"
    printc "YELLOW" "-> Installing Node.js 18 LTS..."
    nvm install 18 || handle_error "Failed to install Node.js 18 LTS"

    log_message "INFO" "Checking Installed Node and NPM Versions"
    printc "YELLOW" "-> Checking Installed Node and NPM Versions..."
    node -v || handle_error "Failed to Print Installed Node Version"
    npm -v || handle_error "Failed to Print Installed NPM Version"
}

install_packages_for_fedora_or_based(){

    log_message "INFO" "Installing NodeJS and npm"
    printc "YELLOW" "-> Installing NodeJS and npm..."
    sudo dnf install nodejs22 npm -y
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

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_packages_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_packages_for_fedora_or_based
    fi

    log_message "INFO" "Checking Installed Node and NPM Versions"
    printc "YELLOW" "-> Checking Installed Node and NPM Versions..."
    node -v || handle_error "Failed to Print Installed Node Version"
    npm -v || handle_error "Failed to Print Installed NPM Version"

    log_message "INFO" "Installing Angular"
    printc "YELLOW" "-> Installing Angular..."
    install_angular

    log_message "INFO" "Displaying Angular Version Check Menu"
    if whiptail --title "Angular Installed Successfully" --yesno "Do Want to check your Installed Version ?" 8 78; then
        log_message "INFO" "Printing Installed Angular Version"
        ng version || handle_error "Failed to Print Installed Angular Version"
    fi

    echo "Script Execution in Angular Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Angular Installed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Angular Installation