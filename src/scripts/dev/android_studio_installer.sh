#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Android Studio Installation at $(date)" >> "$LOG_FILE"

echo "-> Checking for Internet Connection"
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Android Studio Installation"
    echo "-> Internet Connection Detected. Proceeding with Android Studio Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    echo "Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing OpenJDK 17"
    echo "Installing OpenJDK 17..."
    sleep 1
    sudo apt install openjdk-17-jdk -y || handle_error "Failed to Install OpenJDK 17"

    log_message "INFO" "Checking Installed Java version"
    echo "Checking Installed Java version..."
    sleep 1
    java --version || handle_error "Failed to Check Installed Java Version"

    log_message "INFO" "Installing Required Dependencies"
    echo "-> Installing Required Dependencies..."
    sleep 1
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Importing Android Studio Repository"
    echo "Importing Android Studio Repository..."
    sleep 1
    sudo add-apt-repository ppa:maarten-fonville/android-studio -y || handle_error "Failed to Import Android Studio Repository"

    log_message "INFO" "Refreshing Package Cache"
    echo "Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Android Studio"
    echo "Installing Android Studio"
    sleep 1
    sudo apt install android-studio -y || handle_error "Failed to Install Android Studio"

    echo "Android Studio Installed Successfully..."
    read
    echo "Script Execution in Android Studio Installation Ended Successfully at $(date)" >> "$LOG_FILE"
else

    handle_error "No Connection Available ! Exiting..."

fi