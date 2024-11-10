#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Conda Installation at $(date)" >> "$LOG_FILE"

echo "-> Checking for Internet Connection..."
sleep 1
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Conda Installation"
    echo "-> Internet Connection Detected. Proceeding with Conda Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    echo "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Downloading Latest Miniconda Package"
    echo "-> Downloading Latest Miniconda Package..."
    sleep 1
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh || handle_error "Failed to Download Latest Miniconda Package"

    log_message "INFO" "Making the Miniconda3 Package Executable"
    echo "-> Making the Miniconda3 Package Executable..."
    sleep 1
    chmod +x Miniconda3-latest-Linux-x86_64.sh || handle_error "Failed to Make the Miniconda3 Package Executable"

    log_message "INFO" "Installing Miniconda3 to $HOME/miniconda3 in Silent Mode"
    echo "-> Installing Miniconda3 to $HOME/miniconda3 in Silent Mode..."
    sleep 1
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 || handle_error "Failed to Install Miniconda3 to $HOME/miniconda3 in Silent Mode"

    log_message "INFO" "Activating Conda to Current SHELL Session"
    echo "-> Activating Conda to Current SHELL..."
    sleep 1
    eval "$(/$HOME/miniconda3/bin/conda shell.bash hook)" || handle_error "Failed to Activate Conda to Current SHELL"

    log_message "INFO" "Installing Conda's Shell Functions"
    echo "-> Installing Conda's Shell Functions..."
    sleep 1
    conda init || handle_error "Failed to Install Conda's Shell Functions"

    echo "Conda Script Completed Successfully at $(date)" >> "$LOG_FILE"
    echo "-> Conda Script Completed Successfully"
    echo "Press [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

