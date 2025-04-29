#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_miniconda(){

    log_message "INFO" "Downloading Latest Miniconda Package"
    printc "YELLOW" "-> Downloading Latest Miniconda Package..."
    local download_path="$(pwd)/tmp"
    local download_link="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    wget -c -P "$download_path/" "$download_link" || handle_error "Failed to Download Latest Miniconda Package"

    log_message "INFO" "Making the Miniconda3 Package Executable"
    printc "YELLOW" "-> Making the Miniconda3 Package Executable..."
    chmod +x "${download_path}/Miniconda3-latest-Linux-x86_64.sh" || handle_error "Failed to Make the Miniconda3 Package Executable"

    log_message "INFO" "Installing Miniconda3 to $HOME/miniconda3 in Silent Mode"
    printc "YELLOW" "-> Installing Miniconda3 to $HOME/miniconda3 in Silent Mode..."
    bash "${download_path}/Miniconda3-latest-Linux-x86_64.sh" -b -p "$HOME/miniconda3" || handle_error "Failed to Install Miniconda3 to $HOME/miniconda3 in Silent Mode"

    log_message "INFO" "Activating Conda to Current SHELL Session"
    printc "YELLOW" "-> Activating Conda to Current SHELL..."
    eval "$(/$HOME/miniconda3/bin/conda shell.bash hook)" || handle_error "Failed to Activate Conda to Current SHELL"

    log_message "INFO" "Installing Conda's Shell Functions"
    printc "YELLOW" "-> Installing Conda's Shell Functions..."
    conda init || handle_error "Failed to Install Conda's Shell Functions"

}

install_anaconda(){

    log_message "INFO" "Downloading Latest Anaconda Package"
    printc "YELLOW" "-> Downloading Latest Anaconda Package..."
    local download_path="$(pwd)/tmp"
    local download_link="https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh"
    wget -c -P "$download_path/" "$download_link" || handle_error "Failed to Download Latest Anaconda Package"

    log_message "INFO" "Making the Anaconda Package Executable"
    printc "YELLOW" "-> Making the Anaconda Package Executable..."
    chmod +x "${download_path}/Anaconda3-2024.10-1-Linux-x86_64.sh" || handle_error "Failed to Make the Anaconda Package Executable"

    log_message "INFO" "Installing Anaconda to $HOME/anaconda in Silent Mode"
    printc "YELLOW" "-> Installing Anaconda3 to $HOME/anaconda in Silent Mode..."
    bash "${download_path}/Anaconda3-2024.10-1-Linux-x86_64.sh" -b -p "$HOME/anaconda" || handle_error "Failed to Install Anaconda3 to $HOME/anaconda in Silent Mode"

    log_message "INFO" "Activating AnaConda to Current SHELL Session"
    printc "YELLOW" "-> Activating AnaConda to Current SHELL..."
    eval "$(/$HOME/anaconda/bin/conda shell.bash hook)" || handle_error "Failed to Activate AnaConda to Current SHELL"

    log_message "INFO" "Installing AnaConda's Shell Functions"
    printc "YELLOW" "-> Installing Conda's Shell Functions..."
    conda init || handle_error "Failed to Install Conda's Shell Functions"

}

choose_menu(){
    log_message "INFO" "Displaying Available Options"
    local option=$(whiptail --title "Conda Installer Script" --menu "What Do you want to Install ?" 30 80 2 \
    "Miniconda" "Minimal Installer ( 120MB+ Download Size )" \
    "Anaconda" "Larger Distribution ( 1GB+ Download Size )" \
    3>&1 1>&2 2>&3)

    case $option in
        "Miniconda")
            log_message "INFO" "User chose to install Miniconda"
            install_miniconda
            ;;
        "Anaconda")
            log_message "INFO" "User chose to install Anaconda"
            install_anaconda
            ;;
        *)
            handle_error "User chose to Exit Installer"
            ;;
    esac
}

# Begin Conda Installation
echo "Continue script execution in Conda Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Conda Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Conda Installation..."

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n $UBUNTU_BASE ]]; then
        sudo apt update || handle_error "Failed to Refresh Package Cache"
    elif [[ "$DISTRIBUTION" == "fedora" || -n $FEDORA_BASE ]]; then
        sudo dnf update -y || handle_error "Failed to Refresh Package Cache"
    fi
    
    choose_menu

    echo "Conda Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Conda Script Completed Successfully"

    exec bash

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Conda Installation