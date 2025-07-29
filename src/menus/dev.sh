#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_development_menu(){
    log_message "INFO" "Displaying Development Menu"
    local option=$(whiptail --title "Development Menu" --menu "Choose an option" $HEIGHT $WIDTH 4 \
    "Mobile" "Develop Mobile apps and emulate them" \
    "Web" "Develop Web apps" \
    "Virtualization" "Manage your VMs and Containers" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Mobile")
            log_message "INFO" "User chose Mobile Menu"
            show_mobile_menu
            ;;
        "Web")
            log_message "INFO" "User chose Web Menu"
            show_web_development_menu
            ;;
        "Virtualization")
            log_message "INFO" "User chose Virtualization Menu"
            show_virtualization_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

# Mobile Menu
show_mobile_menu(){
    log_message "INFO" "Displaying Mobile Tools Menu"
    local option=$(whiptail --title "Mobile Tools and Frameworks Menu" --menu "Choose an option" $HEIGHT $WIDTH 4 \
    "Android Studio" "IDE and Android Emulator" \
    "Waydroid" "Android in a Linux Container" \
    "Flutter SDK" "Used for Cross-Platform Development (Mobile, Web, Desktop)" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Android Studio")
            log_message "INFO" "User chose Android Studio Menu"
            show_android_studio_menu
            ;;
        "Waydroid")
            log_message "INFO" "User chose Waydroid Menu"
            show_waydroid_menu
            ;;
        "Flutter SDK")
            log_message "INFO" "User chose Flutter SDK Menu"
            show_flutter_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to development Menu"
            show_development_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_android_studio_menu(){
    options_menu "Android Studio" \
               "${scriptPaths["android_studio_installer"]}" \
               "" \
               "show_mobile_menu"

}

show_waydroid_menu(){
    options_menu "Waydroid" \
               "${scriptPaths["waydroid_installer"]}" \
               "${scriptPaths["waydroid_remover"]}" \
               "show_mobile_menu"
}

show_flutter_menu(){
    options_menu "Flutter" \
               "${scriptPaths["flutter_installer"]}" \
               "" \
               "show_mobile_menu"   
}

# Web Development Menu
show_web_development_menu(){
    log_message "INFO" "Displaying Web Development Tools and Frameworks Menu"
    local option=$(whiptail --title "Web Development Tools and Frameworks Menu" --menu "Choose an option" $HEIGHT $WIDTH 4 \
    "Angular CLI" "  Used for FrontEnd Development and SPA" \
    "MongoDB" "  NoSQL Database for Web Apps" \
    "NodeJS" "  Run JavaScript Everywhere" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Angular CLI")
            log_message "INFO" "User chose Angular Menu"
            show_angular_menu
            ;;
        "MongoDB")
            log_message "INFO" "User chose MongoDB Menu"
            show_mongodb_menu
            ;;
        "NodeJS")
            log_message "INFO" "User chose NodeJS Menu"
            show_nodejs_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to development Menu"
            show_development_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_angular_menu(){
    options_menu "Angular" \
               "${scriptPaths["angular_installer"]}" \
               "" \
               "show_web_development_menu"
}
show_mongodb_menu(){
    options_menu "MongoDB" \
               "${scriptPaths["mongodb_installer"]}" \
               "${scriptPaths["mongodb_remover"]}" \
               "show_web_development_menu"
}
show_nodejs_menu(){
    options_menu "NodeJS" \
               "${scriptPaths["nodejs_installer"]}" \
               "${scriptPaths["nodejs_remover"]}" \
               "show_web_development_menu" 
}

# Virtualization Menu
show_virtualization_menu(){
    log_message "INFO" "Displaying Virtualization Tools and Frameworks Menu"
    local option=$(whiptail --title "Virtualization Tools and Frameworks Menu" --menu "Choose an option" $HEIGHT $WIDTH 4 \
    "Oracle VirtualBox" "Create Multiple VMs for testing Purposes" \
    "Docker" "Containerization Platform" \
    "Virtual Machine Manager" "Create near-native Performances VMs with QEMU/KVM" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Oracle VirtualBox")
            log_message "INFO" "User chose Oracle VirtualBox Menu"
            show_virtualbox_menu
            ;;
        "Virtual Machine Manager")
            log_message "INFO" "User chose Virtual Machine Manager Menu"
            show_virtual_machine_manager_menu
            ;;
        "Docker")
            log_message "INFO" "User chose Docker Menu"
            show_docker_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to development Menu"
            show_development_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_virtualbox_menu(){
    options_menu "Oracle VirtualBox" \
               "${scriptPaths["oracle_vm_installer"]}" \
               "" \
               "show_virtualization_menu"    
}
show_virtual_machine_manager_menu(){
    options_menu "Virtual Machine Manager" \
               "${scriptPaths["virtual_machine_manager_installer"]}" \
               "${scriptPaths["virtual_machine_manager_remover"]}" \
               "show_virtualization_menu"    
}
show_docker_menu(){
    options_menu "Docker" \
               "${scriptPaths["docker_installer"]}" \
               "${scriptPaths["docker_remover"]}" \
               "show_virtualization_menu" 
}

# Begin Development Menu
show_development_menu
# End Development Menu