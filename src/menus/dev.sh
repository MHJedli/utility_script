#!/usr/bin/env bash
source $(pwd)/src/utils.sh

showDevelopmentMenu(){
    log_message "INFO" "Displaying Development Menu"
    OPTION=$(whiptail --title "Development Menu" --menu "Choose an option" 30 80 16 \
    "Angular CLI" "Used for FrontEnd Development" \
    "Android Studio" "Used for Mobile Development" \
    "Flutter SDK" "Used for Cross-Platform Developement" \
    "Oracle VirtualBox" "Used for Virtualization Purposes" \
    "Docker" "Used for Managing Containers" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $OPTION in
        "Angular CLI")
            log_message "INFO" "User chose Angular Menu"
            showAngularMenu
            ;;
        "Android Studio")
            log_message "INFO" "User chose Android Studio Menu"
            showAndroidStudioMenu
            ;;
        "Flutter SDK")
            log_message "INFO" "User chose Flutter SDK Menu"
            showFlutterMenu
            ;;
        "Oracle VirtualBox")
            log_message "INFO" "User chose Oracle VirtualBox Menu"
            showVirtualBoxMenu
            ;;
        "Docker")
            log_message "INFO" "User chose Docker Menu"
            showDockerMenu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to Main Menu"
            showMainMenu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            ;;
    esac
}

showAngularMenu(){
    optionMenu "Angular" \
               "${scriptPaths["angular_installer"]}" \
               "" \
               "showDevelopmentMenu"
}

showAndroidStudioMenu(){
    optionMenu "Android Studio" \
               "${scriptPaths["android_studio_installer"]}" \
               "" \
               "showDevelopmentMenu"

}

showFlutterMenu(){
    optionMenu "Flutter" \
               "${scriptPaths["flutter_installer"]}" \
               "" \
               "showDevelopmentMenu"   
}
showVirtualBoxMenu(){
    optionMenu "Oracle VirtualBox" \
               "${scriptPaths["oracle_vm_installer"]}" \
               "" \
               "showDevelopmentMenu"    
}
showDockerMenu(){
    optionMenu "Docker" \
               "${scriptPaths["docker_installer"]}" \
               "${scriptPaths["docker_remover"]}" \
               "showDevelopmentMenu" 
}