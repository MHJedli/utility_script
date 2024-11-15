#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pytorch Installation at $(date)" >> "$LOG_FILE"

testCuda(){

    log_message "INFO" "Checking if Pytorch with CUDA Support is working"
    echo -e "${YELLOW}-> Checking if Pytorch with CUDA Support is working${RESET}"
	echo -e "${YELLOW}-> By Executing python3 -c 'import torch; print(torch.cuda.get_device_name(0))'...${RESET}"
    sleep 1
	python3 -c 'import torch; print(torch.cuda.get_device_name(0))' || handle_error "Failed to Check if Pytorch with CUDA Support is working"

    echo -e "${GREEN}-> Pytorch with CUDA Support is Installed...${RESET}"
    sleep 1

}

dryRunCheck(){

	log_message "INFO" "Performing Dry Run for Pytorch Installation"
    echo -e "${CYAN}-> Performing Dry Run for Pytorch Installation...${RESET}"
	sleep 1

	log_message "INFO" "1. Checking for Conda Installation"
    echo -e "${YELLOW}1. Checking for Conda Installation...${RESET}"
	sleep 1
    if ! command -v conda &> /dev/null; then
        echo -e "${RED}ERROR: Conda is not installed. Please install Conda before proceeding...${RESET}"
		read
        exit
    fi
    echo -e "${GREEN}-> Conda is installed.${RESET}"

	log_message "INFO" "1.1. Checking for active CONDA environment"
	echo -e "${YELLOW}1.1. Checking for active CONDA environment...${RESET}"
	sleep 1
	local condaEnv=$CONDA_DEFAULT_ENV
	if [[ "$condaEnv" == "base" ]]; then
		echo -e "${GREEN}base is the default conda env in this current shell session${RESET}"
	else
		echo -e "${RED}base is NOT the default conda env in this current shell session${RESET}"
    fi

	log_message "INFO" "2. Checking for CUDA Toolkit and NVIDIA Drivers"
    echo -e "${YELLOW}2. Checking for CUDA Toolkit and NVIDIA Drivers...${RESET}"
	sleep 1
	while true; do
    	echo -n -e "-> Do you plan to install Pytorch with CUDA Support? ${RED}[REQUIRES NVIDIA GPU]${RESET} (Y/n): "
    	read use_cuda
    	if [[ "$use_cuda" == "Y" || "$use_cuda" == "y" || "$use_cuda" == "" ]]; then

			log_message "INFO" "2.1. Checking for NVIDIA Drivers"
			echo -e "${YELLOW}2.1. Checking for NVIDIA Drivers...${RESET}"
			sleep 1
    	    if ! command -v nvidia-smi &> /dev/null; then
    	        echo -e "${RED}ERROR: NVIDIA Driver is not installed.${RESET}"
    	    else
    	        echo -e "${GREEN}-> NVIDIA Driver is installed.${RESET}"
    	    fi

			log_message "INFO" "2.2. Checking for CUDA Toolkit"
			echo -e "${YELLOW}2.2. Checking for CUDA Toolkit...${RESET}"
    	    sleep 1
    	    if ! nvcc --version &> /dev/null; then
    	        echo -e "${RED}ERROR: CUDA Toolkit is not installed.${RESET}"
    	    else
    	        echo -e "${GREEN}-> CUDA Toolkit is installed.${RESET}"
    	    fi

			break
		
		elif [[ "$use_cuda" == "n" || "$use_cuda" == "N" ]]; then
			break
		else
			invalidOption
    	fi
	done    
    echo -e "${GREEN}Dry Run Complete${RESET}. If no errors are reported, you can proceed with the installation."
	echo "Press [ENTER] to Install..."
	read
}

installPytorch(){
    while true; do

        log_message "INFO" "Choosing the compute platform"
        echo -e "${CYAN}-> Choose Your Compute Platform :${RESET}"
        echo "1. CPU"
        echo -e "2. CUDA ${RED}[Requires NVIDIA GPU]${RESET}"
        echo -n "Your Option : "
        read option

        if [[ "$option" == "1" ]]; then

            log_message "INFO" "User chose to Install PyTorch with CPU Support"
            echo -e "${YELLOW}-> Installing PyTorch with CPU Support${RESET}"
            sleep 1
            conda install pytorch torchvision torchaudio cpuonly -c pytorch || handle_error "Failed to Install PyTorch with CPU Support"
            echo -e "${GREEN}-> Pytorch with CPU Support installed Successfully${RESET}"
            return

        elif [[ "$option" == "2" ]]; then
            
            declare -A cudaOptions=(
                ["12.4"]=1
                ["12.1"]=1
                ["11.8"]=1
            )

            log_message "INFO" "User chose to Install Pytorch with CUDA Support"
            echo -e "${YELLOW}NOTE : Make sure you have NVIDIA Driver and NVIDIA CUDA Toolkit Installed !${RESET}"
            echo -e "${CYAN}-> Choose the Compute Platform CUDA version :${RESET}"
            echo "CUDA 12.4"
            echo "CUDA 12.1"
            echo "CUDA 11.8"
            echo -n "Your CUDA Version To Install : "
            read co

            if [[ -v cudaOptions["$co"] ]]; then

                log_message "INFO" "User chose CUDA $co Support"
                echo -e "${YELLOW}-> Installing Pytorch with CUDA $co Support...${RESET}"
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
echo -e "${YELLOW}# 1. Conda is Installed on your machine${RESET}"
echo -e "${YELLOW}# 2. The base conda environment of current shell session is (base)${RESET}"
echo "PRESS [ENTER] to Continue..."
read

dryRunCheck

echo -e "${YELLOW}-> Checking for Internet Connection...${RESET}"
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Pytorch Installation"
    echo -e "${GREEN}-> Internet Connection Detected. Proceeding with Pytorch Installation...${RESET}"
    sleep 1

    log_message "INFO" "Creating The working Environment"
    echo -e "${YELLOW}-> Creating The working Environment...${RESET}"
    sleep 1
    echo -n "Type your environment Name : "
    read env_name
    conda create --name $env_name || handle_error "Failed to create $env_name environment"

    log_message "INFO" "Activating The Working Environment : $env_name"
    echo -e "${YELLOW}-> Activating The Working Environment : $env_name...${RESET}"
    sleep 1
    source activate base || handle_error "Failed to Activate $env_name Environment"
    conda activate $env_name || handle_error "Failed to Activate $env_name Environment"

    log_message "INFO" "Installing Pytorch"
    echo -e "${YELLOW}-> Installing Pytorch...${RESET}"
    sleep 1
    installPytorch

    log_message "INFO" "Verifying the Pytorch installed Version"
    echo -e "${YELLOW}-> Verifying the installed Pytorch Version... ${RESET}"
    echo -e "${YELLOW}-> By Executing python3 -c 'import torch; print(torch.__version__)'${RESET}"
    sleep 1
    python3 -c 'import torch; print(torch.__version__)' || handle_error "Failed to Print Pytorch version"

    echo "Pytorch Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    echo -e "${GREEN}Pytorch Script Execution Completed Successfully...${RESET}"
    echo "To activate this environment, Open terminal and Type the following :"
    echo -e "${GREEN}conda activate $env_name${RESET}"
    echo "PRESS [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

