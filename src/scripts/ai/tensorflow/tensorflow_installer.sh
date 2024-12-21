#!/usr/bin/env bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Tensorflow Installation at $(date)" >> "$LOG_FILE"

dry_run_check(){
	log_message "INFO" "Performing Dry Run for Tensorflow Installation"
    printc "CYAN" "-> Performing Dry Run for Tensorflow Installation..."
	sleep 1

	log_message "INFO" "1. Checking for Conda Installation"
    printc "YELLOW" "1. Checking for Conda Installation..."
	sleep 1
    if ! command -v conda &> /dev/null; then
        log_message "WARN" "Conda Not Found, Install ?"
        if whiptail --title "Conda NOT FOUND !" --yesno "Do you want to install Conda now ?" 8 78; then
			log_message "INFO" "Proceeding with the Installation of Conda"
            printc "CYAN" "Proceeding with the Installation of Conda..."
            bash "${scriptPaths["conda_installer"]}"
            printc "YELLOW" "Press [ENTER] to Restart Your Shell Session..."
            read
            exec bash

        else
            log_message "ERROR" "User chose NOT to install Conda"
            printc "RED" "ERROR: Please install Conda before proceeding..."
            read
            exit
        fi
    fi
    log_message "INFO" "Conda is installed"
    printc "GREEN" "-> Conda is installed."

	log_message "INFO" "1.1. Checking for active CONDA environment"
    printc "YELLOW" "1.1. Checking for active CONDA environment..."
	sleep 1
	local conda_env=$CONDA_DEFAULT_ENV
	if [[ "$conda_env" == "base" ]]; then
        log_message "INFO" "base is the default conda env"
        printc "GREEN" "-> base is the default conda env in this current shell session"
	else
        log_message "WARN" "base is NOT the default conda env"
        printc "RED" "-> base is NOT the default conda env in this current shell session"
    fi

	log_message "INFO" "2. Checking for CUDA Toolkit and NVIDIA Drivers"
    printc "YELLOW" "2. Checking for CUDA Toolkit and NVIDIA Drivers..."
	sleep 1
    log_message "INFO" "Verify NVIDIA Driver and CUDA Presence ?"
    if whiptail --title "NVIDIA Driver and CUDA Check" --yesno "Do you plan to install Pytorch with CUDA Support? [REQUIRES NVIDIA GPU]" 8 78; then
            log_message "INFO" "2.1. Checking for NVIDIA Drivers"
            printc "YELLOW" "2.1. Checking for NVIDIA Drivers..."
            sleep 1
            if ! command -v nvidia-smi &> /dev/null; then

                log_message "WARN" "NVIDIA Driver NOT found, Install ?"
                if whiptail --title "NVIDIA Driver NOT FOUND !" --yesno "Do you Want to Install it ?" 8 78; then
					log_message "INFO" "Proceeding with the Installation of NVIDIA"
                    printc "CYAN" "Proceeding with the Installation of NVIDIA..."
                    bash "${scriptPaths["nvidia_driver_installer"]}"
                else
					log_message "WARN" "Skipping NVIDIA Driver Installation"
                    printc "RED" "Skipping NVIDIA Driver Installation..."
                fi

            else
				log_message "INFO" "NVIDIA Driver is installed"
                printc "GREEN" "-> NVIDIA Driver is installed."
            fi

			log_message "INFO" "2.2. Checking for CUDA Toolkit"
            printc "YELLOW" "2.2. Checking for CUDA Toolkit..."
            sleep 1
            if ! nvcc --version &> /dev/null; then
                log_message "WARN" "NVIDIA CUDA Toolkit NOT found. Install ?"
                if whiptail --title "CUDA Toolkit NOT FOUND !" --yesno "Do you Want to Install it ?" 8 78; then
					log_message "INFO" "Proceeding with the Installation of NVIDIA CUDA Toolkit"
                    printc "CYAN" "Proceeding with the Installation of NVIDIA CUDA Toolkit..."
                    bash "${scriptPaths["cuda_installer"]}"
                else
					log_message "WARN" "Skipping NVIDIA CUDA Toolkit Installation"
                    printc "RED" "Skipping NVIDIA CUDA Toolkit Installation..."
                fi

            else
				log_message "INFO" "CUDA Toolkit is installed"
                printc "GREEN" "-> CUDA Toolkit is installed."
            fi
    else
        log_message "INFO" "Skipping NVIDIA Driver and CUDA Check"
        printc "YELLOW" "-> Skipping NVIDIA Driver and CUDA Check..."
    fi

	log_message "INFO" "Dry Run Complete"
    echo -e "${GREEN}Dry Run Complete${RESET}. If no errors are reported, you can proceed with the installation."
	echo "Press [ENTER] to Install..."
	read
}

