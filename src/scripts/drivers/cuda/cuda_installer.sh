#!/usr/bin/env bash -i

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

download_and_install(){

    local cuda_version=$1
    local download_link=$2
    local download_path="$(pwd)/tmp"

    log_message "INFO" "Downloading NVIDIA CUDA Toolkit Version ${cuda_version}"
    printc "YELLOW" "-> Downloading NVIDIA CUDA ToolKit Version ${cuda_version}"
    wget -c -P "$download_path/" "$download_link"
    
    log_message "INFO" "Installing NVIDIA CUDA ToolKit in Silent Mode"
    printc "YELLOW" "-> Installing NVIDIA CUDA ToolKit in Silent Mode..."
    sudo sh "$download_path/cuda_${cuda_version}*.run" --silent --toolkit --toolkitpath=/usr/local/cuda-${cuda_version} || handle_error "Failed to Install NVIDIA CUDA Toolkit"

    log_message "INFO" "Removing Old CUDA Path"
    printc "YELLOW" "-> Removing Old CUDA Path"
    local oldCudaPath=$(cat ~/.bashrc | grep "export PATH=/usr/local/cuda*")
    sed -i "s|${oldCudaPath}||g" ~/.bashrc
    local oldCudaLDPath=$(cat ~/.bashrc | grep "export LD_LIBRARY_PATH=/usr/local/cuda*")
    local escapedOldCudaLDPath=$(printf '%s' "$oldCudaLDPath" | sed 's/[&/\]/\\&/g')
    sed -i "s/${escapedOldCudaLDPath}//g" ~/.bashrc

    log_message "INFO" "Exporting new CUDA Path"
    printc "YELLOW" "-> Exporting CUDA Path..."
    echo '# CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
    echo export PATH=/usr/local/cuda-${cuda_version}/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
    echo export LD_LIBRARY_PATH=/usr/local/cuda-${cuda_version}/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

    log_message "INFO" "Applying CUDA Path"
    printc "YELLOW" "-> Applying CUDA Path..."
    source ~/.bashrc || handle_error "Failed to Apply CUDA Path"

    log_message "INFO" "Checking the Installed Version"
    printc "YELLOW" "-> Checking the Installed Version..."
    nvcc --version || handle_error "Failed to check the Installed Version"

    echo "NVIDIA CUDA Toolkit Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "NVIDIA CUDA Toolkit Script Completed Successfully"

}

install_cuda(){

    log_message "INFO" "Displaying NVIDIA CUDA Toolkit Installer Options Menu"
    local cuda_options=$(whiptail --title "NVIDIA CUDA Toolkit Installer" --menu "Choose an option" 30 80 10 \
    "NVIDIA CUDA Toolkit Version 12.8.1" "" \
    "NVIDIA CUDA Toolkit Version 12.8.0" "" \
    "NVIDIA CUDA Toolkit Version 12.6.3" "" \
    "NVIDIA CUDA Toolkit Version 12.5.1" "" \
    "NVIDIA CUDA Toolkit Version 12.4.1" "" \
    "NVIDIA CUDA Toolkit Version 12.3.2" "" \
    "NVIDIA CUDA Toolkit Version 12.2.2" "" \
    "NVIDIA CUDA Toolkit Version 12.1.1" "" \
    "NVIDIA CUDA Toolkit Version 12.0.1" "" \
    "NVIDIA CUDA Toolkit Version 11.8.0" "" \
    "NVIDIA CUDA Toolkit Version 11.7.1" "" \
    "NVIDIA CUDA Toolkit Version 11.6.2" "" \
    3>&1 1>&2 2>&3)
    
    case $cuda_options in
        "NVIDIA CUDA Toolkit Version 12.8.1")
            download_and_install "12.8" "https://developer.download.nvidia.com/compute/cuda/12.8.1/local_installers/cuda_12.8.1_570.124.06_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.8.0")
            download_and_install "12.8" "https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_570.86.10_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.6.3")
            download_and_install "12.6" "https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda_12.6.3_560.35.05_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.5.1")
            download_and_install "12.5" "https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda_12.5.1_555.42.06_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.4.1")
            download_and_install "12.4" "https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.3.2")
            download_and_install "12.3" "https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda_12.3.2_545.23.08_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.2.2")
            download_and_install "12.2" "https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.1.1")
            download_and_install "12.1" "https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 12.0.1")
            download_and_install "12.0" "https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 11.8.0")
            download_and_install "11.8" "https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 11.7.1")
            download_and_install "11.7" "https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run"
            ;;
        "NVIDIA CUDA Toolkit Version 11.6.2")
            download_and_install "11.6" "https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda_11.6.2_510.47.03_linux.run"
            ;;
        *)
            handle_error "User chose to Exit Script"
            ;;
    esac
}

# Begin NVIDIA CUDA ToolKit Installation
echo "Continue script execution in NVIDIA CUDA ToolKit Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing NVIDIA CUDA Toolkit for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing NVIDIA CUDA Toolkit for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA CUDA ToolKit Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with NVIDIA CUDA ToolKit Installation..."

    log_message "INFO" "Installing NVIDIA CUDA ToolKit"
    printc "YELLOW" "-> Installing NVIDIA CUDA ToolKit..."
    install_cuda

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End NVIDIA CUDA ToolKit Installation