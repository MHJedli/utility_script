#!/usr/bin/env bash
source $(pwd)/src/utils.sh

showDriversMenu(){
    log_message "INFO" "Displaying Drivers Menu"
    OPTION=$(whiptail --title "Drivers Menu" --menu "Choose an option" 30 80 16 \
    "NVIDIA Driver" "Install The Proprietary NVIDIA Driver" \
    "NVIDIA CUDA Toolkit" "Install The NVIDIA CUDA Toolkit" \
    "CUDA Version Switcher" "Switch Between Installed CUDA Versions" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $OPTION in
        "NVIDIA Driver")
            log_message "INFO" "User chose NVIDIA Driver Menu"
            showNVIDIADriverMenu
            ;;
        "NVIDIA CUDA Toolkit")
            log_message "INFO" "User chose NVIDIA CUDA Toolkit Menu"
            showNVIDIACUDAMenu
            ;;
        "CUDA Version Switcher")
            log_message "INFO" "User chose to use CUDA Version Switcher"
            . "${scriptPaths["cuda_switcher"]}"
            showDriversMenu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            showMainMenu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

showNVIDIADriverMenu(){
    optionMenu "NVIDIA Driver" \
               "${scriptPaths["nvidia_driver_installer"]}" \
               "${scriptPaths["nvidia_driver_remover"]}" \
               "showDriversMenu"   
}

showNVIDIACUDAMenu(){
    optionMenu "NVIDIA CUDA Toolkit" \
               "${scriptPaths["cuda_installer"]}" \
               "" \
               "showDriversMenu"
}