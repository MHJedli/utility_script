#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

check_virtualization_type(){
    local virtualization_type=$(lscpu | grep -E --color=always 'AMD-V|VT-x')
    echo $virtualization_type
    if [[ -z "$virtualization_type" ]]; then
        handle_error "Virtualization Type Not Supported"
    else
        log_message "INFO" "Virtualization Type Supported"
        printc "GREEN" "-> Virtualization Type Supported"
    fi
}

install_virtual_machine_manager_for_ubuntu_or_based(){

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Virtual Machine Manager"
    printc "YELLOW" "-> Installing Virtual Machine Manager..."
    sudo apt install virt-manager -y || handle_error "Failed to Install Virtual Machine Manager"

}

install_virtual_machine_manager_for_fedora_or_based(){

    log_message "INFO" "Feature not implemented yet"
    printc "YELLOW" "-> Feature not implemented yet"
    exit 1
}

setup_configurations(){

    log_message "INFO" "Configuring libvirt to use system URI"
    printc "YELLOW" "-> Configuring libvirt to use system URI..."
    echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.bashrc || handle_error "Failed to set LIBVIRT_DEFAULT_URI"

    log_message "INFO" "Configuring rootless libvirt and kvm"
    printc "YELLOW" "-> Configuring rootless libvirt and kvm..."
    sudo usermod -a -G kvm $(id -un) || handle_error "Failed to add user to kvm group"
    sudo usermod -a -G libvirt $(id -un) || handle_error "Failed to add user to libvirt group"

}

# Begin Virtual Machine Manager Installation
echo "Continue script execution in Virtual Machine Manager Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Virtual Machine Manager for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Virtual Machine Manager for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Virtual Machine Manager Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Virtual Machine Manager Installation..."

    log_message "INFO" "Checking Virtualization Type"
    printc "YELLOW" "-> Checking Virtualization Type..."
    check_virtualization_type

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then

        install_virtual_machine_manager_for_ubuntu_or_based

    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then

        install_virtual_machine_manager_for_fedora_or_based

    else

        handle_error "Unsupported Distribution: $DISTRIBUTION"

    fi

    setup_configurations

    echo "Virtual Machine Manager Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Virtual Machine Manager Installed Successfully"
    print_msgbox "NOTE" "Reboot Your System to Apply Changes"

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End of Virtual Machine Manager Installation