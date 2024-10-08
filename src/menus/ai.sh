#!/bin/bash

# External Functions/Files
source $(pwd)/src/utils.sh

# Show AI Menu
showAIMenu(){
    clear
    log_message "INFO" "Displaying AI Menu"
    showMenu \
    "              AI Menu" \
    "Install PyTorch" \
    "Install Conda" \
    "Install TensorFlow" \
    "Return to Previous Menu" 
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in AI Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install PyTorch"
            showPyTorchMenu
            ;;
        2)
            log_message "INFO" "User chose to Install Conda"
            showCondaMenu
            ;;
        3)
            log_message "INFO" "User chose To Install TensorFlow"
            showTensorFlowMenu
            ;;
        4)
            log_message "INFO" "User chose to Return to Previous Menu"
            showMainMenu
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showAIMenu
            ;;
    esac
}

showPyTorchMenu(){

}

showCondaMenu(){

}

showTensorFlowMenu(){
    
}