#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

download_and_install_intel_oneapi_base_toolkit(){
    local intel_oneapi_base_toolkit_version=$1
    local download_link=$2
    local download_path="${DIRECTORY_PATH}/tmp"

    log_message "INFO" "Downloading Intel OneAPI Base Toolkit Version ${intel_oneapi_base_toolkit_version}"
    printc "YELLOW" "-> Downloading Intel OneAPI Base Toolkit Version ${intel_oneapi_base_toolkit_version}..."
    wget -c "$download_link" -O "${download_path}/intel_oneapi_base_toolkit_${intel_oneapi_base_toolkit_version}.sh" || handle_error "Failed to Download Intel OneAPI Base Toolkit"

    log_message "INFO" "Installing Intel OneAPI Base Toolkit Version ${intel_oneapi_base_toolkit_version} in Silent Mode"
    printc "YELLOW" "-> Installing Intel OneAPI Base Toolkit Version ${intel_oneapi_base_toolkit_version} in Silent Mode..."
    chmod +x ${download_path}/intel_oneapi_base_toolkit_${intel_oneapi_base_toolkit_version}.sh
    sudo sh ${download_path}/intel_oneapi_base_toolkit_${intel_oneapi_base_toolkit_version}.sh -a --silent --cli --eula accept || handle_error "Failed to Install Intel OneAPI Base Toolkit"
}

choose_intel_oneapi_base_toolkit_version(){
    log_message "INFO" "Displaying Intel OneAPI Base Toolkit Options Menu"
    local intel_oneapi_base_toolkit_version=$(whiptail --title "Intel OneAPI Base Toolkit Version Menu" --menu "Choose a version :" $HEIGHT $WIDTH 9 \
    "Intel OneAPI Base Toolkit Version 2025.3.0" "" \
    "Intel OneAPI Base Toolkit Version 2025.2.1" "" \
    "Intel OneAPI Base Toolkit Version 2025.2.0" "" \
    "Intel OneAPI Base Toolkit Version 2025.1.3" "" \
    "Intel OneAPI Base Toolkit Version 2025.1.2" "" \
    "Intel OneAPI Base Toolkit Version 2025.1.1" "" \
    "Intel OneAPI Base Toolkit Version 2025.1.0" "" \
    "Intel OneAPI Base Toolkit Version 2025.0.1" "" \
    "Intel OneAPI Base Toolkit Version 2024.2.1" "" \
    3>&1 1>&2 2>&3)

    case $intel_oneapi_base_toolkit_version in
        "Intel OneAPI Base Toolkit Version 2025.3.0")
            download_and_install_intel_oneapi_base_toolkit "2025.3.0" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/d640da34-77cc-4ab2-8019-ac5592f4ec19/intel-oneapi-base-toolkit-2025.3.0.375_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.2.1")
            download_and_install_intel_oneapi_base_toolkit "2025.2.1" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/3b7a16b3-a7b0-460f-be16-de0d64fa6b1e/intel-oneapi-base-toolkit-2025.2.1.44_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.2.0")
            download_and_install_intel_oneapi_base_toolkit "2025.2.0" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/bd1d0273-a931-4f7e-ab76-6a2a67d646c7/intel-oneapi-base-toolkit-2025.2.0.592_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.1.3")
            download_and_install_intel_oneapi_base_toolkit "2025.1.3" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/4a5320d1-0b48-458d-9668-fd0e4501208c/intel-oneapi-base-toolkit-2025.1.3.7_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.1.2")
            download_and_install_intel_oneapi_base_toolkit "2025.1.2" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/ac050ae7-da93-4108-823d-4334de3f4ee8/intel-oneapi-base-toolkit-2025.1.2.9_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.1.1")
            download_and_install_intel_oneapi_base_toolkit "2025.1.1" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/6bfca885-4156-491e-849b-1cd7da9cc760/intel-oneapi-base-toolkit-2025.1.1.36_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.1.0")
            download_and_install_intel_oneapi_base_toolkit "2025.1.0" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/cca951e1-31e7-485e-b300-fe7627cb8c08/intel-oneapi-base-toolkit-2025.1.0.651_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2025.0.1")
            download_and_install_intel_oneapi_base_toolkit "2025.0.1" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/dfc4a434-838c-4450-a6fe-2fa903b75aa7/intel-oneapi-base-toolkit-2025.0.1.46_offline.sh"
            ;;
        "Intel OneAPI Base Toolkit Version 2024.2.1")
            download_and_install_intel_oneapi_base_toolkit "2024.2.1" "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/e6ff8e9c-ee28-47fb-abd7-5c524c983e1c/l_BaseKit_p_2024.2.1.100_offline.sh"
            ;;
        *)
            handle_error "No valid Intel OneAPI Base Toolkit version selected. Exiting..."
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

# Begin Intel OneAPI Base Toolkit Installation
echo "Continue script execution in Intel OneAPI Base Toolkit Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Intel OneAPI Base Toolkit for ${DISTRIBUTION_NAME}"
printc "GREEN" "-> Installing Intel OneAPI Base Toolkit for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with Intel OneAPI Base Toolkit Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Intel OneAPI Base Toolkit Installation..."

    choose_intel_oneapi_base_toolkit_version
    setup_intel_oneapi_environment

    echo "Script Execution in Intel OneAPI Base Toolkit Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Intel OneAPI Base Toolkit Installed Successfully"
else
    handle_error "No Connection Available ! Exiting..."
fi
# End Intel OneAPI Base Toolkit Installation
