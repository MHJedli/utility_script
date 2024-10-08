#!/bin/bash

# External Functions/Files
source $(pwd)/src/utils.sh

# Show System Tweaks Menu
showSystemTweaksMenu(){
    clear
    log_message "INFO" "Displaying System Tweaks Menu"
    showMenu \
    "         System Tweaks Menu" \
    "Install NVIDIA Drivers" \
    "Install PipeWire Sound System" \
    "Fix Keyboard RGB backlight" \
    "Return to Previous Menu"
    
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in System Tweaks Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install NVIDIA Driver"
            log_message "INFO" "Displaying NVIDIA Driver Menu"
            distroMenu "              NVIDIA Driver" \
                       "${scriptPaths["nvidia_driver_installer"]}" \
                       "showSystemTweaksMenu" \
            ;;
        2)
            log_message "INFO" "User chose to Install PipeWire Sound System"
            # showPipeWireMenu
            ;;
        3)
            log_message "INFO" "User chose To Fix Keyboard RGB Backlight"
            # showKeyboardFixMenu
            ;;
        4)
            log_message "INFO" "User chose to Return to Previous Menu"
            # showMainMenu
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showSystemTweaksMenu
            ;;
    esac
}