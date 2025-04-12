#!/usr/bin/env bash -i

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

test_cuda(){

    log_message "INFO" "Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.cuda.get_device_name(0))'..."
	python3 -c 'import torch; print(torch.cuda.get_device_name(0))' || handle_error "Failed to Check if Pytorch with CUDA Support is working"

    log_message "INFO" "Pytorch with CUDA Support is Installed"
    printc "GREEN" "-> Pytorch with CUDA Support is Installed..."
    echo -n "Press [ENTER] to Continue..."
    read

}

dry_run_check(){

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
            exit 1

        fi
    fi

    log_message "INFO" "Conda is installed"
    printc "GREEN" "-> Conda is installed."
    sleep 1

	log_message "INFO" "1.1. Checking for active CONDA environment"
    printc "YELLOW" "1.1. Checking for active CONDA environment..."
    sleep 1
	local conda_env=$CONDA_DEFAULT_ENV
	if [[ "$conda_env" == "base" ]]; then

        log_message "INFO" "base is the default conda env"
        printc "GREEN" "-> base is the default conda env in this current shell session"
        sleep 1

	else

        log_message "WARN" "base is NOT the default conda env"
        printc "RED" "-> base is NOT the default conda env in this current shell session"
        sleep 1

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
                    sleep 1

                fi
            else

                log_message "INFO" "NVIDIA Driver is installed"
                printc "GREEN" "-> NVIDIA Driver is installed."
                sleep 1

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
                    sleep 1

                fi
            else

                log_message "INFO" "CUDA Toolkit is installed"
                printc "GREEN" "-> CUDA Toolkit is installed."
                sleep 1

            fi
    else

        log_message "INFO" "Skipping NVIDIA Driver and CUDA Check"
        printc "YELLOW" "-> Skipping NVIDIA Driver and CUDA Check..."
        sleep 1

    fi

    log_message "INFO" "Dry Run Complete"
    echo -e "${GREEN}Dry Run Complete${RESET}. If no errors are reported, you can proceed with the installation."
	echo "Press [ENTER] to Install..."
	read
}

install_pytorch(){

    log_message "INFO" "Displaying Compute Platform Options Menu"
    local compute_option=$(whiptail --title "Pytorch Installer Script" --menu "Choose The Compute Platform" 10 80 2 \
    "CPU" "" \
    "CUDA" "[REQUIRES NVIDIA GPU]" \
    3>&1 1>&2 2>&3)

    case $compute_option in
        "CPU")
            log_message "INFO" "User chose to Install PyTorch with CPU Support"
            printc "YELLOW" "-> Installing PyTorch with CPU Support..."
            pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu || handle_error "Failed to Install PyTorch with CPU Support"

            log_message "INFO" "Pytorch with CPU Support installed Successfully"
            printc "GREEN" "-> Pytorch with CPU Support installed Successfully"
            ;;
        "CUDA")
            log_message "INFO" "Displaying CUDA Version Options Menu"
            local cuda_versions=$(whiptail --title "CUDA Selection" --menu "Choose the Compute Platform CUDA version" 15 80 4 \
            "11.8" "" \
            "12.4" "" \
            "12.6" "" \
            "<-- Back" "" \
            3>&1 1>&2 2>&3)

            case $cuda_versions in
                "11.8")
                    log_message "INFO" "Installing Pytorch with CUDA 11.8 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 11.8 Support..."
                    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 || handle_error "Failed to Install PyTorch with CUDA 11.8 Support"

                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    test_cuda
                    ;;
                "12.4")
                    log_message "INFO" "Installing Pytorch with CUDA 12.4 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 12.4 Support..."
                    pip3 install torch torchvision torchaudio || handle_error "Failed to Install PyTorch with CUDA 12.4 Support"

                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    test_cuda
                    ;;
                "12.6")
                    log_message "INFO" "Installing Pytorch with CUDA 12.6 Support"
                    printc "YELLOW" "-> Installing Pytorch with CUDA 12.6 Support..."
                    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 || handle_error "Failed to Install PyTorch with CUDA 12.4 Support"

                    log_message "INFO" "Testing CUDA Support in Pytorch"
                    test_cuda
                    ;;
                "<-- Back")
                    log_message "INFO" "Returning to Compute Platform Options Menu"
                    install_pytorch
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

