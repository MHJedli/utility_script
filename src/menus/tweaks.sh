#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_system_tweaks_menu(){
    log_message "INFO" "Displaying System Tweaks Menu"
    local option=$(whiptail --title "System Tweaks Menu" --menu "Choose an option" $HEIGHT $WIDTH 5 \
    "PipeWire" "Install the Modern Sound System For Better Sound Quality" \
    "Keyboard RGB Backlight" "Fix Your RGB Backlight for Your Gaming PC" \
    "Spotify" "Install the Famous Streaming Platform" \
    "Wine" "Be able to Run Windows Apps on Your Linux Machine" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "PipeWire Sound System")
            log_message "INFO" "User chose PipeWire Sound System Menu"
            show_pipewire_menu
            ;;
        "Keyboard RGB Backlight")
            log_message "INFO" "User chose Keyboard RGB Backlight Menu"
            show_fix_keyboard_rgb
            ;;
        "Spotify")
            log_message "INFO" "User chose Spotify Menu"
            show_spotify_menu
            ;;
        "Wine")
            log_message "INFO" "User chose Wine Menu"
            show_wine_menu
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

show_pipewire_menu(){
    options_menu "PipeWire Sound System" \
       "${scriptPaths["pipewire_installer"]}" \
       "" \
       "show_system_tweaks_menu"
}

show_fix_keyboard_rgb(){
    options_menu "Fix Keyboard RGB Backlight" \
       "${scriptPaths["keyboard_rgb_fix_installer"]}" \
       "${scriptPaths["keyboard_rgb_fix_remover"]}" \
       "show_system_tweaks_menu"
}

show_spotify_menu(){
    options_menu "Spotify + Ad Blocker" \
       "${scriptPaths["spotify_installer"]}" \
       "${scriptPaths["spotify_remover"]}" \
       "show_system_tweaks_menu"
}

show_wine_menu(){
    options_menu "Wine" \
       "${scriptPaths["wine_installer"]}" \
       "${scriptPaths["wine_remover"]}" \
       "show_system_tweaks_menu"    
}

# Begin System Tweaks Menu
show_system_tweaks_menu
# End System Tweaks Menu