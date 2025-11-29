#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_toolkits_menu(){
    log_message "INFO" "Displaying Toolkits Menu"
    local option=$(whiptail --title "Toolkits Menu" --menu "Choose an option" $HEIGHT $WIDTH 4 \
    "Intel OneAPI" "" \
    "NVIDIA CUDA Toolkit" "Create high-performance, GPU-accelerated applications" \
    "CUDA Version Switcher" "Switch Between Installed CUDA Versions" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Intel OneAPI")
            log_message "INFO" "User chose Intel OneAPI Base Toolkit Installer"
            show_intel_oneapi_menu
            ;;
        "NVIDIA CUDA Toolkit")
            log_message "INFO" "User chose NVIDIA CUDA Toolkit Menu"
            show_nvidia_cuda_menu
            ;;
        "CUDA Version Switcher")
            log_message "INFO" "User chose to use CUDA Version Switcher"
            . "${scriptPaths["cuda_switcher"]}"
            show_toolkits_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_intel_oneapi_menu(){
    log_message "INFO" "Displaying Intel OneAPI Menu"
    local option=$(whiptail --title "Intel OneAPI Menu" --menu "Choose an option" $HEIGHT $WIDTH 3 \
    "Base Toolkit" "Set of tools and libraries for developing high-performance, data-centric applications" \
    "HPC Toolkit" "Build, analyze, optimize, and scale high-performance computing applications" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Base Toolkit")
            log_message "INFO" "User chose Intel OneAPI Base Toolkit Menu"
            show_base_toolkit_menu
            ;;
        "HPC Toolkit")
            log_message "INFO" "User chose Intel OneAPI HPC Toolkit Menu"
            show_hpc_toolkit_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Toolkits Menu"
            show_toolkits_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_base_toolkit_menu(){
    options_menu "Intel OneAPI Base Toolkit" \
               "${scriptPaths["intel_oneapi_base_toolkit_installer"]}" \
               "${scriptPaths["intel_oneapi_base_toolkit_remover"]}" \
               "show_intel_oneapi_menu"
}

show_hpc_toolkit_menu(){
    options_menu "Intel OneAPI HPC Toolkit" \
               "${scriptPaths["intel_oneapi_hpc_toolkit_installer"]}" \
               "${scriptPaths["intel_oneapi_hpc_toolkit_remover"]}" \
               "show_intel_oneapi_menu"
}

show_nvidia_cuda_menu(){
    options_menu "NVIDIA CUDA Toolkit" \
               "${scriptPaths["cuda_installer"]}" \
               "${scriptPaths["cuda_remover"]}" \
               "show_toolkits_menu"
}

# Begin Toolkits Menu
show_toolkits_menu
# End Toolkits Menu