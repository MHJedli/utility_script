#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Angular Installation at $(date)" >> "$LOG_FILE"

installAngular(){
    declare -A versions=(
        ["17"]=1
        ["16"]=1
        ["15"]=1
    )
    while true; do
        echo -n "Install Latest Angular Version ? (Y/n) : "
        read a
        log_message "INFO" "User chose option $a"
        if [[ "$a" == "Y" || "$a" == "y" || "$a" == ""  ]]; then
            log_message "INFO" "Installing Latest Angular Version"
            echo "Installing Latest Angular Version..."
            sleep 1
            npm install @angular/cli --location=global || handle_error "Failed to Install Latest Angular Version"
            return
        elif [[ "$a" == "n" || "$a" == "N" ]]; then
            log_message "INFO" "User chose to select specific Angular version"
            echo "What Version Do you want to install ? (17, 16, 15)"
            echo "Angular Version : "
            read version
            log_message "INFO" "User chose version $version"
            if [[ -v versions["$version"] ]]; then
                log_message "INFO" "Installing Angular version $version"
                echo "Installing Angular version $version"
                sleep 1
                npm install -g @angular/cli@"$version" || handle_error "Failed to Install Angular version $version"
                return
            else
                echo "Wrong Version Selected !"
                read
                clear
            fi
        fi
    done
}

echo "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Angular Installation"
    echo "-> Internet Connection Detected. Proceeding with Angular Installation..."

    log_message "INFO" "Installing NVM"
    echo "-> Installing NVM..."
    sleep 1
    curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash || handle_error "Failed to install NVM"

    log_message "INFO" "Activating NVM Environment"
    echo "-> Activating NVM Environment..."
    sleep 1
    source $HOME/.bashrc || handle_error "Failed to Activate NVM Environment" 
    source ~/.nvm/nvm.sh || handle_error "Failed to Activate NVM Environment"
    source ~/.profile    || handle_error "Failed to Activate NVM Environment"

    log_message "INFO" "Installing Node.js 18 LTS"
    echo "-> Installing Node.js 18 LTS..."
    sleep 1
    nvm install 18 || handle_error "Failed to install Node.js 18 LTS"

    log_message "INFO" "Checking Installed Node and NPM Versions"
    echo "-> Checking Installed Node and NPM Versions..."
    sleep 1
    node -v || handle_error "Failed to Print Installed Node Version"
    npm -v || handle_error "Failed to Print Installed NPM Version"

    log_message "INFO" "Installing Angular"
    echo "-> Installing Angular..."
    sleep 1
    installAngular

    echo -n "Angular Installed Successfully. Want to check your Installed Version ? (Y/n) : "
    read a
    if [[ "$a" == "y" || "$a" == "Y" || "$a" == "" ]];then
        log_message "INFO" "Printing Installed Angular Version"
        ng version || handle_error "Failed to Print Installed Angular Version"
    fi

    echo "Script Execution in Angular Installation Ended Successfully at $(date)" >> "$LOG_FILE"

else

    handle_error "No Internet Connection Available, Exiting..."

fi



