#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

download_and_install_intel_oneapi_hpc_toolkit(){
    local intel_oneapi_hpc_toolkit_version=$1
    local download_link=$2
    local download_path="${DIRECTORY_PATH}/tmp"

    log_message "INFO" "Downloading Intel OneAPI HPC Toolkit Version ${intel_oneapi_hpc_toolkit_version}"
    printc "YELLOW" "-> Downloading Intel OneAPI HPC Toolkit Version ${intel_oneapi_hpc_toolkit_version}..."
    wget -c "$download_link" -O "${download_path}/intel_oneapi_hpc_toolkit_${intel_oneapi_hpc_toolkit_version}.sh" || handle_error "Failed to Download Intel OneAPI HPC Toolkit"

    log_message "INFO" "Installing Intel OneAPI HPC Toolkit Version ${intel_oneapi_hpc_toolkit_version} in Silent Mode"
    printc "YELLOW" "-> Installing Intel OneAPI HPC Toolkit Version ${intel_oneapi_hpc_toolkit_version} in Silent Mode..."
    chmod +x ${download_path}/intel_oneapi_hpc_toolkit_${intel_oneapi_hpc_toolkit_version}.sh
    sudo sh ${download_path}/intel_oneapi_hpc_toolkit_${intel_oneapi_hpc_toolkit_version}.sh -a --silent --cli --eula accept || handle_error "Failed to Install Intel OneAPI HPC Toolkit"
}

choose_intel_oneapi_hpc_toolkit_version(){
    log_message "INFO" "Displaying Intel OneAPI HPC Toolkit Options Menu"
    local intel_oneapi_hpc_toolkit_version=$(whiptail --title "Intel OneAPI HPC Toolkit Version Menu" --menu "Choose a version :" $HEIGHT $WIDTH 1 \
    "Intel OneAPI HPC Toolkit Version 2025.3.0" "" \
    3>&1 1>&2 2>&3)

    case $intel_oneapi_hpc_toolkit_version in
        "Intel OneAPI HPC Toolkit Version 2025.3.0")
            download_and_install_intel_oneapi_hpc_toolkit "2025.3.0" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/66021d90-934d-41f4-bedf-b8c00bbe98bc/intel-oneapi-hpc-toolkit-2025.3.0.381_offline.sh"
            ;;
        *)
            handle_error "No valid Intel OneAPI HPC Toolkit version selected. Exiting..."
            ;;
    esac

}

setup_intel_oneapi_environment(){
    log_message "INFO" "Setting up Intel OneAPI Environment Variables"
    printc "YELLOW" "-> Setting up Intel OneAPI Environment Variables..."
    if [[ -f /opt/intel/oneapi/setvars.sh ]]; then
        if whiptail --title "Setup Intel OneAPI Environment Variables" --yesno "Do you want to automatically set up Intel OneAPI environment variables ?" $HEIGHT $WIDTH; then

            if ! grep 'source /opt/intel/oneapi/setvars.sh' ~/.bashrc &> /dev/null; then
                echo "source /opt/intel/oneapi/setvars.sh" >> ~/.bashrc
                log_message "INFO" "Intel OneAPI Environment Variables Set Successfully"
                print_msgbox "Success !" "Intel OneAPI Environment Variables Set Successfully"
            else
                log_message "INFO" "Intel OneAPI Environment Variables Already Set in .bashrc"
                print_msgbox "Notice" "Intel OneAPI Environment Variables are already set in your .bashrc file."
            fi
            print_msgbox "Note" "Restart your terminal to apply the changes."    

        else
            log_message "INFO" "User chose not to set up Intel OneAPI Environment Variables automatically"
            print_msgbox "Notice" "Please remember to execute \"source /opt/intel/oneapi/setvars.sh\" manually to use Intel OneAPI tools"
        fi
    else
        handle_error "Intel OneAPI setvars.sh file not found! Cannot set up environment variables."
    fi

}

# Begin Intel OneAPI HPC Toolkit Installation
echo "Continue script execution in Intel OneAPI HPC Toolkit Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Intel OneAPI HPC Toolkit for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Intel OneAPI HPC Toolkit for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with Intel OneAPI HPC Toolkit Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Intel OneAPI HPC Toolkit Installation..."

    choose_intel_oneapi_hpc_toolkit_version
    setup_intel_oneapi_environment

    echo "Script Execution in Intel OneAPI HPC Toolkit Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Intel OneAPI HPC Toolkit Installed Successfully"
else
    handle_error "No Connection Available ! Exiting..."
fi
# End Intel OneAPI HPC Toolkit Installation