create_environment(){

    log_message "INFO" "Displaying the Environment Options Menu"
    local options=$(whiptail --title "Creating Environment" --menu "Choose an option" 10 80 2 \
    "Create a new Environment" "" \
    "Choose an existing Environment" "" \
    3>&1 1>&2 2>&3)

    case $options in
        "Create a new Environment")
            log_message "INFO" "User chose to Create a new environment"
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
                log_message "INFO" "Creating ${new_env} Environment"
                conda create --name $new_env || handle_error "Failed to create ${new_env} environment"

                log_message "INFO" "Activating The Working Environment : ${new_env}"
                printc "YELLOW" "-> Activating The Working Environment : ${new_env}..."
                source activate base || handle_error "Failed to Activate ${new_env} Environment"
                conda activate $new_env || handle_error "Failed to Activate ${new_env} Environment"

                log_message "INFO" "Environment ${new_env} Created and Activated Successfully"
                echo "To Activate This Environment , Execute the Following :"
                printc "GREEN" "conda activate ${new_env}"
                echo -n "Press [ENTER] To Continue Installation..."
                read
            fi
            ;;

        "Choose an existing Environment")
            log_message "User chose to use an existing environment"
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
                if conda info --envs | grep -q $your_env; then

                    log_message "INFO" "${your_env} Exists"
                    printc "GREEN" "${your_env} Exists..."

                    log_message "INFO" "Activating The Working Environment : ${your_env}"
                    printc "YELLOW" "-> Activating The Working Environment : ${your_env}..."
                    source activate base || handle_error "Failed to Activate ${your_env} Environment"
                    conda activate $your_env || handle_error "Failed to Activate ${your_env} Environment"

                    log_message "INFO" "Environment ${your_env} Activated Successfully"
                    echo "To Activate This Environment , Execute the Following :"
                    printc "GREEN" "conda activate ${your_env}"
                    echo -n "Press [ENTER] To Continue Installation..."
                    read

                else

                    log_message "WARN" "${your_env} Does NOT Exists"
                    printc "RED" "${your_env} Does NOT Exists !"
                    echo -n "Press [ENTER] To Try Again..."
                    read
                    create_environment

                fi
            fi
            ;;

        *)
            handle_error "User chose to Exit Script"
            ;;

    esac

}

# Begin Pytorch Installation
echo "Continue script execution in Pytorch Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Displaying Pytorch Installation Requirements"
whiptail --msgbox \
"
Before Proceeding to the installation of Pytorch, make sure that :
1. Conda is Installed on your machine
2. The base conda environment of current shell session is (base) 
" \ 10 80

dry_run_check

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Pytorch Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pytorch Installation..."

    log_message "INFO" "Activating conda-forge channel"
    printc "YELLOW" "-> Activating conda-forge channel..."
    conda config --add channels conda-forge || handle_error "Failed to add conda-forge channel"
    conda config --set channel_priority strict || handle_error "Failed to set channel priority to strict"

    create_environment

    log_message "INFO" "Installing pip"
    printc "YELLOW" "-> Installing pip..."
    conda install pip || handle_error "Failed to Install pip"

    log_message "INFO" "Installing Pytorch"
    printc "YELLOW" "-> Installing Pytorch..."
    install_pytorch

    log_message "INFO" "Verifying the Pytorch installed Version"
    printc "YELLOW" "-> Verifying the installed Pytorch Version..."
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.__version__)'"
    python3 -c 'import torch; print(torch.__version__)' || handle_error "Failed to Print Pytorch version"

    echo "Pytorch Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Pytorch Script Execution Completed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Pytorch Installation