#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){

    log_message "INFO" "Installing WirePlumber as the session manager"
    printc "YELLOW" "-> Install WirePlumber as the session manager..."
    sudo apt install -y pipewire-media-session- wireplumber || handle_error "Failed to Install WirePlumber"

    log_message "INFO" "Starting WirePlumber for your user"
    printc "YELLOW" "-> Starting WirePlumber for your user..."
    systemctl --user --now enable wireplumber.service || handle_error "Failed to Start WirePlumber for your user"

    log_message "INFO" "Installing ALSA plug-in"
    printc "YELLOW" "-> Installing ALSA plug-in..."
    sudo apt install -y pipewire-audio-client-libraries || handle_error "Failed to Install ALSA Plug-in"

    log_message "INFO" "Installing codecs and remove Bluetooth from PulseAudio, so it would be handled directly by PipeWire"
    printc "YELLOW" "-> Installing codecs and remove Bluetooth from PulseAudio, so it would be handled directly by PipeWire..."
    sudo apt install -y libldacbt-{abr,enc}2 libspa-0.2-bluetooth pulseaudio-module-bluetooth- || handle_error "Failed to Install codecs"
}

install_for_fedora_or_based(){
    if command -v pipewire &> /dev/null; then
        log_message "INFO" "PipeWire is already installed. Exiting..."
        print_msgbox "WARNING !" "PipeWire is already installed !"
        return
    fi
}

# Begin PipeWire Installation
echo "Continue script execution in PipeWire Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}..."
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection" 
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Pipewire Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pipewire Installation"

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS. Exiting..."
    fi

    echo "Pipewire Sound System Installation Completed Successfully at $(date)" >> "$LOG_FILE"
    echo "To verify if Pipewire is installed, execute the following command in the Terminal after rebooting :"
    print_msgbox "INFO" "To verify if Pipewire is installed, execute the following command in the Terminal after rebooting :
                         LANG=C pactl info | grep '^Server Name'"
    if whiptail --title "Pipewire Sound System Installed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    fi

else

    handle_error "No Connection Available ! Exiting..."

fi
# End PipeWire Installation