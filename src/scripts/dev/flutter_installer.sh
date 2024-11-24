#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Flutter SDK Installation at $(date)" >> "$LOG_FILE"

installFlutter(){

    declare -A flutterVersions=(
        ["3.24.5"]=1
        ["3.24.4"]=1
        ["3.24.3"]=1
        ["3.24.2"]=1
        ["3.24.1"]=1
        ["3.24.0"]=1
        ["3.22.3"]=1
        ["3.22.2"]=1
        ["3.22.1"]=1
        ["3.22.0"]=1
        ["3.19.6"]=1
        ["3.19.5"]=1
        ["3.19.4"]=1
        ["3.19.3"]=1
        ["3.19.2"]=1
        ["3.19.1"]=1
        ["3.19.0"]=1
    )
    while true; do

        echo -n -e "${CYAN}Install the Latest Flutter SDK Version ? (Y/n) :${RESET} "
        read option
        log_message "INFO" "User chose option $option"

        if [[ "$option" == "Y" || "$option" == "y" || "$option" == "" ]]; then

            log_message "INFO" "User Chose to Install The Latest Flutter version"

            log_message "INFO" "Downloading Flutter SDK 3.24.5"
            echo -e "${YELLOW}-> Downloading Flutter SDK 3.24.5...${RESET}"
            sleep 1
            wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz || handle_error "Failed to Download Flutter SDK"

            log_message "INFO" "Extracting Flutter SDK to ~/"
            echo -e "${YELLOW}-> Extracting Flutter SDK to ~/${RESET}"
            sleep 1
            tar -xvf flutter_linux_3.24.5-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"
            return

        elif [[ "$option" == "n" || "$option" == "N" ]]; then

            log_message "INFO" "User Chose to Install an Another Flutter Version"

            echo -e "${CYAN}What Flutter Version do you want to install ?${RESET}"
            echo "1. Show Versions"
            echo -n "Select Option/Version : "
            read ov
            log_message "INFO" "User chose option/version $ov"

            if [[ "$ov" == "1" ]]; then

                log_message "INFO" "Printing Flutter Versions"
                for key in "${!flutterVersions[@]}"; do
                    echo "Flutter SDK Version : $key"
                done
                echo -n "Press [ENTER] to continue..."
                read

            elif [[ -v flutterVersions["$ov"] ]]; then
                log_message "INFO" "User chose to install flutter version $ov"

                log_message "INFO" "Downloading Flutter SDK version $ov"
                echo -e "${YELLOW}-> Downloading Flutter SDK $ov${RESET}"
                sleep 1
                wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$ov-stable.tar.xz || handle_error "Failed to Download Flutter SDK version $ov"

                log_message "INFO" "Extracting Flutter SDK to ~/"
                echo -e "${YELLOW}-> Extracting Flutter SDK to ~/${RESET}"
                sleep 1
                tar -xvf flutter_linux_$ov-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"
                return

            else

                log_message "WARN" "User chose a wrong version : $ov"
                echo -e "${RED}Wrong Flutter SDK Version Selected !${RESET}"
                echo "Press [ENTER] to Continue"
                read

            fi

        else

            log_message "WARN" "User chose a wrong option : $option"
            invalidOption

        fi

    done

}

echo -e "${YELLOW}-> Checking for Internet Connection...${RESET}"
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Flutter SDK Installation"
    echo -e "${GREEN}-> Internet Connection Detected. Proceeding with Flutter SDK Installation...${RESET}"
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    echo -e "${YELLOW}-> Refreshing Package Cache...${RESET}"
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System Packages"
    echo -e "${YELLOW}-> Updating System Packages...${RESET}"
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa"
    echo -e "${YELLOW}-> Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa...${RESET}"
    sleep 1
    sudo apt install -y curl git unzip xz-utils zip libglu1-mesa || handle_error "Failed to Install Required Packages"

    installFlutter

    log_message "Adding Flutter to PATH (bash)"
    echo -e "${YELLOW}-> Adding Flutter to PATH (bash)...${RESET}"
    sleep 1
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc || handle_error "Failed to Add Flutter to PATH (bash)"

    log_message "Activating Flutter"
    echo -e "${YELLOW}-> Activating Flutter...${RESET}"
    sleep 1
    source ~/.bashrc || handle_error "Failed to Activate Flutter"

    log_message "Executing flutter doctor -v"
    echo -e "${YELLOW}-> Executing flutter doctor -v (It May Take a Little While)${RESET}"
    sleep 1
    flutter doctor -v || handle_error "Failed to Execute flutter doctor -v"

    log_message "INFO" "Flutter SDK Installer Script Completed Successfully"
    echo -e "${GREEN}-> Flutter SDK Installer Script Completed Successfully...${RESET}"
    echo "Press [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi