#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Tensorflow Installation at $(date)" >> "$LOG_FILE"

installTensorFlow(){
	while true; do
	
		echo "What Compute Platform do you want to use ?"
		echo "1. CPU"
		echo "2. CUDA"
		echo -n "Your Compute Platform : "
		read option
		case $option in
		1)
		    log_message "INFO" "User chose to Installing Tensorflow with CPU Support"
		    echo "-> Installing Tensorflow with CPU Support"
		    sleep 1
		    python3 -m pip install tensorflow || handle_error "Failed to Install Tensorflow with CPU Support"
		    
		    echo -n "-> Do you want to check if tensorflow is installed ? (Y/n) : "
		    read r
		    if [[ "$r" == "Y" || "$r" == "y" || "$r" == "" ]]; then
		    	log_message "INFO" "User chose to check if tensorflow is installed" 
			echo "-> Executing python -c 'import tensorflow as tf; print(tf.random.normal([5, 5]))' "
			echo "-> If returned a result, then tensorflow is installed"
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
	   	    echo "# 1. NVIDIA Driver Installed on your Machine"
	   	    echo "# 2. NVIDIA CUDA Toolkit Installed on your Machine"
	   	    echo "Press [ENTER] to continue..."
	   	    read
	   	    
		    log_message "INFO" "User chose to Installing Tensorflow with CUDA Support"
		    log_message "INFO" "Installing cuDNN Package"
		    echo "-> Installing cuDNN Package"
		    sleep 1
		    conda install -c conda-forge cudnn || handle_error "Failed to Install cuDNN Package"
		    
		    echo "-> Installing Tensorflow with CUDA Support"
		    sleep 1
		    python3 -m pip install tensorflow[and-cuda] || handle_error "Failed to Install Tensorflow with CUDA Support"
		    
		    echo -n "-> Do you want to check if tensorflow with cuda is installed ? (Y/n) : "
		    read r
		    if [[ "$r" == "Y" || "$r" == "y" || "$r" == "" ]]; then
			echo "-> Executing python -c 'import tensorflow as tf; print(tf.test.is_built_with_cuda())' "
			echo "-> If Returned True, then Tensorflow is installed with CUDA Support"
			echo "Press [ENTER] to continue..."
			read
			sleep 1
			python -c "import tensorflow as tf; print(tf.test.is_built_with_cuda())"
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

echo "# Before Proceeding to the installation of PyTorch"
echo "# Make sure that : "
echo "# 1. Conda is Installed on your machine"
echo "# 2. The base conda environment of current shell session is (base)"
echo "PRESS [ENTER] to Continue..."
read

log_message "INFO" "Creating The working Environment"
echo "-> Creating The working Environment..."
sleep 1
echo -n "Type your environment Name : "
read env_name
conda create --name $env_name python=3.10 || handle_error "Failed to create $env_name environment"

log_message "INFO" "Activating The Working Environment : $env_name"
echo "-> Activating The Working Environment : $env_name..."
sleep 1
source activate base || handle_error "Failed to Activate $env_name Environment"
conda activate $env_name || handle_error "Failed to Activate $env_name Environment"

log_message "INFO" "Configuring System Paths for CONDA Environment"
echo "-> Configuring System Paths for CONDA Environment"
sleep 1
mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"

log_message "INFO" "Installing Tensorflow"
installTensorFlow

echo "Tensorflow Installation Completed Successfully at $(date)" >> "$LOG_FILE"
echo "To activate this environment, Open terminal and Type the following :"
echo "conda activate $env_name"
echo "PRESS [ENTER] to exit..."
read