install_tensorflow(){
	log_message "INFO" "Displaying The Compute Platform Menu"
    local compute_options=$(whiptail --title "Pytorch Installer Script" --menu "Choose The Compute Platform" 10 80 2 \
    "CPU" "" \
    "CUDA" "[REQUIRES NVIDIA GPU]" \
    3>&1 1>&2 2>&3)

    case $compute_options in
        "CPU")
			log_message "INFO" "User chose to Installing Tensorflow with CPU Support"
			printc "YELLOW" "-> Installing Tensorflow with CPU Support..."
			sleep 1
			python3 -m pip install tensorflow || handle_error "Failed to Install Tensorflow with CPU Support"

			log_message "INFO" "Verifying TensorFlow Installation with CPU Support"
			whiptail --msgbox \
			"
			-> Verifying TensorFlow With CPU Support Installation
			-> By Executing python -c 'import tensorflow as tf; print(tf.random.normal([5, 5]))'
			-> If a result is returned, then tensorflow is installed 
			" \ 10 80
			python -c "import tensorflow as tf; print(tf.random.normal([5, 5]))" || handle_error "Failed to check if tensorflow is installed"
			echo -n "Press [ENTER] To Continue..."
			read
            ;;

        "CUDA")
			log_message "INFO" "User chose to Installing Tensorflow with CUDA Support"
			whiptail --msgbox \
			"
			For Tensorflow with CUDA Support to work, Make sure that you have :
			1. NVIDIA Driver Installed on your Machine
			2. NVIDIA CUDA Toolkit Installed on your Machine 
			" \ 10 80

			log_message "INFO" "Installing cuDNN Package"
			printc "YELLOW" "-> Installing cuDNN Package..."
			sleep 1
			conda install -c conda-forge cudnn || handle_error "Failed to Install cuDNN Package"

			log_message "INFO" "Installing Tensorflow with CUDA Support"
			printc "YELLOW" "-> Installing Tensorflow with CUDA Support..."
			sleep 1
			python3 -m pip install tensorflow[and-cuda] || handle_error "Failed to Install Tensorflow with CUDA Support"

			log_message "INFO" "Verifying TensorFlow Installation with CUDA Support"
			whiptail --msgbox \
			"
			Verifying TensorFlow Installation with CUDA Support,
			by Executing :
			-> python -c \"import tensorflow as tf; print(tf.test.is_built_with_cuda())\"
			If Returned True, then Tensorflow is installed with CUDA Support
			" \ 15 90
			python -c "import tensorflow as tf; print(tf.test.is_built_with_cuda())" || handle_error "Failed to check if Tensorflow with CUDA Support is installed"
			echo -n "Press [ENTER] to continue..."
			read
            ;;
        *)
            handle_error "User chose to Exit Script"
            ;;
    esac
}

