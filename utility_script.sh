#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
DEV_MENU="${DIRECTORY_PATH}/src/menus/dev.sh"
AI_MENU="${DIRECTORY_PATH}/src/menus/ai.sh"
TWEAKS_MENU="${DIRECTORY_PATH}/src/menus/tweaks.sh"
DRIVERS_MENU="${DIRECTORY_PATH}/src/menus/drivers.sh"
UTILITIES_MENU="${DIRECTORY_PATH}/src/menus/utilities.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting Utility Script Execution at $(date)" > "$LOG_FILE"

log_message() {
    local log_level="$1"
    shift
    local message="$@"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$log_level] $message" >> "$LOG_FILE"
}

show_system_info(){
    local distro_name=$(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
    local system_arch=$(uname -m)
    echo ${distro_name} - ${system_arch}
}

# Show Main Menu
show_main_menu(){
    local system_info=$(show_system_info)
    log_message "INFO" "Displaying The Main Menu"
    local option=$(whiptail --title "Linux Utility Script" --menu "Choose an option\n(Currently using : ${system_info})" 30 80 16 \
    "Development" "Install Development Apps like Android Studio and Angular" \
    "Utilities" "Install Daily Use Apps like Office Apps, IDE, ..." \
    "AI" "Install Scientific Tools Like TensorFlow and Pytorch" \
    "Drivers" "Install FOSS/Proprietary Drivers Like NVIDIA Drivers" \
    "System Tweaks" "Install Some Goodies for Your System" \
    "Quit" "Exit Linux Utility Script" \
    3>&1 1>&2 2>&3)

    case $option in
        "Development")
            log_message "INFO" "User chose the Development Menu"
            source "$DEV_MENU"
            ;;
        "Utilities")
            log_message "INFO" "User chose the Utilities Menu"
            source "$UTILITIES_MENU"
            ;;
        "AI")
            log_message "INFO" "User chose the AI Menu"
            source "$AI_MENU"
            ;;
        "Drivers")
            log_message "INFO" "User chose the Drivers Menu"
            source "$DRIVERS_MENU"
            ;;
        "System Tweaks")
            log_message "INFO" "User chose the System Tweaks Menu"
            source "$TWEAKS_MENU"
            ;;
        "Quit")
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting Script..."
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

show_usage(){
    echo "Usage: $0 [options]"
    echo "Options:"
    echo " --install <tool1>,<tool2>,...   Install a specified tool"
    echo " --remove <tool1>,<tool2>,...    Remove a specified tool"
    echo " --list-tools                    List all available tools"
    echo " --help                          Show this help message"
    echo "Examples:"
    echo "  $0 --install pytorch,vscode"
    echo "  $0 --remove intellij_idea_community"
}

list_tools(){
    echo "Available tools:"
    echo "-----------------AI------------------"
    echo "pytorch"
    echo "tensorflow"
    echo "conda"
    echo "jupyter"
    echo "----------------DEV------------------"
    echo "android_studio"
    echo "flutter"
    echo "docker"
    echo "oracle_vm"
    echo "angular"
    echo "--------------DRIVERS-----------------"
    echo "cuda"
    echo "nvidia_driver"
    echo "---------------TWEAKS-----------------"
    echo "keyboard_rgb_fix"
    echo "pipewire"
    echo "spotify"
    echo "wine"
    echo "-------------UTILITIES----------------"
    echo "intellij_idea_community"
    echo "pycharm_community"
    echo "vscode"
    echo "libre_office"
    echo "only_office"
    echo "--------------------------------------"
}

