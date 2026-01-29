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

    log_message "INFO" "Configuring libvirt to use system URI"
    printc "YELLOW" "-> Configuring libvirt to use system URI..."
    echo 'export LIBVIRT_DEFAULT_URI="qemu:///system"' >> ~/.bashrc || handle_error "Failed to set LIBVIRT_DEFAULT_URI"

    log_message "INFO" "Configuring rootless libvirt and kvm"
    printc "YELLOW" "-> Configuring rootless libvirt and kvm..."
    sudo usermod -a -G kvm $(id -un) || handle_error "Failed to add user to kvm group"
    sudo usermod -a -G libvirt $(id -un) || handle_error "Failed to add user to libvirt group"

}

install_virtual_machine_manager_for_fedora_or_based(){

    log_message "INFO" "Updating System Packages"
    printc "YELLOW" "-> Updating System Packages..."
    sudo dnf update -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing Required Dependencies"
    printc "YELLOW" "-> Installing Required Dependencies..."
    sudo dnf install -y \
    vim wget curl openssl zip htop lm_sensors git \
    terminus-fonts-console python3 python3-pip || handle_error "Failed to install required dependencies"


    log_message "INFO" "Installing Virtualization packages"
    printc "YELLOW" "-> Installing Virtualization packages..."
    sudo dnf install -y \
    qemu-kvm libvirt virt-install \
    guestfs-tools libguestfs-tools bridge-utils || handle_error "Failed to Install Virtualization packages"

    log_message "INFO" "Installing Virtualization Desktop Interface"
    printc "YELLOW" "-> Installing Virtualization Desktop Interface..."
    sudo dnf install -y libgovirt virt-manager || handle_error "Failed to Install Virtualization Desktop Interface"

    log_message "INFO" "Setting up permissions"
    printc "YELLOW" "-> Setting up permissions..."
    sudo restorecon -R -vF /var/lib/libvirt || handle_error "Failed to setup permissions"

    log_message "INFO" "Enabling libvirt service"
    printc "YELLOW" "-> ..."
    sudo systemctl enable --now libvirtd || handle_error "Failed to enable libvirt service"

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

        handle_error "Unsupported Distribution: ${DISTRIBUTION}"

    fi

    echo "Virtual Machine Manager Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    if whiptail --title "Virtual Machine Manager Installed" --yesno "Do you Want to reboot now ?" 8 78; then
        echo "Rebooting..."
        reboot
    else
        print_msgbox "Success !" "Virtual Machine Manager Installed Successfully"
        print_msgbox "NOTE" "Reboot Your System to Apply Changes"
    fi

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End of Virtual Machine Manager Installation