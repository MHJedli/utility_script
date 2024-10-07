#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log


installDriver(){
    declare -A versions=(
    ["560"]=1
    ["550"]=1
    ["545"]=1
    ["535"]=1
    ["530"]=1
    ["525"]=1
    ["520"]=1
    ["515"]=1
    ["510"]=1
    ["470"]=1
    ["450"]=1
    ["390"]=1
    )
    while true; do
        echo "What NVIDIA Driver version do you want to install ? (560, 550, 545, 535, 530, 525, 520, 515, 510, 470, 450, 390)"
        echo -n "NVIDIA Driver Version [DEFAULT=560]: "
        read version
        log_message "INFO" "User selected option $version"
        if [[ "$version" == "" ]]; then
            log_message "INFO" "User chose the Default NVIDIA Driver Version"
            echo "Installing NVIDIA Driver Version 560..."
            sudo apt install nvidia-driver-560 -y || handle_error "Failed to Install NVIDIA Driver 560"
            return
        elif [[ -v versions["$version"] ]]; then
            log_message "INFO" "User chose NVIDIA Driver Version $version"
            echo "Installing NVIDIA Driver Version $version"
            sudo apt install nvidia-driver-$version -y || handle_error "Failed to Install NVIDIA Driver $version"
            return
        else
            log_message "WARN" "User chose invalid NVIDIA Driver Version : $version"
            echo "Wrong Version Selected !"
            read
            clear
        fi
    done

}

trap 'handle_error "An unexpected error occurred."' ERR

clear

echo "Continue script execution in NVIDIA Driver Installation at $(date)" >> "$LOG_FILE"

if check_internet; then

    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    echo "Purging Current NVIDIA Installation if Existed..."
    sleep 1
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    echo "Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System"
    echo "Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Upgrade System Packages"

    log_message "INFO" "Installing Required Dependencies"
    echo "Installing Required Dependencies..."
    sleep 1
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Adding the graphics-drivers PPA"
    echo "Adding the graphics-drivers PPA..."
    sleep 1
    sudo add-apt-repository ppa:graphics-drivers/ppa -y || handle_error "Failed to Add the graphics-drivers PPA"

    log_message "INFO" "Refreshing Package Cache"
    echo "Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing NVIDIA Driver"
    echo "Installing NVIDIA Driver..."
    sleep 1
    installDriver

else 

    handle_error "No Connection Available ! Exiting..."

fi 