create_environment(){
	log_message "INFO" "Displaying Creating Environment Menu"
    local options=$(whiptail --title "Creating Environment" --menu "Choose an option" 10 80 2 \
    "Create a new Environment" "" \
    "Choose an existing Environment" "" \
    3>&1 1>&2 2>&3)

    case $options in
        "Create a new Environment")
			log_message "INFO" "User chose to Create a new Environment"
            local new_env=$(whiptail --inputbox "Type Your Environment Name" 8 39 --title "Create a new Environment" 3>&1 1>&2 2>&3)
            local exit_status=$?
            if [ $exit_status = 0 ]; then
                log_message "INFO" "Checking for NULL Value String from the InputBox"
				if [[ -z $new_env ]]; then
                    log_message "WARN" "NULL Value String Detected from the InputBox"
					whiptail --title "WARNING" --msgbox \
					"      You Typed an Empty Name " \ 10 40
                    log_message "INFO" "Returning to the Environment Options Menu"
					create_environment
				fi
                log_message "INFO" "NON-NULL Value String Detected, Continuing..."
				log_message "INFO" "Creating Environment : ${new_env}"
				printc "YELLOW" "-> Creating Environment : ${new_env}..."
				sleep 1
				conda create --name $new_env python=3.10 || handle_error "Failed to create ${new_env} environment"

				log_message "INFO" "Activating The Working Environment : ${new_env}"
				printc "YELLOW" "-> Activating The Working Environment : ${new_env}..."
				sleep 1
				source activate base || handle_error "Failed to Activate ${new_env} Environment"
				conda activate $new_env || handle_error "Failed to Activate ${new_env} Environment"

				log_message "INFO" "Configuring System Paths for CONDA Environment"
				printc "YELLOW" "-> Configuring System Paths for CONDA Environment..."
				sleep 1
				mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
				echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"

				echo "To Activate This Environment , Execute the Following :"
				printc "GREEN" "conda activate ${new_env}"
				echo -n "Press [ENTER] To Continue Installation..."
				read

            fi
            ;;

        "Choose an existing Environment")
			log_message "INFO" "User chose an Existing Environment"
            local your_env=$(whiptail --inputbox "Type Your Environment Name" 8 39 --title "Create a new Environment" 3>&1 1>&2 2>&3)
            local exit_status=$?
            if [ $exit_status = 0 ]; then
                log_message "INFO" "Checking for NULL Value String from the InputBox"
				if [[ -z $your_env ]]; then
                    log_message "WARN" "NULL Value String Detected from the InputBox"
					whiptail --title "WARNING" --msgbox \
					"      You Typed an Empty Name " \ 10 40
                    log_message "INFO" "Returning to the Environment Options Menu"
					create_environment
				fi
                log_message "INFO" "NON-NULL Value String Detected, Continuing..."
				log_message "INFO" "Checking The Existence of ${your_env}"
                printc "YELLOW" "-> Checking The Existence of ${your_env}..."
                sleep 1
                if conda info --envs | grep -q $your_env; then

					log_message "INFO" "Environment ${your_env} Exists"
					printc "GREEN" "${your_env} Exists..."
					sleep 1

					log_message "INFO" "Activating The Working Environment : ${your_env}"
					printc "YELLOW" "-> Activating The Working Environment : ${your_env}..."
					sleep 1
					source activate base || handle_error "Failed to Activate ${your_env}Environment"
					conda activate $your_env || handle_error "Failed to Activate ${your_env} Environment"

					log_message "INFO" "Configuring System Paths for CONDA Environment"
					printc "YELLOW" "-> Configuring System Paths for CONDA Environment..."
					sleep 1
					mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
					echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"

					echo "To Activate This Environment , Execute the Following :"
					printc "GREEN" "conda activate ${your_env}"
					echo -n "Press [ENTER] To Continue Installation..."
					read

                else
				
					log_message "WARN" "${YOUR_ENV} Does NOT Exists"
					whiptail --title "WARNING" --msgbox \
					"${your_env} Does NOT Exists !" \ 10 60
                    create_environment

                fi

            fi
            ;;

        *)

            handle_error "User chose to Exit Script"
            ;;

    esac

}

whiptail --msgbox \
"
Before Proceeding to the installation of Pytorch, make sure that :
1. Conda is Installed on your machine
2. The base conda environment of current shell session is (base) 
" \ 10 80

dry_run_check

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Tensorflow Installation"
	printc "GREEN" "-> Internet Connection Detected. Proceeding with Tensorflow Installation..."
	sleep 1

	create_environment

	log_message "INFO" "Installing Tensorflow"
	install_tensorflow

	echo "Tensorflow Installation Completed Successfully at $(date)" >> "$LOG_FILE"
	print_msgbox "Success !" "Tensorflow Installation Completed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi