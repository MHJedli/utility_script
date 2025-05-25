#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

print_notes(){
    print_msgbox "Note" "
    Before Installing Waydroid, quick things to note:
    1. Waydroid is a container-based approach to running Android on Linux.
    2. Your system must be launched with wayland session.
    
    "
    print_msgbox "Note" "
    3. For Full Hardware Acceleration, you must have Intel/AMD (d/i)GPU.
    "
}

install_waydroid_for_ubuntu_or_based(){
    log_message "INFO" "Installing pre-requisites"
    printc "YELLOW" "-> Installing pre-requisites..."
    sudo apt install curl ca-certificates -y || handle_error "Failed to install pre-requisites"

    log_message "INFO" "Adding the official waydroid repository"
    printc "YELLOW" "-> Adding the official waydroid repository..."
    curl -s https://repo.waydro.id | sudo bash || handle_error "Failed to add the official waydroid repository"

    log_message "INFO" "Installing Waydroid"
    printc "YELLOW" "-> Installing Waydroid..."
    sudo apt install waydroid -y || handle_error "Failed to install Waydroid"
    
}

install_waydroid_for_fedora_or_based(){
 echo "NONO"
}

init_waydroid(){
    log_message "INFO" "Initializing Waydroid (GAPPS Edition)"
    printc "YELLOW" "-> Initializing Waydroid (GAPPS Edition)..."
    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        sudo waydroid init -s GAPPS || handle_error "Failed to initialize Waydroid"
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        local system_ota="https://ota.waydro.id/system"
        local vendor_ota="https://ota.waydro.id/vendor"
        sudo waydroid init -s GAPPS -c $system_ota -v $vendor_ota || handle_error "Failed to initialize Waydroid"
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi
    
}

check_cpu_name(){

    local CPU_NAME=$(lscpu | grep "Model name" | awk -F: '{ print $2 }' | xargs)
    if [[ -z "$CPU_NAME" ]]; then
        handle_error "Failed to detect CPU Name"
    fi

    echo $CPU_NAME
}

post_installation_steps(){

    log_message "INFO" "Executing Post Installation Steps"
    printc "YELLOW" "-> Executing Post Installation Steps..."

    log_message "INFO" "Verfiying Required Packages"
    printc "YELLOW" "-> Verifying Required Packages..."
    verify_packages "lzip"


    log_message "INFO" "Cloning and Setting Up Waydroid Script Repository"
    printc "YELLOW" "-> Cloning and Setting Up Waydroid Script Repository..."
    if [[ -d ${DIRECTORY_PATH}/tmp/waydroid_script ]]; then
        log_message "INFO" "Removing existing waydroid_script directory"
        printc "YELLOW" "-> Removing existing waydroid_script directory..."
        rm -rf ${DIRECTORY_PATH}/tmp/waydroid_script || handle_error "Failed to remove existing waydroid_script directory"
    fi

    git clone https://github.com/casualsnek/waydroid_script ${DIRECTORY_PATH}/tmp/waydroid_script || handle_error "Failed to clone waydroid_script repository"
    cd ${DIRECTORY_PATH}/tmp/waydroid_script || handle_error "Failed to change directory to waydroid_script"
    python3 -m venv venv || handle_error "Failed to create virtual environment"
    venv/bin/pip install -r requirements.txt || handle_error "Failed to install requirements"

    log_message "INFO" "Checking CPU"
    printc "YELLOW" "-> Checking CPU..."
    local CPU_NAME=$(check_cpu_name)

    log_message "INFO" "Detected CPU: $CPU_NAME"
    printc "GREEN" "-> Detected CPU: $CPU_NAME"
    if [[ "$CPU_NAME" == *"Intel"* ]]; then
        log_message "INFO" "Installing libhoudini arm translation layer"
        printc "YELLOW" "-> Installing libhoudini arm translation layer..."
        sudo venv/bin/python3 main.py install libhoudini || handle_error "Failed to install libhoudini arm translation layer"
        
    elif
     [[ "$CPU_NAME" == *"AMD"* ]]; then
        log_message "INFO" "Installing libndk arm translation layer"
        printc "YELLOW" "-> Installing libndk arm translation layer..."
        sudo venv/bin/python3 main.py install libndk || handle_error "Failed to install libndk arm translation layer"
    fi

    print_msgbox "IMPORTANT" "
    Before we finish, we need to fix the Google Play Certification:
    1. Open Waydroid from Application Menu and then come here
    Press OK to when done...
    "


    print_msgbox "IMPORTANT" "$(sudo venv/bin/python3 main.py certified)"

}

# Begin Waydroid Installation
echo "Continue script execution in Waydroid Installation at $(date)" >> "$LOG_FILE"

print_notes

log_message "INFO" "Installing Waydroid for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Waydroid for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Waydroid Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Waydroid Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_waydroid_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        sudo dnf install waydroid -y || handle_error "Failed to install Waydroid for Fedora"
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    init_waydroid
    post_installation_steps

    echo "Script Execution in Waydroid Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Waydroid Installed Successfully"

else

    handle_error "No Connection Available ! Exiting..."

fi
# End Waydroid Installation