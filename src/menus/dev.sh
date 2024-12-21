#!/usr/bin/env bash
source $(pwd)/src/utils.sh

show_development_menu(){
    log_message "INFO" "Displaying Development Menu"
    local option=$(whiptail --title "Development Menu" --menu "Choose an option" 30 80 16 \
    "Angular CLI" "Used for FrontEnd Development" \
    "Android Studio" "Used for Mobile Development" \
    "Flutter SDK" "Used for Cross-Platform Developement" \
    "Oracle VirtualBox" "Used for Virtualization Purposes" \
    "Docker" "Used for Managing Containers" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Angular CLI")
            log_message "INFO" "User chose Angular Menu"
            show_angular_menu
            ;;
        "Android Studio")
            log_message "INFO" "User chose Android Studio Menu"
            show_android_studio_menu
            ;;
        "Flutter SDK")
            log_message "INFO" "User chose Flutter SDK Menu"
            show_flutter_menu
            ;;
        "Oracle VirtualBox")
            log_message "INFO" "User chose Oracle VirtualBox Menu"
            show_virtualbox_menu
            ;;
        "Docker")
            log_message "INFO" "User chose Docker Menu"
            show_docker_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            show_main_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

show_angular_menu(){
    options_menu "Angular" \
               "${scriptPaths["angular_installer"]}" \
               "" \
               "showDevelopmentMenu"
}

show_android_studio_menu(){
    options_menu "Android Studio" \
               "${scriptPaths["android_studio_installer"]}" \
               "" \
               "showDevelopmentMenu"

}

show_flutter_menu(){
    options_menu "Flutter" \
               "${scriptPaths["flutter_installer"]}" \
               "" \
               "showDevelopmentMenu"   
}
show_virtualbox_menu(){
    options_menu "Oracle VirtualBox" \
               "${scriptPaths["oracle_vm_installer"]}" \
               "" \
               "showDevelopmentMenu"    
}
show_docker_menu(){
    options_menu "Docker" \
               "${scriptPaths["docker_installer"]}" \
               "${scriptPaths["docker_remover"]}" \
               "showDevelopmentMenu" 
}