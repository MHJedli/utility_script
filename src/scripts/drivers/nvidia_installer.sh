#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log


installDriver(){

    declare -A nvidiaVersions=(
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

        echo -e "${CYAN}What NVIDIA Driver version do you want to install ?${}"
        echo "1. Show Available versions"
        echo -n "NVIDIA Driver Version [DEFAULT=560] : "
        read version
        log_message "INFO" "User selected option $version"

        if [[ "$version" == "1" ]]; then

            log_message "INFO" "Showing Available Version of NVIDIA Driver"
            echo "Available NVIDIA Version to Install :"
            for key in "${!nvidiaVersions[@]}"; do
                echo "$key"
            done
            echo -n "Press [ENTER] to continue..."
            read

        elif [[ "$version" == "" ]]; then

            log_message "INFO" "User chose the Default NVIDIA Driver Version"
            echo -e "${YELLOW}Installing NVIDIA Driver Version 560...${RESET}"
            sudo apt install nvidia-driver-560 -y || handle_error "Failed to Install NVIDIA Driver 560"
            return

        elif [[ -v nvidiaVersions["$version"] ]]; then

            log_message "INFO" "User chose NVIDIA Driver Version $version"
            echo -e "${YELLOW}Installing NVIDIA Driver Version $version${RESET}"
            sudo apt install nvidia-driver-$version -y || handle_error "Failed to Install NVIDIA Driver $version"
            return

        else

            log_message "WARN" "User chose invalid NVIDIA Driver Version : $version"
            invalidOption
            clear

        fi

    done

}

trap 'handle_error "An unexpected error occurred."' ERR

clear

echo "Continue script execution in NVIDIA Driver Installation at $(date)" >> "$LOG_FILE"
sleep 1

echo -e "${YELLOW}-> Checking for Internet Connection${RESET}"
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA Driver Installation"
    echo -e "${GREEN}Internet Connection Detected. Proceeding with NVIDIA Driver Installation${RESET}"

    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    echo -e "${YELLOW}-> Purging Current NVIDIA Installation if Existed...${RESET}"
    sleep 1
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    echo -e "${YELLOW}-> Refreshing Package Cache...${RESET}"
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System"
    echo -e "${YELLOW}-> Updating System Packages...${RESET}"
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Upgrade System Packages"

    log_message "INFO" "Installing Required Dependencies"
    echo -e "${YELLOW}-> Installing Required Dependencies...${RESET}"
    sleep 1
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Adding the graphics-drivers PPA"
    echo -e "${YELLOW}-> Adding the graphics-drivers PPA...${RESET}"
    sleep 1
    sudo add-apt-repository ppa:graphics-drivers/ppa -y || handle_error "Failed to Add the graphics-drivers PPA"

    log_message "INFO" "Refreshing Package Cache"
    echo -e "${YELLOW}-> Refreshing Package Cache...${RESET}"
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing NVIDIA Driver"
    echo -e "${YELLOW}-> Installing NVIDIA Driver...${RESET}"
    sleep 1
    installDriver

    log_message "INFO" "NVIDIA Driver Installation Completed Successfully"
    echo -n -e "${GREEN}NVIDIA Driver Installation Completed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Reboot in 3 seconds..."
        reboot
    fi

else 

    handle_error "No Connection Available ! Exiting..."

fi 