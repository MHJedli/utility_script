#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in PipeWire Installation at $(date)" >> "$LOG_FILE"

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

}

printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Pipewire Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pipewire Installation"

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASED" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASED" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported OS. Exiting..."
    fi

    log_message "INFO" "Pipewire Sound System Installation Completed Successfully"
    echo "To verify if Pipewire is installed, execute the following command in the Terminal after rebooting :"
    printc "CYAN" "LANG=C pactl info | grep '^Server Name'"
    echo -n -e "${GREEN}Pipewire Sound System Installation Completed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Reboot in 3 seconds..."
        reboot
    fi
    echo "Press [ENTER] To exit Script..."
    read

else

    handle_error "No Connection Available ! Exiting..."

fi