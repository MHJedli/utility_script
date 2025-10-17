#!/usr/bin/env bash -i

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

download_and_extract(){

    local version=$1
    local download_path="$(pwd)/tmp"
    local download_link="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz"
    
    log_message "INFO" "Downloading Flutter SDK ${version}"
    printc "YELLOW" "-> Downloading Flutter SDK ${version}..."
    wget -c -P "$download_path/" "$download_link" || handle_error "Failed to Download Flutter SDK ${version}"

    log_message "INFO" "Extracting Flutter SDK to ~/"
    printc "YELLOW" "-> Extracting Flutter SDK to ~/"
    rm -rf ~/flutter
    tar -xvf "${download_path}/flutter_linux_${version}-stable.tar.xz" -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"

}

install_other_flutter_version(){

    local stable_flutter_versions=$(echo $AVAILABLE_FLUTTER_VERSIONS | jq -r '.releases[].version' | grep -vE '(-pre|\.pre)' | sed 's/^v//')
    local filtered_versions=$(echo "$stable_flutter_versions" | awk -F. '
    {
        major=$1; minor=$2; patch=$3
        if (major > 3 || (major == 3 && minor > 22) || (major == 3 && minor == 22 && patch >= 0)) 
            print $0
    }' | sort -V -r)

    local flutter_versions=()
    mapfile -t flutter_versions <<< "$filtered_versions"

    local flutter_versions_options=()
    for version in "${flutter_versions[@]}"; do
        flutter_versions_options+=("Flutter SDK Version ${version}" "")
    done

    log_message "INFO" "Displaying Flutter SDK Versions Menu"
    local option=$(whiptail --title "Flutter SDK Installer" --menu "Choose an option" $HEIGHT $WIDTH 10 "${flutter_versions_options[@]}" 3>&1 1>&2 2>&3)
    if [[ $? -ne 0 ]]; then
        handle_error "User exited the menu"
    fi

    local selected_version=$(echo "$option" | grep -oP '(\d+\.\d+\.\d+)')
    if [[ -n $selected_version ]]; then

        log_message "INFO" "User chose Flutter SDK Version ${selected_version}"
        printc "YELLOW" "-> Installing Flutter SDK Version ${selected_version}..."
        download_and_extract "$selected_version"

    else

        handle_error "No valid version selected"

    fi

}

install_latest_flutter_version(){

    log_message "INFO" "User chose to install Latest Flutter SDK Version"
    local latest_version=$(echo $AVAILABLE_FLUTTER_VERSIONS | jq -r '.releases[] | select (.channel == "stable") | .version' | head -n1)
    download_and_extract "$latest_version"

}

install_flutter(){

    log_message "INFO" "Displaying Flutter SDK Menu"
    if whiptail --title "Flutter SDK Installer" --yesno "Do you want to install The Latest Version of Flutter SDK ?" $HEIGHT $WIDTH; then

        install_latest_flutter_version
    else
    
        log_message "INFO" "Displaying Other Flutter SDK Versions"
        install_other_flutter_version

    fi

}

# Begin Flutter SDK Installation
echo "Continue script execution in Flutter SDK Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Flutter SDK for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Flutter SDK for ${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Flutter SDK Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Flutter SDK Installation..."

    if [[ "$DISTRIBUTION" == "ubuntu" || -n $UBUNTU_BASE ]]; then

        log_message "INFO" "Refreshing Package Cache"
        printc "YELLOW" "-> Refreshing Package Cache..."
        sudo apt update || handle_error "Failed to Refresh Package Cache"

        log_message "INFO" "Updating System Packages"
        printc "YELLOW" "-> Updating System Packages..."
        sudo apt upgrade -y || handle_error "Failed to Update System Packages"
        
        log_message "INFO" "Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa"
        printc "YELLOW" "-> Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa..."
        sudo apt install -y curl git unzip xz-utils zip libglu1-mesa jq || handle_error "Failed to Install Required Packages"

    elif [[ "$DISTRIBUTION" == "fedora" || -n $FEDORA_BASE ]]; then

        log_message "INFO" "Updating System Packages"
        printc "YELLOW" "-> Updating System Packages..."
        sudo dnf upgrade -y || handle_error "Failed to Update System Packages"
        
        log_message "INFO" "Installing the following packages: curl, git, unzip, xz, zip"
        printc "YELLOW" "-> Installing the following packages: curl, git, unzip, xz, zip..."
        sudo dnf install -y curl git unzip xz zip jq || handle_error "Failed to Install Required Packages"
        
    fi

    log_message "INFO" "Fetching Available Flutter SDK from Servers"
    printc "YELLOW" "-> Fetching Available Flutter SDK from Servers..."
    AVAILABLE_FLUTTER_VERSIONS=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)

    install_flutter

    log_message "INFO" "Removing Old Flutter PATH if Existed"
    printc "YELLOW" "-> Removing Old Flutter PATH if Existed..."
    grep -l 'flutter/bin' ~/.bashrc | xargs -I {} sed -i '/flutter\/bin/d' {}

    log_message "INFO" "Adding Flutter to PATH (bash)"
    printc "YELLOW" "-> Adding Flutter to PATH (bash)..."
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc || handle_error "Failed to Add Flutter to PATH (bash)"

    echo "Flutter SDK Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "Flutter SDK Installer Script Completed Successfully"
    exec bash

else

    handle_error "No Internet Connection Available, Exiting..."

fi
# End Flutter SDK Installation