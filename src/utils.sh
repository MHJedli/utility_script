#!/bin/bash

# Script Paths
declare -A scriptPaths=(
    ["angular_installer"]="src/scripts/dev/angular_installer.sh"
    ["android_studio_installer"]="src/scripts/dev/android_studio_installer.sh"
    ["flutter_installer"]="src/scripts/dev/flutter_installer.sh"
    ["nvidia_driver_installer"]="src/scripts/tweaks/nvidia_installer.sh"
    
)

# Function that log every step taken for easier debugging
# Parameters :
# $1 : Log Level [INFO, WARN, ERROR]
# $@ : Log Message
# Exemple :
# log_message "INFO" "Script execution started"
# log_message "ERROR" "An error occurred in the script"
log_message() {
    local LOG_LEVEL="$1"
    shift
    local MESSAGE="$@"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LOG_LEVEL] $MESSAGE" >> "$LOG_FILE"
}

# Function that handle errors
# Parameters :
# $1 : Log Message
# $? : argument that will be used with 'trap' command to catch the exit status
handle_error() {
    local exit_status=$?
    local msg="$1"
    log_message "ERROR" "$msg (Exit status: $exit_status)"
    echo "An error occurred: $msg"
    echo "Please check the log file at $LOG_FILE for more details."
    read
    exit $exit_status
}

# invalidOption print Function
invalidOption() {
    echo "No Option Selected !"
    echo "Press Enter To Continue ..."
    read
    if [ $# -gt 0 ]; then
        "$1"
    fi
}

# Function to check internet connectivity
check_internet() {
    ping -c 1 -q google.com >&/dev/null
    return $?
}

# Function that prints the Menu of different versions of a selected distro
# Parameters : 
# $1 : Menu Title
# $@ : Menu Options
# Example : 
# showMenu "Title" "Option 1" "Option 2" ...
showMenu() {
    local title="$1"
    shift
    clear
    echo "--------------------------------------"
    echo " $title "
    echo "--------------------------------------"
    local index=1
    for option in "$@"; do
        echo "$index. $option"
        ((index++))
    done
}

# Function that prints the menu of a selected option
# Parameters :
# $1 : Title of the Selected Option
# $2 : /path/to/script_installer.sh
# $3 : /path/to/script_remover.sh
# $4 : Previous Menu to the Current One
optionMenu() {
    local selectedOption=$1
    local installScript=$2
    local removeScript=$3
    local previousMenu=$4
    while true; do
        log_message "INFO" "Displaying $selectedOption Menu"
        clear
        echo "-------------------------------------------------"
        echo " $selectedOption   "
        echo "-------------------------------------------------"
        echo "1. Install"
        echo "2. Remove"
        echo "3. Return To Previous Menu"
        echo -n "Enter Option: "
        read option
        log_message "INFO" "User selected option $option in the $selectedOption Menu"
        case $option in
            1)
                log_message "INFO" "User chose to Install $selectedOption" 
                bash "$installScript" 
                ;;
            2)
                log_message "INFO" "User chose to Remove $selectedOption"
                bash "$removeScript" 
                ;;
            3)
                log_message "INFO" "User chose to Return to Previous Menu"
                "$previousMenu"
                return 
                ;;
            *)
                log_message "WARN" "User chose an invalid option : $option"
                invalidOption 
                optionMenu "$selectedOption" "$installScript" "$removeScript" "$previousMenu"
                ;;
        esac
    done
}


# Function that prints the menu of available distributions of a selected option
# Parameters :
# $1 : Title of the Selected Option
# $2 : /path/to/script_installer.sh
# $3 : Previous Menu to the Current One
distroMenu() {
    # System Release
    system_release=$(cat /etc/issue)

    local selectedOption=$1
    local ubuntuScriptInstaller=$2
    local previousMenu=$3
    while true; do
        log_message "INFO" "Displaying $selectedOption Menu"
        clear
        echo "-------------------------------------------------"
        echo " $selectedOption   "
        echo "-------------------------------------------------"
        echo "Select Your Linux Distribution : ( Distribution In Use -> '${system_release:0:-6}' )"
        echo "1. Ubuntu or Ubuntu-Based"
        echo "2. Return To Previous Menu"
        echo -n "Enter Option: "
        read option
        log_message "INFO" "User selected option $option in the $selectedOption Menu"
        case $option in
            1)
                log_message "INFO" "User chose Ubuntu or Ubuntu-Based" 
                optionMenu "$selectedOption" "$ubuntuScriptInstaller" "" "$previousMenu"
                ;;
            2)
                log_message "INFO" "User chose to Return to Previous Menu"
                "$previousMenu"
                return 
                ;;
            *)
                log_message "WARN" "User chose an invalid option : $option"
                invalidOption 
                distroMenu "$selectedOption" "$ubuntuScriptInstaller" "$previousMenu"
                ;;
        esac
    done
}