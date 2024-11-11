#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in AnaConda Installation at $(date)" >> "$LOG_FILE"

echo "-> Checking for Internet Connection..."
sleep 1
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with AnaConda Installation"
    echo "-> Internet Connection Detected. Proceeding with AnaConda Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    echo "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Downloading Latest Anaconda Package"
    echo "-> Downloading Latest Anaconda Package..."
    sleep 1
    wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh || handle_error "Failed to Download Latest Anaconda Package"

    log_message "INFO" "Making the Anaconda Package Executable"
    echo "-> Making the Anaconda Package Executable..."
    sleep 1
    chmod +x Anaconda3-2024.10-1-Linux-x86_64.sh || handle_error "Failed to Make the Anaconda Package Executable"

    log_message "INFO" "Installing Anaconda to $HOME/anaconda in Silent Mode"
    echo "-> Installing Anaconda3 to $HOME/anaconda in Silent Mode..."
    sleep 1
    bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p $HOME/anaconda || handle_error "Failed to Install Anaconda3 to $HOME/anaconda in Silent Mode"

    log_message "INFO" "Activating AnaConda to Current SHELL Session"
    echo "-> Activating AnaConda to Current SHELL..."
    sleep 1
    eval "$(/$HOME/anaconda/bin/conda shell.bash hook)" || handle_error "Failed to Activate AnaConda to Current SHELL"

    log_message "INFO" "Installing AnaConda's Shell Functions"
    echo "-> Installing Conda's Shell Functions..."
    sleep 1
    conda init || handle_error "Failed to Install Conda's Shell Functions"

    echo "AnaConda Script Completed Successfully at $(date)" >> "$LOG_FILE"
    echo "-> AnaConda Script Completed Successfully"
    echo "Press [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

