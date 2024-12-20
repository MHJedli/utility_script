#!/usr/bin/env bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pytorch Installation at $(date)" >> "$LOG_FILE"

testCuda(){

    log_message "INFO" "Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.cuda.get_device_name(0))'..."
    sleep 1
	python3 -c 'import torch; print(torch.cuda.get_device_name(0))' || handle_error "Failed to Check if Pytorch with CUDA Support is working"
    log_message "INFO" "Pytorch with CUDA Support is Installed"
    printc "GREEN" "-> Pytorch with CUDA Support is Installed..."
    sleep 1

}

dryRunCheck(){

	log_message "INFO" "Performing Dry Run for Pytorch Installation"
    printc "CYAN" "-> Performing Dry Run for Pytorch Installation..."
	sleep 1

	log_message "INFO" "1. Checking for Conda Installation"
    printc "YELLOW" "1. Checking for Conda Installation..."
	sleep 1
    if ! command -v conda &> /dev/null; then
        log_message "WARN" "Conda Not Found, Install ?"
        if whiptail --title "Conda NOT FOUND !" --yesno "Do you want to install Conda now ?" 8 78; then
            log_message "INFO" "Proceeding the Installation of Conda"
            printc "CYAN" "Proceeding the Installation of Conda..."
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
	local condaEnv=$CONDA_DEFAULT_ENV
	if [[ "$condaEnv" == "base" ]]; then
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
                    log_message "INFO" "Proceeding the Installation of NVIDIA"
                    printc "CYAN" "Proceeding the Installation of NVIDIA..."
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
                    log_message "INFO" "Proceeding the Installation of NVIDIA CUDA Toolkit"
                    printc "CYAN" "Proceeding the Installation of NVIDIA CUDA Toolkit..."
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

installPytorch(){
    log_message "INFO" "Displaying Compute Platform Options Menu"
    local COMPUTE_OPTION=$(whiptail --title "Pytorch Installer Script" --menu "Choose The Compute Platform" 10 80 2 \
    "CPU" "" \
    "CUDA" "[REQUIRES NVIDIA GPU]" \
    3>&1 1>&2 2>&3)

    case $COMPUTE_OPTION in
        "CPU")
            log_message "INFO" "User chose to Install PyTorch with CPU Support"
            printc "YELLOW" "-> Installing PyTorch with CPU Support..."
            sleep 1
            conda install pytorch torchvision torchaudio cpuonly -c pytorch || handle_error "Failed to Install PyTorch with CPU Support"
            printc "GREEN" "-> Pytorch with CPU Support installed Successfully"
            ;;
        "CUDA")
            log_message "INFO" "Displaying CUDA Version Options Menu"
            local CUDA_VERSIONS=$(whiptail --title "CUDA Selection" --menu "Choose the Compute Platform CUDA version" 15 80 4 \
            "11.8" "" \
            "12.1" "" \
            "12.4" "" \
            "<-- Back" "" \
            3>&1 1>&2 2>&3)

            case $CUDA_VERSIONS in
                "11.8")
                    log_message "INFO" "Installing Pytorch with CUDA 11.8 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 11.8 Support..."
                    sleep 1
                    conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia || handle_error "Failed to Installing PyTorch with CUDA 11.8 Support"
                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    testCuda
                    ;;
                "12.1")
                    log_message "INFO" "Installing Pytorch with CUDA 12.1 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 12.1 Support..."
                    sleep 1
                    conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia || handle_error "Failed to Installing PyTorch with CUDA 12.1 Support"
                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    testCuda
                    ;;
                "12.4")
                    log_message "INFO" "Installing Pytorch with CUDA 12.4 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 12.4 Support..."
                    sleep 1
                    conda install pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia || handle_error "Failed to Installing PyTorch with CUDA 12.4 Support"
                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    testCuda
                    ;;
                "<-- Back")
                    log_message "INFO" "Returning to Compute Platform Options Menu"
                    installPytorch
                    ;;
                *)
                    handle_error "User chose to Exit Script"
                    ;;
            esac
            ;;
        *)
            handle_error "User chose to Exit Script"
            ;;
    esac
    
}

