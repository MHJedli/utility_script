#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log



trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Tensorflow Installation at $(date)" >> "$LOG_FILE"

dryRunCheck(){

	log_message "INFO" "Performing Dry Run for TensorFlow Installation"
    echo -e "${CYAN}-> Performing Dry Run for TensorFlow Installation...${RESET}"
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
    	echo -n "-> Do you plan to install TensorFlow with CUDA Support? (Y/n): "
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


installTensorFlow(){
	while true; do
	
		echo -e "${YELLOW}What Compute Platform do you want to use ?${RESET}"
		echo "1. CPU"
		echo "2. CUDA"
		echo -n "Your Compute Platform : "
		read option
		case $option in
		1)
		    log_message "INFO" "User chose to Installing Tensorflow with CPU Support"
		    echo -e"${YELLOW}-> Installing Tensorflow with CPU Support${RESET}"
		    sleep 1
		    python3 -m pip install tensorflow || handle_error "Failed to Install Tensorflow with CPU Support"
		    
		    echo -n -e "${CYAN}-> Do you want to check if tensorflow is installed ? (Y/n) :${RESET} "
		    read r
		    if [[ "$r" == "Y" || "$r" == "y" || "$r" == "" ]]; then

		    	log_message "INFO" "User chose to check if tensorflow is installed" 
				echo -e "${YELLOW}-> Executing python -c 'import tensorflow as tf; print(tf.random.normal([5, 5]))' ${RESET}"
				echo -e "-> If returned a result, then tensorflow is ${GREEN}installed${RESET}"
				echo "Press [ENTER] to continue..."
				read
				sleep 1
				python -c "import tensorflow as tf; print(tf.random.normal([5, 5]))" || handle_error "Failed to check if tensorflow is installed"
				
		    fi
		    return
		    ;;
		2)
		    echo "# For Tensorflow with CUDA Support to work,"
	   	    echo "# Make sure that you have : "
	   	    echo -e "${YELLOW}# 1. NVIDIA Driver Installed on your Machine${RESET}"
	   	    echo -e "${YELLOW}# 2. NVIDIA CUDA Toolkit Installed on your Machine${RESET}"
	   	    echo "Press [ENTER] to continue..."
	   	    read
	   	    
		    log_message "INFO" "User chose to Installing Tensorflow with CUDA Support"
		    log_message "INFO" "Installing cuDNN Package"
		    echo "${YELLOW}-> Installing cuDNN Package${RESET}"
		    sleep 1
		    conda install -c conda-forge cudnn || handle_error "Failed to Install cuDNN Package"
		    
		    echo -e "${YELLOW}-> Installing Tensorflow with CUDA Support${RESET}"
		    sleep 1
		    python3 -m pip install tensorflow[and-cuda] || handle_error "Failed to Install Tensorflow with CUDA Support"
		    
		    echo -n -e "${CYAN}-> Do you want to check if tensorflow with cuda is installed ? (Y/n) :${RESET} "
		    read r
		    if [[ "$r" == "Y" || "$r" == "y" || "$r" == "" ]]; then
			
				echo -e "${YELLOW}-> Executing python -c 'import tensorflow as tf; print(tf.test.is_built_with_cuda())' ${RESET}"
				echo -e "-> If Returned True, then Tensorflow is ${GREEN}installed with CUDA Support${RESET}"
				echo "Press [ENTER] to continue..."
				read
				sleep 1
				python -c "import tensorflow as tf; print(tf.test.is_built_with_cuda())" || handle_error "Failed to check if Tensorflow with CUDA Support is installed"
				read

		    fi
		    return
		    ;;
		*)
		    log_message "WARN" "User chose a wrong option : $r"
		    invalidOption
		    ;;
		esac
		
	done

}

echo "# Before Proceeding to the installation of Tensorflow"
echo "# Make sure that : "
echo -e "${YELLOW}#1. Conda is Installed on your machine${RESET}"
echo -e "${YELLOW}#2. The base conda environment of current shell session is (base)${RESET}"
echo "PRESS [ENTER] to Continue..."
read

dryRunCheck

echo -e "${YELLOW}-> Checking for Internet Connection...${RESET}"
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Tensorflow Installation"
	echo -e "${GREEN}-> Internet Connection Detected. Proceeding with Tensorflow Installation...${RESET}"
	sleep 1

	log_message "INFO" "Creating The working Environment"
	echo -e "${YELLOW}-> Creating The working Environment...${RESET}"
	sleep 1
	echo -n "Type your environment Name : "
	read env_name
	conda create --name $env_name python=3.10 || handle_error "Failed to create $env_name environment"

	log_message "INFO" "Activating The Working Environment : $env_name"
	echo -e "${YELLOW}-> Activating The Working Environment : $env_name...${RESET}"
	sleep 1
	source activate base || handle_error "Failed to Activate $env_name Environment"
	conda activate $env_name || handle_error "Failed to Activate $env_name Environment"

	log_message "INFO" "Configuring System Paths for CONDA Environment"
	echo -e "${YELLOW}-> Configuring System Paths for CONDA Environment${RESET}"
	sleep 1
	mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
	echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"

	log_message "INFO" "Installing Tensorflow"
	installTensorFlow

	echo "Tensorflow Installation Completed Successfully at $(date)" >> "$LOG_FILE"
	echo -e "${GREEN}Tensorflow Installation Completed Successfully...${RESET}"
	echo "To activate this environment, Open terminal and Type the following :"
	echo -e "${GREEN}conda activate $env_name${RESET}"
	echo "PRESS [ENTER] to exit..."
	read

else

    handle_error "No Internet Connection Available, Exiting..."

fi
