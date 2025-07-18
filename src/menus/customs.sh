#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_customs_menu(){
    log_message "INFO" "Displaying Customs Menu"
    local option=$(whiptail --title "Customs Menu" --menu "Choose an option" $HEIGHT $WIDTH 2 \
    "Theme Script" "Style your system with custom themes" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Theme Script")
            log_message "INFO" "User chose Theme Script"
            setup_theme_script
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

setup_theme_script(){
    log_message "INFO" "Creating Temporary Directory"
    printc "YELLOW" "-> Creating Temporary Directory..."
    if [[ ! -d "${DIRECTORY_PATH}/tmp" ]]; then
        mkdir -p "${DIRECTORY_PATH}/tmp" || handle_error "Failed to create temporary directory"
    fi

    log_message "INFO" "Cloning Theme Script Repository"
    printc "YELLOW" "-> Cloning Theme Script Repository..."
    if [[ -d "${DIRECTORY_PATH}/tmp/theme_script" ]]; then
        rm -rf "${DIRECTORY_PATH}/tmp/theme_script" || handle_error "Failed to remove existing Theme Script directory"
    fi
    git clone https://github.com/MHJedli/theme_script.git "${DIRECTORY_PATH}/tmp/theme_script" || handle_error "Failed to clone Theme Script repository"

    
    log_message "INFO" "Changing Directory to Theme Script"
    printc "YELLOW" "-> Changing Directory to Theme Script..."
    cd "${DIRECTORY_PATH}/tmp/theme_script" || handle_error "Failed to change directory to Theme Script"

    log_message "INFO" "Running Theme Script"
    printc "YELLOW" "-> Running Theme Script..."
    chmod +x theme_script.sh || handle_error "Failed to make Theme Script executable"
    . theme_script.sh || handle_error "Failed to execute Theme Script"
}

# Begin Customs Menu
show_customs_menu
# End Customs Menu