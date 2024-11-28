#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in CUDA Switcher at $(date)" >> "$LOG_FILE"

printc "CYAN" "-> Available CUDA Version : (IGNORE CUDA)"
ls /usr/local | grep "cuda-*"

echo -n "Choose from the available option : "
read version

printc "YELLOW" "-> Switching to $version..."

local oldCudaPath=$(cat ~/.bashrc | grep "export PATH=/usr/local/cuda*")
sed -i "s|$oldCudaPath||g" ~/.bash
local oldCudaLDPath=$(cat ~/.bashrc | grep "export LD_LIBRARY_PATH=/usr/local/cuda*")
local escapedOldCudaLDPath=$(printf '%s' "$oldCudaLDPath" | sed 's/[&/\]/\\&/g')
sed -i "s/$escapedOldCudaLDPath//g" ~/.bashrc

echo '# CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export PATH=/usr/local/$version/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export LD_LIBRARY_PATH=/usr/local/$version/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

log_message "INFO" "Applying CUDA Path"
printc "YELLOW" "-> Applying CUDA Path..."
sleep 1
source ~/.bashrc || handle_error "Failed to Apply CUDA Path"
log_message "INFO" "Checking the Installed Version"
printc "YELLOW" "-> Checking the Installed Version..."
sleep 1
nvcc --version || handle_error "Failed to check the Installed Version"
read