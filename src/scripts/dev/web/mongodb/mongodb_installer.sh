#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){
    print_msgbox "NOTE" "MongDB Community Edition supports the following Ubuntu or Ubuntu-based versions:"
    print_msgbox "NOTE" "
    - Ubuntu 24.04 LTS (Noble Numbat)
    - Ubuntu 22.04 LTS (Jammy Jellyfish)
    - Ubuntu 20.04 LTS (Focal Fossa)
    "

    log_message "INFO" "Updating package list"
    printc "YELLOW" "-> Updating package list..."
    sudo apt update || handle_error "Failed to update package list"

    log_message "INFO" "Installing Required Packages"
    printc "YELLOW" "-> Installing Required Packages..."
    verify_packages "gnupg" "curl"

    log_message "INFO" "Importing MongoDB public GPG key"
    printc "YELLOW" "-> Importing MongoDB public GPG key..."
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
    --dearmor || handle_error "Failed to import MongoDB public GPG key"

    log_message "INFO" "Creating MongoDB source list file"
    printc "YELLOW" "-> Creating MongoDB source list file..."
    local ubuntu_codename=$(. /etc/os-release && echo "$UBUNTU_CODENAME")
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu ${ubuntu_codename}/mongodb-org/8.0 multiverse" | \
    sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list || handle_error "Failed to create MongoDB source list file"

    log_message "INFO" "Updating package list again"
    printc "YELLOW" "-> Updating package list again..."
    sudo apt update || handle_error "Failed to update package list again"

    log_message "INFO" "Installing MongoDB"
    printc "YELLOW" "-> Installing MongoDB..."
    sudo apt install -y mongodb-org || handle_error "Failed to install MongoDB"

    log_message "INFO" "Enabling and starting MongoDB service"
    printc "YELLOW" "-> Enabling and starting MongoDB service..."
    sudo systemctl enable mongod || handle_error "Failed to enable MongoDB service"
    sudo systemctl start mongod || handle_error "Failed to start MongoDB service"

    if whiptail --title "MongoDB Installation" --yesno "Do you want to Install MongoDB Compass (GUI for MongoDB)?" 10 60; then
        log_message "INFO" "Downloading MongoDB Compass"
        printc "YELLOW" "-> Downloading MongoDB Compass..."
        local compass_download_url="https://downloads.mongodb.com/compass/mongodb-compass_1.46.2_amd64.deb"
        local download_path="$DIRECTORY_PATH/tmp/"
        wget -c -P $download_path $compass_download_url || handle_error "Failed to download MongoDB Compass"

        log_message "INFO" "Installing MongoDB Compass"
        printc "YELLOW" "-> Installing MongoDB Compass..."
        sudo apt install -y $download_path/mongodb-compass_1.46.2_amd64.deb 
        log_message "INFO" "MongoDB Compass installed successfully"
        print_msgbox "Success" "MongoDB Compass installed successfully"
    fi

}

install_for_fedora_or_based(){
    log_message "INFO" "Creating MongoDB repository file"
    printc "YELLOW" "-> Creating MongoDB repository file..."
    sudo touch /etc/yum.repos.d/mongodb-org.repo || handle_error "Failed to create MongoDB repository file"

    log_message "INFO" "Adding MongoDB repository configuration"
    printc "YELLOW" "-> Adding MongoDB repository configuration..."
    sudo echo "[mongodb-org-]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-8.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org.repo

    log_message "INFO" "Verifying Repository Setup"
    printc "YELLOW" "-> Verifying Repository Setup..."
    sudo dnf repolist || handle_error "Failed to verify MongoDB repository setup"

    log_message "INFO" "Updating system packages"
    printc "YELLOW" "-> Updating system packages..."
    sudo dnf update -y || handle_error "Failed to update system packages"

    log_message "INFO" "Installing MongoDB"
    printc "YELLOW" "-> Installing MongoDB..."
    sudo dnf install -y mongodb-org || handle_error "Failed to install MongoDB"

    log_message "INFO" "Enabling and starting MongoDB service"
    printc "YELLOW" "-> Enabling and starting MongoDB service..."
    sudo systemctl enable mongod || handle_error "Failed to enable MongoDB service"
    sudo systemctl start mongod || handle_error "Failed to start MongoDB service"

    if whiptail --title "MongoDB Installation" --yesno "Do you want to Install MongoDB Compass (GUI for MongoDB)?" 10 60; then
        log_message "INFO" "Downloading MongoDB Compass"
        printc "YELLOW" "-> Downloading MongoDB Compass..."
        local compass_download_url="https://downloads.mongodb.com/compass/mongodb-compass-1.46.2.x86_64.rpm"
        local download_path="$DIRECTORY_PATH/tmp/"
        wget -c -P $download_path $compass_download_url || handle_error "Failed to download MongoDB Compass"

        log_message "INFO" "Installing MongoDB Compass"
        printc "YELLOW" "-> Installing MongoDB Compass..."
        sudo dnf install $download_path/mongodb-compass-1.46.2.x86_64.rpm -y || handle_error "Failed to install MongoDB Compass"
        log_message "INFO" "MongoDB Compass installed successfully"
        print_msgbox "Success" "MongoDB Compass installed successfully"
    fi
    
}

# Begin MongoDB Installation
echo "Continue script execution in MongoDB Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing MongoDB for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing MongoDB for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with MongoDB Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with MongoDB Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n "$UBUNTU_BASE" ]]; then
        install_for_ubuntu_or_based
    elif [[ "$DISTRIBUTION" == "fedora" || -n "$FEDORA_BASE" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported distribution: ${DISTRIBUTION}"
    fi

    echo "Script Execution in MongoDB Installation Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "MongoDB Installed Successfully"

else

    handle_error "No Connection Available ! Exiting..."

fi
# End MongoDB Installation