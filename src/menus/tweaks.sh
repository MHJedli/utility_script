#!/usr/bin/env bash
source $(pwd)/src/utils.sh

showSystemTweaksMenu(){
    log_message "INFO" "Displaying System Tweaks Menu"
    OPTION=$(whiptail --title "System Tweaks Menu" --menu "Choose an option" 30 80 16 \
    "PipeWire" "Install the Modern Sound System For Better Sound Quality" \
    "Keyboard RGB Backlight" "Fix Your RGB Backlight for Your Gaming PC" \
    "Spotify" "Install the Famous Streaming Platform" \
    "Wine" "Be able to Run Windows Apps on Your Linux Machine" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $OPTION in
        "PipeWire Sound System")
            log_message "INFO" "User chose PipeWire Sound System Menu"
            showPipeWireMenu
            ;;
        "Keyboard RGB Backlight")
            log_message "INFO" "User chose Keyboard RGB Backlight Menu"
            showFixKeyboardRGB
            ;;
        "Spotify")
            log_message "INFO" "User chose Spotify Menu"
            showSpotifyMenu
            ;;
        "Wine")
            log_message "INFO" "User chose Wine Menu"
            showWineMenu
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

showPipeWireMenu(){
    optionMenu "PipeWire Sound System" \
       "${scriptPaths["pipewire_installer"]}" \
       "" \
       "showSystemTweaksMenu"
}

showFixKeyboardRGB(){
    optionMenu "Fix Keyboard RGB Backlight" \
       "${scriptPaths["keyboard_rgb_fix_installer"]}" \
       "${scriptPaths["keyboard_rgb_fix_remover"]}" \
       "showSystemTweaksMenu"
}

showSpotifyMenu(){
    optionMenu "Spotify + Ad Blocker" \
       "${scriptPaths["spotify_installer"]}" \
       "${scriptPaths["spotify_remover"]}" \
       "showSystemTweaksMenu"
}

showWineMenu(){
    optionMenu "Wine" \
       "${scriptPaths["wine_installer"]}" \
       "${scriptPaths["wine_remover"]}" \
       "showSystemTweaksMenu"    
}