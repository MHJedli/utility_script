#!/usr/bin/env bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Flutter SDK Installation at $(date)" >> "$LOG_FILE"

download_and_extract(){
    local version=$1
    log_message "INFO" "Downloading Flutter SDK ${version}"
    printc "YELLOW" "-> Downloading Flutter SDK ${version}..."
    sleep 1
    wget -c https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${version}-stable.tar.xz || handle_error "Failed to Download Flutter SDK ${version}"

    log_message "INFO" "Extracting Flutter SDK to ~/"
    printc "YELLOW" "-> Extracting Flutter SDK to ~/"
    sleep 1
    rm -rf ~/flutter
    tar -xvf flutter_linux_${version}-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"
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

    local option=$(whiptail --title "Flutter SDK Installer" --menu "Choose an option" 30 80 10 "${flutter_versions_options[@]}" 3>&1 1>&2 2>&3)

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
    if whiptail --title "Flutter SDK Installer" --yesno "Do you want to install The Latest Version of Flutter SDK ?" 8 78; then
        install_latest_flutter_version
    else
        log_message "INFO" "Displaying Others Flutter SDK Versions"
        install_other_flutter_version
    fi
}

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Flutter SDK Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Flutter SDK Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System Packages"
    printc "YELLOW" "-> Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa"
    printc "YELLOW" "-> Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa..."
    sleep 1
    sudo apt install -y curl git unzip xz-utils zip libglu1-mesa || handle_error "Failed to Install Required Packages"

    log_message "INFO" "Fetching Available Flutter SDK from Servers"
    printc "YELLOW" "-> Fetching Available Flutter SDK from Servers..."
    AVAILABLE_FLUTTER_VERSIONS=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)
    install_flutter

    log_message "INFO" "Removing Old Flutter PATH if Existed"
    printc "YELLOW" "-> Removing Old Flutter PATH if Existed..."
    grep -l 'flutter/bin' ~/.bashrc | xargs -I {} sed -i '/flutter\/bin/d' {}

    log_message "INFO" "Adding Flutter to PATH (bash)"
    printc "YELLOW" "-> Adding Flutter to PATH (bash)..."
    sleep 1
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc || handle_error "Failed to Add Flutter to PATH (bash)"

    log_message "INFO" "Activating Flutter"
    printc "YELLOW" "-> Activating Flutter..."
    sleep 1
    source ~/.bashrc || handle_error "Failed to Activate Flutter"

    log_message "INFO" "Executing flutter doctor -v"
    printc "YELLOW" "-> Executing flutter doctor -v (It May Take a Little While)"
    sleep 1
    flutter doctor -v || handle_error "Failed to Execute flutter doctor -v"
    echo -n "Press [ENTER] to Continue..."
    read

    echo "Flutter SDK Installer Script Completed Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Success !" "lutter SDK Installer Script Completed Successfully"

else

    handle_error "No Internet Connection Available, Exiting..."

fi