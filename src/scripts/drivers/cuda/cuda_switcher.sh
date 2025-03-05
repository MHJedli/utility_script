#!/usr/bin/env bash -i

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin CUDA Switcher
echo "Continue script execution in CUDA Switcher at $(date)" >> "$LOG_FILE"
log_message "INFO" "Printing CUDA Switcher Note"
print_msgbox "WARNING !" "This script is used ONLY when the CUDA Toolkit is installed using the runfile Method !"

log_message "INFO" "Printing Available CUDA Versions"
printc "YELLOW" "Assuming the CUDA Toolkit is Installed in the default path (/usr/local/)..."
printc "CYAN" "-> Available CUDA Version : (IGNORE the \"cuda\" option)"
ls /usr/local | grep "cuda-*" || handle_error "No Available CUDA Installation Found in /usr/local/ !"

echo -n "Choose from the available option : "
read VERSION
log_message "INFO" "User chose ${VERSION}"

log_message "INFO" "Removing old CUDA Path if existed"
printc "YELLOW" "-> Removing old CUDA Path if existed..."
grep -l '# CUDA PATH' ~/.bashrc | xargs -I {} sed -i '/# CUDA PATH/d' {}
grep -l '/usr/local/cuda' ~/.bashrc | xargs -I {} sed -i '/usr\/local\/cuda/d' {}

log_message "INFO" "Switching CUDA Version to ${VERSION}..."
printc "YELLOW" "-> Switching CUDA Version to ${VERSION}..."
echo '# CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export PATH=/usr/local/${VERSION}/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export LD_LIBRARY_PATH=/usr/local/${VERSION}/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

log_message "INFO" "Refreshing The Current Environment"
printc "YELLOW" "-> Refreshing The Current Environment..."
eval "$(cat ~/.bashrc | tail -n +10)" || handle_error "Failed to Apply CUDA Path"

log_message "INFO" "Checking the Switched Version"
printc "YELLOW" "-> Checking the Switched Version..."
if ! command -v nvcc &> /dev/null; then

    handle_error "Failed to check the Installed CUDA Version"

else

    log_message "INFO" "Printing CUDA Version"
    whiptail --title "nvcc --version" --msgbox "$(nvcc --version)" 15 100

    echo "CUDA Switcher Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "CUDA Version Switched Successfully to ${VERSION}"
    
fi
# End CUDA Switcher