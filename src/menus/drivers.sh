#!/usr/bin/env bash
source $(pwd)/src/utils.sh

show_drivers_menu(){
    log_message "INFO" "Displaying Drivers Menu"
    local option=$(whiptail --title "Drivers Menu" --menu "Choose an option" 30 80 16 \
    "NVIDIA Driver" "Install The Proprietary NVIDIA Driver" \
    "NVIDIA CUDA Toolkit" "Install The NVIDIA CUDA Toolkit" \
    "CUDA Version Switcher" "Switch Between Installed CUDA Versions" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "NVIDIA Driver")
            log_message "INFO" "User chose NVIDIA Driver Menu"
            show_nvidia_driver_menu
            ;;
        "NVIDIA CUDA Toolkit")
            log_message "INFO" "User chose NVIDIA CUDA Toolkit Menu"
            show_nvidia_cuda_menu
            ;;
        "CUDA Version Switcher")
            log_message "INFO" "User chose to use CUDA Version Switcher"
            . "${scriptPaths["cuda_switcher"]}"
            show_drivers_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

show_nvidia_driver_menu(){
    options_menu "NVIDIA Driver" \
               "${scriptPaths["nvidia_driver_installer"]}" \
               "${scriptPaths["nvidia_driver_remover"]}" \
               "show_drivers_menu"   
}

show_nvidia_cuda_menu(){
    options_menu "NVIDIA CUDA Toolkit" \
               "${scriptPaths["cuda_installer"]}" \
               "" \
               "show_drivers_menu"
}