#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$SCRIPTS_PATH"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

dry_run_check(){

	log_message "INFO" "Performing Dry Run for Jupyter Installation"
    printc "CYAN" "-> Performing Dry Run for Jupyter Installation..."
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

    log_message "INFO" "Dry Run Complete"
    echo -e "${GREEN}Dry Run Complete${RESET}. If no errors are reported, you can proceed with the installation."
	echo "Press [ENTER] to Install..."
	read
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

install_jupyter(){

    log_message "INFO" "Installing Pip"
    printc "YELLOW" "-> Installing Pip..."
    conda install pip || handle_error "Failed to install Pip"

    log_message "INFO" "Installing Jupyter"
    printc "YELLOW" "-> Installing Jupyter..."
    pip install jupyter || handle_error "Failed to install Jupyter"

}

# Begin Jupyter Installer
echo "Continue script execution in Jupyter Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Displaying Jupyter Installation Requirements"
whiptail --msgbox \
"
Before Proceeding to the installation of Jupyter, make sure that :
1. Conda is Installed on your machine
2. The base conda environment of current shell session is (base) 
" \ 10 80

dry_run_check

log_message "INFO" "Installing for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Jupyter Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Jupyter Installation..."

    create_environment

    log_message "INFO" "Installing Jupyter"
    printc "YELLOW" "-> Installing Jupyter..."
    install_jupyter

    echo "Jupyter Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "NOTE" "To run Jupyter Notebook, execute :
                         jupyter notebook"
    print_msgbox "Success !" "Jupyter Script Execution Completed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Jupyter Installer