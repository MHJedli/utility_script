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

    log_message "INFO" "Removing CUDA Installers"
    echo -e "${YELLOW}-> Removing CUDA Installers...${RESET}"
    sleep 1
    rm $(pwd)/cuda*.run >&/dev/null
    
    while true; do

        echo -e "${CYAN}What NVIDIA CUDA Toolkit version do you want to install ?${RESET}"
        echo "1. Show Versions"
        echo -n "Select Option : "
        read option

        if [[ "$option" == "1" ]]; then

            log_message "INFO" "Printing NVIDIA CUDA Version"
            for key in "${!cudaVersions[@]}"; do
                echo "NVIDIA CUDA Toolkit Version : $key"
            done
            echo -n "Press [ENTER] to continue..."
            read 

        elif [[ -v cudaVersions["$option"] ]]; then

            log_message "INFO" "Downloading NVIDIA CUDA Toolkit Version $option"
            echo -e "${YELLOW}-> Downloading NVIDIA CUDA ToolKit Version $option${RESET}"
            sleep 1
            eval "${cudaVersions["$option"]}"

            log_message "INFO" "Installing NVIDIA CUDA ToolKit in Silent Mode"
            echo -e "${YELLOW}-> Installing NVIDIA CUDA ToolKit in Silent Mode...${RESET}"
            sleep 1
            sudo sh cuda_$option_*.run --silent --toolkit --toolkitpath=/usr/local/cuda-$option || handle_error "Failed to Install NVIDIA CUDA Toolkit"

            log_message "INFO" "Removing Old CUDA Path"
            echo -e "${YELLOW}-> Removing Old CUDA Path${RESET}"
            sleep 1
            local oldCudaPath=$(cat ~/.bashrc | grep "export PATH=/usr/local/cuda*")
            sed -i "s|$oldCudaPath||g" ~/.bashrc

            local oldCudaLDPath=$(cat ~/.bashrc | grep "export LD_LIBRARY_PATH=/usr/local/cuda*")
            local escapedOldCudaLDPath=$(printf '%s' "$oldCudaLDPath" | sed 's/[&/\]/\\&/g')
            sed -i "s/$escapedOldCudaLDPath//g" ~/.bashrc

            log_message "INFO" "Exporting new CUDA Path"
            echo -e "${YELLOW}Exporting CUDA Path...${RESET}"
            sleep 1
            echo '# CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
            echo export PATH=/usr/local/cuda-$option/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
            echo export LD_LIBRARY_PATH=/usr/local/cuda-$option/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

            log_message "INFO" "Applying CUDA Path"
            echo -e "${YELLOW}-> Applying CUDA Path...${RESET}"
            sleep 1
            source ~/.bashrc || handle_error "Failed to Apply CUDA Path"

            log_message "INFO" "Checking the Installed Version"
            echo -e "${YELLOW}-> Checking the Installed Version...${RESET}"
            sleep 1
            nvcc --version || handle_error "Failed to check the Installed Version"

            echo "NVIDIA CUDA Toolkit Script Completed Successfully at $(date)" >> "$LOG_FILE"
            echo -e "${GREEN}-> NVIDIA CUDA Toolkit Script Completed Successfully${RESET}"
            echo "Press [ENTER] to exit..."
            read
            return

        else

            log_message "WARN" "User chose a wrong option : $option"
            invalidOption

        fi
    done
}

echo -e "${YELLOW}-> Checking for Internet Connection${RESET}"
sleep 1
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA CUDA ToolKit Installation"
    echo -e "${GREEN}Internet Connection Detected. Proceeding with NVIDIA CUDA ToolKit Installation${RESET}"
    sleep 1
    
    log_message "INFO" "Refreshing Package Cache"
    echo -e "${YELLOW}-> Refreshing Package Cache...${RESET}"
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System Packages"
    echo -e "${YELLOW}-> Updating System Packages...${RESET}"
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing NVIDIA CUDA ToolKit"
    echo -e "${YELLOW}-> Installing NVIDIA CUDA ToolKit...${RESET}"
    sleep 1
    installCUDA

else

    handle_error "No Internet Connection Available, Exiting..."

fi