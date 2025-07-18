#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
SCRIPTS_PATH="${DIRECTORY_PATH}/src/scripts/scripts_path.sh"
source "$UTILS"
source "$SCRIPTS_PATH"

show_ai_menu(){
    log_message "INFO" "Displaying AI Menu"
    local option=$(whiptail --title "AI Menu" --menu "Choose an option" $HEIGHT $WIDTH 3 \
    "Frameworks" "Install Libraries like Pytorch and Tensorflow" \
    "Tools" "Install Python package managers and Web-Based notebooks" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Frameworks")
            log_message "INFO" "User chose Frameworks Menu"
            show_frameworks_menu
            ;;
        "Tools")
            log_message "INFO" "User chose Tools Menu"
            show_tools_menu
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

# Frameworks Menu
show_frameworks_menu(){
    log_message "INFO" "Displaying Frameworks Menu"
    local option=$(whiptail --title "Frameworks Menu" --menu "Choose an option" $HEIGHT $WIDTH 3 \
    "Pytorch" "Optimized Tensor Library for Deep Learning" \
    "TensorFlow" "Platform for creating and deploying ML Models" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Pytorch")
            log_message "INFO" "User chose Pytorch Menu"
            show_pytorch_menu
            ;;
        "TensorFlow")
            log_message "INFO" "User chose Tensorflow Menu"
            show_tensorflow_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to AI Menu"
            show_ai_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac    
}

show_pytorch_menu(){
    options_menu "PyTorch" \
                   "${scriptPaths["pytorch_installer"]}" \
                   "" \
                   "show_frameworks_menu"
}

show_tensorflow_menu(){
    options_menu "Tensor Flow" \
               "${scriptPaths["tensorflow_installer"]}" \
               "" \
               "show_frameworks_menu"
}

# Tools Menu
show_tools_menu(){
    log_message "INFO" "Displaying Tools Menu"
    local option=$(whiptail --title "Tools Menu" --menu "Choose an option" $HEIGHT $WIDTH 3 \
    "Conda" "Package and Environment Manager for Python and other Languages" \
    "Jupyter" "Web-based interactive computing platform" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Conda")
            log_message "INFO" "User chose Conda Menu"
            show_conda_menu
            ;;
        "Jupyter")
            log_message "INFO" "User chose Jupyter Menu"
            show_jupyter_menu
            ;;
        "<-- Back")
            log_message "INFO" "User chose to return to AI Menu"
            show_ai_menu
            ;;
        *)
            echo "Ending Utility Script GUI Execution at $(date)" >> "$LOG_FILE"
            echo "Exiting..."
            exit 0
            ;;
    esac
}

show_conda_menu(){
    options_menu "Conda" \
               "${scriptPaths["conda_installer"]}" \
               "${scriptPaths["conda_remover"]}" \
               "show_tools_menu"
}

show_jupyter_menu(){
    options_menu "Jupyter" \
                   "${scriptPaths["jupyter_installer"]}" \
                   "" \
                   "show_tools_menu"
}


# Begin AI Menu
show_ai_menu
# End AI Menu