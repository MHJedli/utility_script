#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pytorch Installation at $(date)" >> "$LOG_FILE"

testCuda(){

    log_message "INFO" "Checking if Pytorch with CUDA Support is working"
    echo "-> Checking if Pytorch with CUDA Support is working"
	echo "-> By Executing python3 -c 'import torch; print(torch.cuda.get_device_name(0))'..."
    sleep 1
	python3 -c 'import torch; print(torch.cuda.get_device_name(0))' || handle_error "Failed to Check if Pytorch with CUDA Support is working"

    echo "-> Pytorch with CUDA Support is Installed..."
    sleep 1

}
installPytorch(){
    while true; do

        log_message "INFO" "Choosing the compute platform"
        echo "-> Choose Your Compute Platform :"
        echo "1. CPU"
        echo "2. CUDA (Requires NVIDIA GPU)"
        echo -n "Your Option : "
        read option

        if [[ "$option" == "1" ]]; then

            log_message "INFO" "User chose to Install PyTorch with CPU Support"
            echo "-> Installing PyTorch with CPU Support"
            sleep 1
            conda install pytorch torchvision torchaudio cpuonly -c pytorch || handle_error "Failed to Install PyTorch with CPU Support"
            echo "-> Pytorch with CPU Support installed Successfully"
            return

        elif [[ "$option" == "2" ]]; then
            
            declare -A cudaOptions=(
                ["12.4"]=1
                ["12.1"]=1
                ["11.8"]=1
            )

            log_message "INFO" "User chose to Install Pytorch with CUDA Support"
            echo "NOTE : Make sure you have NVIDIA Driver and NVIDIA CUDA Toolkit Installed !"
            echo "-> Choose the Compute Platform CUDA version :"
            echo "CUDA 12.4"
            echo "CUDA 12.1"
            echo "CUDA 11.8"
            echo -n "Your CUDA Version To Install : "
            read co

            if [[ -v cudaOptions["$co"] ]]; then

                log_message "INFO" "User chose CUDA $co Support"
                echo "-> Installing Pytorch with CUDA $co Support..."
                sleep 1
                conda install pytorch torchvision torchaudio pytorch-cuda=$co -c pytorch -c nvidia || handle_error "Failed to Installing PyTorch with CUDA $co Support"
                log_message "INFO" "Testing CUDA Support in Pytorch"
                testCuda
                return

            else

                log_message "WARN" "User chose a wrong option : $co"
                invalidOption

            fi

        else
            invalidOption
        fi

    done
    
}

echo "# Before Proceeding to the installation of Pytorch"
echo "# Make sure that : "
echo "# 1. Conda is Installed on your machine"
echo "# 2. The base conda environment of current shell session is (base)"
echo "PRESS [ENTER] to Continue..."
read

echo "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Pytorch Installation"
    echo "-> Internet Connection Detected. Proceeding with Pytorch Installation..."
    sleep 1

    log_message "INFO" "Creating The working Environment"
    echo "-> Creating The working Environment..."
    sleep 1
    echo -n "Type your environment Name : "
    read env_name
    conda create --name $env_name || handle_error "Failed to create $env_name environment"

    log_message "INFO" "Activating The Working Environment : $env_name"
    echo "-> Activating The Working Environment : $env_name..."
    sleep 1
    source activate base || handle_error "Failed to Activate $env_name Environment"
    conda activate $env_name || handle_error "Failed to Activate $env_name Environment"

    log_message "INFO" "Installing Pytorch"
    echo "-> Installing Pytorch..."
    sleep 1
    installPytorch

    log_message "INFO" "Verifying the Pytorch installed Version"
    echo "-> Verifying the installed Pytorch Version... "
    echo "-> By Executing python3 -c 'import torch; print(torch.__version__)'"
    sleep 1
    python3 -c 'import torch; print(torch.__version__)' || handle_error "Failed to Print Pytorch version"

    echo "Pytorch Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    echo "To activate this environment, Open terminal and Type the following :"
    echo "conda activate $env_name"
    echo "PRESS [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

