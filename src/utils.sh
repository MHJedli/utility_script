#!/usr/bin/env bash

# Define Working Directory Path : 
WORK_DIR=$(pwd)

# Define Distribution Variables : 
DISTRIBUTION=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
DISTRIBUTION_NAME=$(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
UBUNTU_BASE=$(grep ^ID_LIKE= /etc/os-release | cut -d= -f2 | tr -d '"' | grep "ubuntu")
FEDORA_BASE=$(grep ^ID_LIKE= /etc/os-release | cut -d= -f2 | tr -d '"' | grep "fedora")


# Define Color Variables :
# Usage : 
# echo -e "${<COLOR_TO_USE>}<MESSAGE TO PRINT>${RESET}"
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
RESET='\e[0m'

printc(){
    
    case $1 in
    	"RED")
    		color=$RED
    		;;
    	"GREEN")
    		color=$GREEN
    		;;
    	"YELLOW")
    		color=$YELLOW
    		;;
    	"CYAN")
    		color=$CYAN
    		;;
    esac

    echo -e "${color}$2${RESET}"
}

# Function that prints a message box
print_msgbox(){
    local title=$1
    local msg=$2
    whiptail --title "$title" --msgbox \
    "$msg" \ 10 80
}


# Script Paths
declare -A scriptPaths=(

    # Dev Scripts
    ["angular_installer"]="${WORK_DIR}/src/scripts/dev/angular/angular_installer.sh"

    ["android_studio_installer"]="${WORK_DIR}/src/scripts/dev/android_studio/android_studio_installer.sh"

    ["flutter_installer"]="${WORK_DIR}/src/scripts/dev/flutter/flutter_installer.sh"

    ["oracle_vm_installer"]="${WORK_DIR}/src/scripts/dev/oracle_vm/oracle_vm_installer.sh"

    ["docker_installer"]="${WORK_DIR}/src/scripts/dev/docker/docker_installer.sh"
    ["docker_remover"]="${WORK_DIR}/src/scripts/dev/docker/docker_remover.sh"

    # Drivers Scripts
    ["nvidia_driver_installer"]="${WORK_DIR}/src/scripts/drivers/nvidia/nvidia_driver_installer.sh"
    ["nvidia_driver_remover"]="${WORK_DIR}/src/scripts/drivers/nvidia/nvidia_driver_remover.sh"

    ["cuda_installer"]="${WORK_DIR}/src/scripts/drivers/cuda/cuda_installer.sh"
    ["cuda_switcher"]="${WORK_DIR}/src/scripts/drivers/cuda/cuda_switcher.sh"
    
    # AI Scripts
    ["conda_installer"]="${WORK_DIR}/src/scripts/ai/conda/conda_installer.sh"
    ["conda_remover"]="${WORK_DIR}/src/scripts/ai/conda/conda_remover.sh"

    ["pytorch_installer"]="${WORK_DIR}/src/scripts/ai/pytorch/pytorch_installer.sh"

    ["tensorflow_installer"]="${WORK_DIR}/src/scripts/ai/tensorflow/tensorflow_installer.sh"

    # Tweaks Scripts
    ["pipewire_installer"]="${WORK_DIR}/src/scripts/tweaks/pipewire/pipewire_installer.sh"

    ["keyboard_rgb_fix_installer"]="${WORK_DIR}/src/scripts/tweaks/keyboard_rgb_fix/keyboard_rgb_fix_installer.sh"
    ["keyboard_rgb_fix_remover"]="${WORK_DIR}/src/scripts/tweaks/keyboard_rgb_fix/keyboard_rgb_fix_remover.sh"

    ["spotify_installer"]="${WORK_DIR}/src/scripts/tweaks/spotify/spotify_installer.sh"
    ["spotify_remover"]="${WORK_DIR}/src/scripts/tweaks/spotify/spotify_remover.sh"

    ["wine_installer"]="${WORK_DIR}/src/scripts/tweaks/wine/wine_installer.sh"
    ["wine_remover"]="${WORK_DIR}/src/scripts/tweaks/wine/wine_remover.sh"

    # Utilities Scripts
    ["vscode_installer"]="${WORK_DIR}/src/scripts/utilities/vscode/vscode_installer.sh"
    ["vscode_remover"]="${WORK_DIR}/src/scripts/utilities/vscode/vscode_remover.sh"

    ["onlyoffice_installer"]="${WORK_DIR}/src/scripts/utilities/office/only_office/only_office_installer.sh"
    ["onlyoffice_remover"]="${WORK_DIR}/src/scripts/utilities/office/only_office/only_office_remover.sh"

    ["intellij_community_installer"]="${WORK_DIR}/src/scripts/utilities/ide/intellij_idea_community/intellij_idea_community_installer.sh"
    ["intellij_community_remover"]="${WORK_DIR}/src/scripts/utilities/ide/intellij_idea_community/intellij_idea_community_remover.sh"

    ["pycharm_community_installer"]="${WORK_DIR}/src/scripts/utilities/ide/pycharm_community/pycharm_community_installer.sh"
    ["pycharm_community_remover"]="${WORK_DIR}/src/scripts/utilities/ide/pycharm_community/pycharm_community_remover.sh"

    ["libre_office_installer"]="${WORK_DIR}/src/scripts/utilities/office/libre_office/libre_office_installer.sh"
    ["libre_office_remover"]="${WORK_DIR}/src/scripts/utilities/office/libre_office/libre_office_remover.sh"

)

