#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Oracle VirtualBox Installation at $(date)" >> "$LOG_FILE"

install_oracle_vm_for_ubuntu_or_based(){

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    local system_release=$(cat /etc/issue)
    local codename=$(. /etc/os-release && echo "$UBUNTU_CODENAME")

    log_message "WARN" "Warn User about System Requirement"
    printc "YELLOW" "NOTE : Your System Must be Ubuntu or Ubuntu-Based >= 20.04"
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Downloading Oracle VM for ${system_release:0:-6}"
    printc "YELLOW" "-> Downloading Oracle VM for ${system_release:0:-6}..."

    wget -c -P $(pwd)/tmp/ https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~${codename}_amd64.deb

    log_message "INFO" "Installing Oracle VM"
    printc "YELLOW" "-> Installing Oracle VM..."
    sudo apt install libxcb-cursor0 || handle_error "Failed to Install Required Package"
    sudo dpkg -i $(pwd)/tmp/virtualbox-7.1*.deb
    sudo apt --fix-broken install -y || handle_error "Failed to install Oracle VM"


}

install_oracle_vm_for_fedora_or_based(){

    log_message "INFO" "Refreshing Package Cache for Fedora"
    printc "YELLOW" "-> Refreshing Package Cache for Fedora..."
    sudo dnf check-update || handle_error "Failed to Refresh Package Cache for Fedora"

    log_message "INFO" "Installing Required Packages"
    printc "YELLOW" "-> Installing Required Packages..."
    sudo dnf -y install @development-tools || handle_error "Failed to Install Required Packages"
    sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras || handle_error "Failed to Install Required Packages"

    log_message "INFO" "Importing VirtualBox GPG Key"
    printc "YELLOW" "-> Importing VirtualBox GPG Key..."
    sudo rpm --import https://www.virtualbox.org/download/oracle_vbox_2016.asc || handle_error "Failed to Import VirtualBox GPG Key"

    log_message "INFO" "Adding VirtualBox Repository"
    printc "YELLOW" "-> Adding VirtualBox Repository..."
    sudo wget -P /etc/yum.repos.d/ https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo || handle_error "Failed to Add VirtualBox Repository"

    log_message "INFO" "Installing Oracle VM"
    printc "YELLOW" "-> Installing Oracle VM..."
    sudo dnf install VirtualBox-7.1 -y || handle_error "Failed to Install Oracle VM"

    log_message "INFO" "Adding User to vboxusers Group"
    printc "YELLOW" "-> Adding User to vboxusers Group..."
    sudo usermod -aG vboxusers $USER || handle_error "Failed to Add User to vboxusers Group"

}

# Begin Oracle VirtualBox Installation
printc "GREEN" "Installing for ${DISTRIBUTION_NAME}..."
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Oracle VirtualBox Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Oracle VirtualBox Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then

        install_oracle_vm_for_ubuntu_or_based

    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then

        install_oracle_vm_for_fedora_or_based

    else

        handle_error "Unsupported Distribution: $DISTRIBUTION"

    fi

    echo "Oracle VirtualBox Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Oracle VirtualBox Installed Successfully..."
    printc "YELLOW" "NOTE : Reboot Your System to Apply Changes"
    echo "PRESS [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End of Oracle VirtualBox Installation