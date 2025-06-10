#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_cuda_installation_folder(){
    log_message "INFO" "Assuming the CUDA Toolkit is Installed in the default path (/usr/local/)"
    printc "YELLOW" "-> Assuming the CUDA Toolkit is Installed in the default path (/usr/local/)..."

    local cuda_folder=$(ls /usr/local | grep "cuda-*")
    if [ -n "$cuda_folder" ]; then
        log_message "INFO" "Found CUDA Installation(s): $cuda_folder"
        printc "GREEN" "-> Found Installation(s):"
        echo $cuda_folder

        log_message "INFO" "Removing CUDA Installation(s)"
        printc "YELLOW" "-> Removing CUDA Installation(s)..."
        for folder in $cuda_folder; do
            if [ -d "/usr/local/$folder" ]; then
                sudo rm -rf "/usr/local/$folder" || handle_error "Failed to Remove CUDA Installation: $folder"
                log_message "INFO" "Removed CUDA Installation: $folder"
            fi
        done

    else
        log_message "WARN" "No CUDA Installation Found in /usr/local/"
        printc "YELLOW" "-> No CUDA Installation Found in /usr/local/"
    fi
}

remove_cuda_path(){

    log_message "INFO" "Checking for CUDA Path in .bashrc..."
    printc "YELLOW" "-> Checking for CUDA Path in .bashrc..."
    if grep '/usr/local/cuda' ~/.bashrc; then
        log_message "INFO" "CUDA is declared in PATH (bash)"
        printc "GREEN" "CUDA is declared in PATH (bash)"

        log_message "INFO" "Removing CUDA from PATH (bash)"
        printc "YELLOW" "-> Removing CUDA from PATH (bash)..."
        sed -i '/usr\/local\/cuda/d' ~/.bashrc
    else
        log_message "INFO" "CUDA is not declared in PATH (bash)"
        printc "YELLOW" "-> CUDA is not declared in PATH (bash)"
    fi

}

# Begin NVIDIA CUDA ToolKit Removal
echo "Continue script execution in NVIDIA CUDA ToolKit Removal at $(date)" >> "$LOG_FILE"
remove_cuda_installation_folder
remove_cuda_path
echo "NVIDIA CUDA ToolKit Removal Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
print_msgbox "Success" "NVIDIA CUDA ToolKit has been removed successfully !"
# End NVIDIA CUDA ToolKit Removal