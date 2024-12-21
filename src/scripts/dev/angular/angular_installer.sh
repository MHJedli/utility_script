#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Angular Installation at $(date)" >> "$LOG_FILE"

install_angular(){
    log_message "INFO" "Displaying Angular Installer Options Menu"
    if whiptail --title "Angular Installer" --yesno "Do you want to install The Latest Version of Angular CLI ?" 8 78; then
        log_message "INFO" "Installing Latest Angular Version"
        printc "YELLOW" "-> Installing Latest Angular Version..."
        sleep 1
        npm install @angular/cli --location=global || handle_error "Failed to Install Latest Angular Version"
    else
        log_message "INFO" "Displaying Available Angular Versions Menu"
        local option=$(whiptail --title "Angular Installer" --menu "Choose a Version to Install" 30 80 3 \
        "Angular CLI 18" "" \
        "Angular CLI 17" "" \
        "Angular CLI 16" "" \
        3>&1 1>&2 2>&3)

        case $option in
            "Angular CLI 18")
                log_message "INFO" "Installing Angular version 18"
                printc "YELLOW" "-> Installing Angular version 18..."
                sleep 1
                npm install -g @angular/cli@18 || handle_error "Failed to Install Angular version 18"
                ;;
            "Angular CLI 17")
                log_message "INFO" "Installing Angular version 17"
                printc "YELLOW" "-> Installing Angular version 17..."
                sleep 1
                npm install -g @angular/cli@17 || handle_error "Failed to Install Angular version 17"
                ;;
            "Angular CLI 16")
                log_message "INFO" "Installing Angular version 16"
                printc "YELLOW" "-> Installing Angular version 16..."
                sleep 1
                npm install -g @angular/cli@16 || handle_error "Failed to Install Angular version 16"
                ;;
            *)
                handle_error "User chose to Exit Script"
                ;;
        esac
    fi
}

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Angular Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Angular Installation..."

    log_message "INFO" "Installing NVM"
    printc "YELLOW" "-> Installing NVM..."
    sleep 1
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash || handle_error "Failed to install NVM"

    log_message "INFO" "Activating NVM Environment"
    printc "YELLOW" "-> Activating NVM Environment..."
    sleep 1
    source $HOME/.bashrc || handle_error "Failed to Activate NVM Environment" 
    source ~/.nvm/nvm.sh || handle_error "Failed to Activate NVM Environment"
    source ~/.profile    || handle_error "Failed to Activate NVM Environment"

    log_message "INFO" "Installing Node.js 18 LTS"
    printc "YELLOW" "-> Installing Node.js 18 LTS..."
    sleep 1
    nvm install 18 || handle_error "Failed to install Node.js 18 LTS"

    log_message "INFO" "Checking Installed Node and NPM Versions"
    printc "YELLOW" "-> Checking Installed Node and NPM Versions..."
    sleep 1
    node -v || handle_error "Failed to Print Installed Node Version"
    npm -v || handle_error "Failed to Print Installed NPM Version"

    log_message "INFO" "Installing Angular"
    printc "YELLOW" "-> Installing Angular..."
    sleep 1
    install_angular

    log_message "INFO" "Displaying Angular Version Check Menu"
    if whiptail --title "Angular Installed Successfully" --yesno "Do Want to check your Installed Version ?" 8 78; then
        log_message "INFO" "Printing Installed Angular Version"
        ng version || handle_error "Failed to Print Installed Angular Version"
    fi

    echo "Script Execution in Angular Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Angular Installed Successfully"
    show_development_menu

else

    handle_error "No Internet Connection Available, Exiting..."

fi



