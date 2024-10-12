#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Flutter SDK Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Refreshing Package Cache"
echo "-> Refreshing Package Cache..."
sleep 1
sudo apt update || handle_error "Failed to Refresh Package Cache"

log_message "INFO" "Updating System Packages"
echo "-> Updating System Packages..."
sleep 1
sudo apt upgrade -y || handle_error "Failed to Update System Packages"

log_message "INFO" "Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa"
echo "-> Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa..."
sleep 1
sudo apt install -y curl git unzip xz-utils zip libglu1-mesa || handle_error "Failed to Install Required Packages"

log_message "INFO" "Downloading Flutter SDK 3.24.3"
echo "-> Downloading Flutter SDK 3.24.3..."
sleep 1
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.3-stable.tar.xz || handle_error "Failed to Download Flutter SDK"

log_message "INFO" "Extracting Flutter SDK to ~/"
echo "-> Extracting Flutter SDK to ~/"
sleep 1
tar -xvf flutter_linux_3.24.3-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"

log_message "Adding Flutter to PATH (bash)"
echo "-> Adding Flutter to PATH (bash)..."
sleep 1
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc || handle_error "Failed to Add Flutter to PATH (bash)"

log_message "Activating Flutter"
echo "-> Activating Flutter..."
sleep 1
source ~/.bashrc || handle_error "Failed to Activate Flutter"

log_message "Executing flutter doctor -v"
echo "-> Executing flutter doctor -v (It May Take a Little While)"
sleep 1
flutter doctor -v || handle_error "Failed to Execute flutter doctor -v"

echo "Press [ENTER] to exit installer..."
read