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
