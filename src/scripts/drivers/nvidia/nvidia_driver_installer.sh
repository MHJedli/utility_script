#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log
echo "Continue script execution in NVIDIA Driver Installation at $(date)" >> "$LOG_FILE"
trap 'handle_error "An unexpected error occurred."' ERR
clear
download_and_install(){
    local driver_version=$1
    log_message "INFO" "Installing NVIDIA Driver Version ${driver_version}"
    printc "YELLOW" "-> Installing NVIDIA Driver Version ${driver_version}..."
    sudo apt install nvidia-driver-${driver_version} -y || handle_error "Failed to Install NVIDIA Driver ${driver_version}"
}

install_driver(){
    log_message "INFO" "Displaying NVIDIA Driver Menu"
    local driver_options=$(whiptail --title "NVIDIA Driver Installer" --menu "Choose a Driver Version" 30 80 10 \
    "NVIDIA Driver Version 570 [Latest Driver Currently]" "" \
    "NVIDIA Driver Version 560" "" \
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

    case $driver_options in
        "NVIDIA Driver Version 570 [Latest Driver Currently]")
            download_and_install "570"
            ;;
        "NVIDIA Driver Version 560")
            download_and_install "560"
            ;;
        "NVIDIA Driver Version 550")
            download_and_install "550"
            ;;
        "NVIDIA Driver Version 545")
            download_and_install "545"
            ;;
        "NVIDIA Driver Version 535")
            download_and_install "535"
            ;;
        "NVIDIA Driver Version 530")
            download_and_install "530"
            ;;
        "NVIDIA Driver Version 525")
            download_and_install "525"
            ;;
        "NVIDIA Driver Version 520")
            download_and_install "520"
            ;;
        "NVIDIA Driver Version 515")
            download_and_install "515"
            ;;
        "NVIDIA Driver Version 510")
            download_and_install "510"
            ;;
        "NVIDIA Driver Version 470")
            download_and_install "470"
            ;;
        "NVIDIA Driver Version 450")
            download_and_install "450"
            ;;
        "NVIDIA Driver Version 390")
            download_and_install "390"
            ;;
        *)
            handle_error "User chose to Exit Script"
            ;;
    esac

}

install_nvidia_driver_for_ubuntu_or_based(){
    printc "CYAN" "NOTE : This Script Will Install Nvidia Driver Using 'graphics-drivers/ppa' Method"
    echo -n "Press [ENTER] To Continue..."
    read
    
    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    printc "YELLOW" "-> Purging Current NVIDIA Installation if Existed..."
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System"
    printc "YELLOW" "-> Updating System Packages..."
    sudo apt upgrade -y || handle_error "Failed to Upgrade System Packages"

    log_message "INFO" "Installing Required Dependencies"
    printc "YELLOW" "-> Installing Required Dependencies..."
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Adding the graphics-drivers PPA"
    printc "YELLOW" "-> Adding the graphics-drivers PPA..."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y || handle_error "Failed to Add the graphics-drivers PPA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing NVIDIA Driver"
    printc "YELLOW" "-> Installing NVIDIA Driver..."
    install_driver
}

install_nvidia_driver_for_fedora_or_based(){
    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    printc "YELLOW" "-> Purging Current NVIDIA Installation if Existed..."
    sudo dnf remove nvidia* --allowerasing -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo dnf update -y || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Enabling RPM Fusion Repository"
    printc "YELLOW" "-> Enabling RPM Fusion Repository..."
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y || handle_error "Failed to Enable RPM Fusion Repository"
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y || handle_error "Failed to Enable RPM Fusion Repository"

    log_message "INFO" "Installing NVIDIA Driver"
    printc "YELLOW" "-> Installing NVIDIA Driver..."
    sudo dnf install akmod-nvidia -y || handle_error "Failed to Install NVIDIA Driver"

    log_message "INFO" "Installing nvidia-smi"
    printc "YELLOW" "-> Installing nvidia-smi..."
    sudo dnf install xorg-x11-drv-nvidia-cuda -y || handle_error "Failed to Install nvidia-smi" || handle_error "Failed to Install nvidia-smi"
}


# Start NVIDIA Driver Installation
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA Driver Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with NVIDIA Driver Installation"

    log_message "INFO" "Checking for NVIDIA Hardware"
    printc "YELLOW" "-> Checking for NVIDIA Hardware..."
    IS_NVIDIA=$(lspci | grep "NVIDIA")
    if [[ -n "$IS_NVIDIA" ]]; then
        echo "NVIDIA Present :"
        echo $IS_NVIDIA
        echo "Press [ENTER] To Continue..."
        read
        if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
            install_nvidia_driver_for_ubuntu_or_based
        elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then 
            install_nvidia_driver_for_fedora_or_based
        else 
            handle_error "Unsupported Distribution: $DISTRIBUTION"
        fi

        log_message "INFO" "NVIDIA Driver Installation Completed Successfully"
        if whiptail --title "NVIDIA Driver Installed" --yesno "Do you Want to reboot now ?" 8 78; then
            echo "Rebooting..."
            reboot
        fi
    else
        log_message "ERROR" "No NVIDIA Hardware Detected"
        print_msgbox "Info" "No NVIDIA Hardware Detected !"
    fi

else 

    handle_error "No Connection Available ! Exiting..."

fi
# End NVIDIA Driver Installation