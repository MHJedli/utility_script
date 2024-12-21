#!/usr/bin/env bash
source $(pwd)/src/utils.sh

show_system_tweaks_menu(){
    log_message "INFO" "Displaying System Tweaks Menu"
    local option=$(whiptail --title "System Tweaks Menu" --menu "Choose an option" 30 80 16 \
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
            ;;
    esac
}

show_pipewire_menu(){
    options_menu "PipeWire Sound System" \
       "${scriptPaths["pipewire_installer"]}" \
       "" \
       "showSystemTweaksMenu"
}

show_fix_keyboard_rgb(){
    options_menu "Fix Keyboard RGB Backlight" \
       "${scriptPaths["keyboard_rgb_fix_installer"]}" \
       "${scriptPaths["keyboard_rgb_fix_remover"]}" \
       "showSystemTweaksMenu"
}

show_spotify_menu(){
    options_menu "Spotify + Ad Blocker" \
       "${scriptPaths["spotify_installer"]}" \
       "${scriptPaths["spotify_remover"]}" \
       "showSystemTweaksMenu"
}

show_wine_menu(){
    options_menu "Wine" \
       "${scriptPaths["wine_installer"]}" \
       "${scriptPaths["wine_remover"]}" \
       "showSystemTweaksMenu"    
}