take_action(){
    local action=$1
    local tool=$2
    if [[ "$action" == "install" ]]; then

        log_message "INFO" "Installing: $tool"
        if [[ ! -z "${scriptPaths["${tool}_installer"]}" && -f "${scriptPaths["${tool}_installer"]}" ]]; then
            log_message "INFO" "Installer script found for: $tool"
            bash "${scriptPaths["${tool}_installer"]}"
        else
            log_message "ERROR" "Installer script not found for: $tool"
            echo "Installer script not found for: $tool"
        fi

    elif [[ "$action" == "remove" ]]; then

        log_message "INFO" "Removing: $tool"
        if [[ ! -z "${scriptPaths["${tool}_remover"]}" && -f "${scriptPaths["${tool}_remover"]}" ]]; then
            log_message "INFO" "Remover script found for: $tool"
            bash "${scriptPaths["${tool}_remover"]}"
        else
            log_message "ERROR" "Remover script not found for: $tool"
            echo "Remover script not found for: $tool"
        fi

    fi
}

check_integrity(){

    log_message "INFO" "Checking integrity of the script in auto mode"

    log_message "INFO" "1. Checking for Menus and Utils Definitions"
    local menus=("$DEV_MENU" "$AI_MENU" "$TWEAKS_MENU" "$DRIVERS_MENU" "$UTILITIES_MENU" )
    for menu in "${menus[@]}"; do
        if [[ ! -f "$menu" ]]; then
            log_message "ERROR" "Menu file not found: $menu"
            echo "Menu file not found: $menu"
            exit 1
        fi
    done

    log_message "INFO" "2. Checking for Utils Definition"
    if [[ -f "$UTILS" ]]; then
        log_message "INFO" "Utils file found: $UTILS"
    else
        log_message "ERROR" "Utils file not found: $UTILS"
        echo "Utils file not found: $UTILS"
        exit 1
    fi

    log_message "INFO" "3. Checking for Script Definitions"
    if [[ -f "$SCRIPTS_PATH" ]]; then
        log_message "INFO" "Script Paths file found: $SCRIPTS_PATH"
        
    else
        log_message "ERROR" "Script Paths file not found: $SCRIPTS_PATH"
        echo "Script Paths file not found: $SCRIPTS_PATH"
        exit 1
    fi

    log_message "INFO" "4. Checking for Script Files"
    for script in "${!scriptPaths[@]}"; do
        if [[ -f "${scriptPaths[$script]}" ]]; then
            log_message "INFO" "Script file found: ${scriptPaths[$script]}"
        else
            log_message "ERROR" "Script file not found: ${scriptPaths[$script]}"
            echo "Script file not found: ${scriptPaths[$script]}"
            exit 1
        fi
    done
    
}

# Begin Utility Script
if check_integrity; then
    source "$UTILS"
    source "$SCRIPTS_PATH"
fi

while [[ $# -gt 0 ]]; do
    log_message "INFO" "Using Utility Script in Non-Interactive Mode"
    case "$1" in
        --install)
            log_message "INFO" "Installing the following tools: $2"
            ACTION="install"
            TOOLS="$2"
            shift 2
            ;;
        --remove)
            log_message "INFO" "Removing the following tools: $2"
            ACTION="remove"
            TOOLS="$2"
            shift 2
            ;;
        --list-tools)
            log_message "INFO" "Listing available tools"
            list_tools
            exit 0
            ;;
        --help)
            log_message "INFO" "Showing help message"
            show_usage
            exit 0
            ;;
        *)
            log_message "ERROR" "Unknown option: $1"
            echo "Unknown option: $1"
            show_usage
            exit 0
            ;;
    esac
done

if [[ -n "$ACTION" && -n "$TOOLS" ]]; then
    IFS=',' read -ra TOOL_LIST <<< "$TOOLS"
    for TOOL in "${TOOL_LIST[@]}"; do
        log_message "INFO" "Processing tool: $TOOL"
        echo "Processing tool: $TOOL"
        take_action "$ACTION" "$TOOL"
    done
    exit 0
fi

log_message "INFO" "Using Utility Script in Interactive Mode"

log_message "INFO" "Checking for Required Packages : whiptail"
printc "YELLOW" "-> Checking for Required Packages : whiptail..."
verify_packages "whiptail"
show_main_menu
# End Utility Script