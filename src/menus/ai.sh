#!/usr/bin/env bash
source $(pwd)/src/utils.sh

showAIMenu(){
    log_message "INFO" "Displaying AI Menu"
    OPTION=$(whiptail --title "AI Menu" --menu "Choose an option" 30 80 16 \
    "Pytorch" "Optimized Tensor Library for Deep Learning" \
    "Conda" "Package and Environment Manager for Python and other Languages" \
    "TensorFlow" "Platform for creating and deploying ML Models" \
    "<-- Back" "" \
    3>&1 1>&2 2>&3)

    case $OPTION in
        "Pytorch")
            log_message "INFO" "User chose Pytorch Menu"
            showPyTorchMenu
            ;;
        "Conda")
            log_message "INFO" "User chose Conda Menu"
            showCondaMenu
            ;;
        "TensorFlow")
            log_message "INFO" "User chose Tensorflow Menu"
            showTensorFlowMenu
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

showPyTorchMenu(){

        optionMenu "PyTorch" \
                   "${scriptPaths["pytorch_installer"]}" \
                   "" \
                   "showAIMenu"

}

showCondaMenu(){
    optionMenu "Conda" \
               "${scriptPaths["conda_installer"]}" \
               "${scriptPaths["conda_remover"]}" \
               "showAIMenu"
}

showTensorFlowMenu(){

    optionMenu "Tensor Flow" \
               "${scriptPaths["tensorflow_installer"]}" \
               "" \
               "showAIMenu"
    
}