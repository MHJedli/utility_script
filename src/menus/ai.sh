#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

show_ai_menu(){
    log_message "INFO" "Displaying AI Menu"
    local option=$(whiptail --title "AI Menu" --menu "Choose an option" 30 80 16 \
    "Pytorch" "Optimized Tensor Library for Deep Learning" \
    "Conda" "Package and Environment Manager for Python and other Languages" \
    "TensorFlow" "Platform for creating and deploying ML Models" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $option in
        "Pytorch")
            log_message "INFO" "User chose Pytorch Menu"
            show_pytorch_menu
            ;;
        "Conda")
            log_message "INFO" "User chose Conda Menu"
            show_conda_menu
            ;;
        "TensorFlow")
            log_message "INFO" "User chose Tensorflow Menu"
            show_tensorflow_menu
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

show_pytorch_menu(){
    options_menu "PyTorch" \
                   "${scriptPaths["pytorch_installer"]}" \
                   "" \
                   "show_ai_menu"
}

show_conda_menu(){
    options_menu "Conda" \
               "${scriptPaths["conda_installer"]}" \
               "${scriptPaths["conda_remover"]}" \
               "show_ai_menu"
}

show_tensorflow_menu(){
    options_menu "Tensor Flow" \
               "${scriptPaths["tensorflow_installer"]}" \
               "" \
               "show_ai_menu"
}