createEnvironment(){
    log_message "INFO" "Displaying the Environment Options Menu"
    local OPTIONS=$(whiptail --title "Creating Environment" --menu "Choose an option" 10 80 2 \
    "Create a new Environment" "" \
    "Choose an existing Environment" "" \
    3>&1 1>&2 2>&3)

    case $OPTIONS in
        "Create a new Environment")
            log_message "INFO" "User chose to Create a new environment"
            local NEW_ENV=$(whiptail --inputbox "Type Your Environment Name" 8 39 --title "Create a new Environment" 3>&1 1>&2 2>&3)
            local EXIT_STATUS=$?
            if [ $EXIT_STATUS = 0 ]; then

                log_message "INFO" "Checking for NULL Value String from the InputBox"
				if [[ -z $NEW_ENV ]]; then
                    log_message "WARN" "NULL Value String Detected from the InputBox"
					whiptail --title "WARNING" --msgbox \
					"      You Typed an Empty Name " \ 10 40
                    log_message "INFO" "Returning to the Environment Options Menu"
					createEnvironment
				fi
                log_message "INFO" "NON-NULL Value String Detected, Continuing..."
                log_message "INFO" "Creating ${NEW_ENV} Environment"
                conda create --name $NEW_ENV || handle_error "Failed to create ${NEW_ENV} environment"

                log_message "INFO" "Activating The Working Environment : ${NEW_ENV}"
                printc "YELLOW" "-> Activating The Working Environment : ${NEW_ENV}..."
                sleep 1
                source activate base || handle_error "Failed to Activate ${NEW_ENV} Environment"
                conda activate $NEW_ENV || handle_error "Failed to Activate ${NEW_ENV} Environment"

                echo "To Activate This Environment , Execute the Following :"
                printc "GREEN" "conda activate ${NEW_ENV}"
                echo -n "Press [ENTER] To Continue Installation..."
                read
            fi
            ;;

        "Choose an existing Environment")
            log_message "User chose to use an existing environment"
            local YOUR_ENV=$(whiptail --inputbox "Type Your Environment Name" 8 39 --title "Create a new Environment" 3>&1 1>&2 2>&3)
            local EXIT_STATUS=$?
            if [ $EXIT_STATUS = 0 ]; then
                log_message "INFO" "Checking for NULL Value String from the InputBox"
				if [[ -z $YOUR_ENV ]]; then
                    log_message "WARN" "NULL Value String Detected from the InputBox"
					whiptail --title "WARNING" --msgbox \
					"      You Typed an Empty Name " \ 10 40
                    log_message "INFO" "Returning to the Environment Options Menu"
					createEnvironment
				fi
                log_message "INFO" "NON-NULL Value String Detected, Continuing..."
                log_message "INFO" "Checking The Existence of ${YOUR_ENV}"
                printc "YELLOW" "-> Checking The Existence of ${YOUR_ENV}..."
                sleep 1
                if conda info --envs | grep -q $YOUR_ENV; then
                    log_message "INFO" "${YOUR_ENV} Exists"
                    printc "GREEN" "${YOUR_ENV} Exists..."
                    sleep 1

                    log_message "INFO" "Activating The Working Environment : ${YOUR_ENV}"
                    printc "YELLOW" "-> Activating The Working Environment : ${YOUR_ENV}..."
                    sleep 1
                    source activate base || handle_error "Failed to Activate ${YOUR_ENV} Environment"
                    conda activate $YOUR_ENV || handle_error "Failed to Activate ${YOUR_ENV} Environment"

                    echo "To Activate This Environment , Execute the Following :"
                    printc "GREEN" "conda activate ${YOUR_ENV}"
                    echo -n "Press [ENTER] To Continue Installation..."
                    read

                else
                    log_message "WARN" "${YOUR_ENV} Does NOT Exists"
                    printc "RED" "${YOUR_ENV} Does NOT Exists !"
                    echo -n "Press [ENTER] To Try Again..."
                    read
                    createEnvironment
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

dryRunCheck

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Pytorch Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pytorch Installation..."
    sleep 1

    createEnvironment

    log_message "INFO" "Installing Pytorch"
    printc "YELLOW" "-> Installing Pytorch..."
    sleep 1
    installPytorch

    log_message "INFO" "Verifying the Pytorch installed Version"
    printc "YELLOW" "-> Verifying the installed Pytorch Version..."
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.__version__)'"
    sleep 1
    python3 -c 'import torch; print(torch.__version__)' || handle_error "Failed to Print Pytorch version"
    echo "Pytorch Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Pytorch Script Execution Completed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi

