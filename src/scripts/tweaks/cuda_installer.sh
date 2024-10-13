#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in NVIDIA CUDA ToolKit Installation at $(date)" >> "$LOG_FILE"

installCUDA(){

    declare -A cudaVersions=(
        ["12.6.2"]="wget https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda_12.6.2_560.35.03_linux.run"
        ["12.5.1"]="wget https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda_12.5.1_555.42.06_linux.run"
        ["12.4.1"]="wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run"
        ["12.3.2"]="wget https://developer.download.nvidia.com/compute/cuda/12.3.2/local_installers/cuda_12.3.2_545.23.08_linux.run"
        ["12.2.2"]="wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.run"
        ["12.1.1"]="wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda_12.1.1_530.30.02_linux.run"
        ["12.0.1"]="wget https://developer.download.nvidia.com/compute/cuda/12.0.1/local_installers/cuda_12.0.1_525.85.12_linux.run"
        ["11.8.0"]="wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run"
        ["11.7.1"]="wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run"
        ["11.6.2"]="wget https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda_11.6.2_510.47.03_linux.run"
    )

    while true; do

        echo "What NVIDIA CUDA Toolkit version do you want to install ?"
        echo "1. Show Versions"
        echo -n "Select Option : "
        read option

        if [[ "$option" == "1" ]]; then

            log_message "INFO" "Printing NVIDIA CUDA Version"
            for key in "${!cudaVersions[@]}"; do
                echo "$key"
            done
            echo -n "Press [ENTER] to continue..."
            read

        elif [[ -v cudaVersions["$option"] ]]; then

            log_message "INFO" "Downloading NVIDIA CUDA Toolkit Version $option"
            echo "-> Downloading NVIDIA CUDA ToolKit Version $option"
            sleep 1
            eval "${cudaVersions["$option"]}"

            log_message "INFO" "Installing NVIDIA CUDA ToolKit in Silent Mode"
            echo "-> Installing NVIDIA CUDA ToolKit in Silent Mode..."
            sleep 1
            sudo sh cuda_$option_*.run --silent --toolkit --toolkitpath=/usr/local/cuda-$option

            log_message "INFO" "Exporting CUDA Path"
            echo "Exporting CUDA Path..."
            sleep 1
            echo 'CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
            echo export PATH=/usr/local/cuda-$option/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
            echo export LD_LIBRARY_PATH=/usr/local/cuda-$option/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

            log_message "INFO" "Applying CUDA Path"
            echo "-> Applying CUDA Path..."
            sleep 1
            source ~/.bashrc || handle_error "Failed to Apply CUDA Path"

            log_message "INFO" "Checking the Installed Version"
            echo "-> Checking the Installed Version..."
            sleep 1
            nvcc --version || handle_error "Failed to check the Installed Version"

            echo "NVIDIA CUDA Toolkit Script Completed Successfully at $(date)" >> "$LOG_FILE"
            echo "-> NVIDIA CUDA Toolkit Script Completed Successfully"
            echo "Press [ENTER] to exit flutter installer..."
            read
            return

        else

            log_message "WARN" "User chose a wrong option : $option"
            invalidOption

        fi
    done
}

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA CUDA ToolKit Installation"

    log_message "INFO" "Refreshing Package Cache"
    echo "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System Packages"
    echo "-> Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing NVIDIA CUDA ToolKit"
    echo "-> Installing NVIDIA CUDA ToolKit..."
    sleep 1
    installCUDA

else

    handle_error "No Internet Connection Available, Exiting..."

fi