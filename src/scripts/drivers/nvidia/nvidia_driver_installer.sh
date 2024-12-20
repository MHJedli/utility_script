#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

downloadAndInstall(){
    local DRIVER_VERSION=$1
    log_message "INFO" "Installing NVIDIA Driver Version ${DRIVER_VERSION}"
    printc "YELLOW" "-> Installing NVIDIA Driver Version ${DRIVER_VERSION}..."
    sudo apt install nvidia-driver-${DRIVER_VERSION} -y || handle_error "Failed to Install NVIDIA Driver ${DRIVER_VERSION}"
}

installDriver(){
    log_message "INFO" "Displaying NVIDIA Driver Menu"
    local DRIVER_OPTIONS=$(whiptail --title "NVIDIA Driver Installer" --menu "Choose a Driver Version" 30 80 10 \
    "NVIDIA Driver Version 560 [Latest Driver Currently]" "" \
    "NVIDIA Driver Version 550" "" \
    "NVIDIA Driver Version 545" "" \
    "NVIDIA Driver Version 535" "" \
    "NVIDIA Driver Version 530" "" \
    "NVIDIA Driver Version 525" "" \
    "NVIDIA Driver Version 520" "" \
    "NVIDIA Driver Version 515" "" \
    "NVIDIA Driver Version 510" "" \
    "NVIDIA Driver Version 470" "" \
    "NVIDIA Driver Version 450" "" \
    "NVIDIA Driver Version 390" "" \
    3>&1 1>&2 2>&3)

    case $DRIVER_OPTIONS in
        "NVIDIA Driver Version 560 [Latest Driver Currently]")
            downloadAndInstall "560"
            ;;
        "NVIDIA Driver Version 550")
            downloadAndInstall "550"
            ;;
        "NVIDIA Driver Version 545")
            downloadAndInstall "545"
            ;;
        "NVIDIA Driver Version 535")
            downloadAndInstall "535"
            ;;
        "NVIDIA Driver Version 530")
            downloadAndInstall "530"
            ;;
        "NVIDIA Driver Version 525")
            downloadAndInstall "525"
            ;;
        "NVIDIA Driver Version 520")
            downloadAndInstall "520"
            ;;
        "NVIDIA Driver Version 515")
            downloadAndInstall "515"
            ;;
        "NVIDIA Driver Version 510")
            downloadAndInstall "510"
            ;;
        "NVIDIA Driver Version 470")
            downloadAndInstall "470"
            ;;
        "NVIDIA Driver Version 450")
            downloadAndInstall "450"
            ;;
        "NVIDIA Driver Version 390")
            downloadAndInstall "390"
            ;;
        *)
            handle_error "User chose to Exit Script"
            ;;
    esac

}

trap 'handle_error "An unexpected error occurred."' ERR

clear

echo "Continue script execution in NVIDIA Driver Installation at $(date)" >> "$LOG_FILE"
sleep 1
printc "CYAN" "NOTE : This Script Will Install Nvidia Driver Using 'graphics-drivers/ppa' Method"
echo -n "Press [ENTER] To Continue..."
read

printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA Driver Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with NVIDIA Driver Installation"

    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    printc "YELLOW" "-> Purging Current NVIDIA Installation if Existed..."
    sleep 1
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System"
    printc "YELLOW" "-> Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Upgrade System Packages"

    log_message "INFO" "Installing Required Dependencies"
    printc "YELLOW" "-> Installing Required Dependencies..."
    sleep 1
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Adding the graphics-drivers PPA"
    printc "YELLOW" "-> Adding the graphics-drivers PPA..."
    sleep 1
    sudo add-apt-repository ppa:graphics-drivers/ppa -y || handle_error "Failed to Add the graphics-drivers PPA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing NVIDIA Driver"
    printc "YELLOW" "-> Installing NVIDIA Driver..."
    sleep 1
    installDriver

    log_message "INFO" "NVIDIA Driver Installation Completed Successfully"
    if whiptail --title "NVIDIA Driver Installed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    fi

    showDriversMenu

else 

    handle_error "No Connection Available ! Exiting..."

fi 