# Function that log every step taken for easier debugging
# Parameters :
# $1 : Log Level [INFO, WARN, ERROR]
# $@ : Log Message
# Exemple :
# log_message "INFO" "Script execution started"
# log_message "ERROR" "An error occurred in the script"
log_message() {
    local log_level="$1"
    shift
    local message="$@"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$log_level] $message" >> "$LOG_FILE"
}

# Function that handle errors
# Parameters :
# $1 : Log Message
# $? : argument that will be used with 'trap' command to catch the exit status
handle_error() {
    local exit_status=$?
    local msg="$1"
    log_message "ERROR" "${msg} (Exit status: ${exit_status})"
    # echo -e "An error occurred: ${RED}${msg}${RESET}"
    # echo "Please check the log file at ${LOG_FILE} for more details."
    # read
	whiptail --title "ERROR" --msgbox \
	"
    An error occurred: ${msg}
    Please check the log file for more details :
    ${LOG_FILE}
    " \ 10 80
    exit $exit_status
}

# Function that install required packages depending on the distribution
install_package(){
    local package=$1
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        sudo apt install -y "$package" || handle_error "Failed to Install Required Package ${package}"
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        sudo dnf install -y "$package" || handle_error "Failed to Install Required Package ${package}"
    fi
}

# Function that verify if the required packages are installed
verify_packages() {
    local packages=("$@")
    log_message "INFO" "Verifying Required Packages"
    printc "YELLOW" "-> Verifying Required Packages..."
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            log_message "INFO" "Package ${package} is not installed !, Installing it..."
            printc "RED" "Package ${package} is not installed !, Installing it..."
            install_package "$package"
        else
            log_message "INFO" "Package ${package} is already installed"
            printc "GREEN" "Package ${package} is already installed."
        fi
    done
}

# Function to check internet connectivity
check_internet() {
    ping -c 1 -q google.com >&/dev/null
    return $?
}

# Function that prints the menu of a selected option
# Parameters :
# $1 : Title of the Selected Option
# $2 : /path/to/script_installer.sh
# $3 : /path/to/script_remover.sh
# $4 : Previous Menu to the Current One
options_menu() {
    local selected_option=$1
    local install_script=$2
    local remove_script=$3
    local previous_menu=$4
    log_message "INFO" "Displaying ${selected_option} Menu"
    local option=$(whiptail --title "$selected_option" --menu "Choose an option" 30 80 16 \
    "Install" "" \
    "Remove" "" \
    "<-- Back" "Return To Previous Menu" \
    3>&1 1>&2 2>&3)

    case $option in
        "Install")
            log_message "INFO" "User chose to install ${selected_option}"
            bash "$install_script"
            ;;
        "Remove")
            log_message "INFO" "User chose to remove ${selected_option}"
            bash "$remove_script"
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return To Previous Menu"
            "$previous_menu"
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}
