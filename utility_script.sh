#!/bin/bash

# External Functions
source src/utils.sh

# LOG File
LOG_FILE=src/logfile.log

# Initialize log file
echo "Starting script execution at $(date)" > "$LOG_FILE"

show

# Show Development Menu
showDevelopmentMenu(){
    clear
    log_message "INFO" "Displaying Development Menu"
    echo "--------------------------------------"
    echo "          Development Menu            "
    echo "--------------------------------------"
    echo '1. Install Angular CLI'
    echo '2. Install Android Studio'
    echo '3. Return to Previous Menu'
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Main Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install Angular CLI"
            ;;
        2)
            log_message "INFO" "User chose to Install Android Studio"
            ;;
        3)
            log_message "INFO" "User chose To Return to Main Menu"
            showMainMenu
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showDevelopmentMenu
            ;;
    esac
}

# Show AI Menu
showAIMenu(){
    clear
    log_message "INFO" "Displaying AI Menu"
    echo "--------------------------------------"
    echo "               AI Menu                "
    echo "--------------------------------------"
    echo '1. Install PyTorch'
    echo '2. Install Conda'
    echo '3. Install TensorFlow'
    echo '4. Return to Previous Menu'
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Main Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install PyTorch"
            ;;
        2)
            log_message "INFO" "User chose to Install Conda"
            ;;
        3)
            log_message "INFO" "User chose To Install TensorFlow"
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

# Show System Tweaks Menu
showSystemTweaksMenu(){
    clear
    log_message "INFO" "Displaying System Tweaks Menu"
    echo "--------------------------------------"
    echo "         System Tweaks Menu           "
    echo "--------------------------------------"
    echo '1. Install NVIDIA Drivers'
    echo '2. Install PipeWire Sound System'
    echo '3. Fix Keyboard RGB backlight'
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Main Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install PyTorch"
            ;;
        2)
            log_message "INFO" "User chose to Install Conda"
            ;;
        3)
            log_message "INFO" "User chose To Install TensorFlow"
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

# Show Main Menu
showMainMenu(){
    clear
    log_message "INFO" "Displaying Main Menu"
    echo "--------------------------------------"
    echo "         Linux Utility Menu           "
    echo "--------------------------------------"
    echo '1. Development'
    echo '2. AI'
    echo '3. System Tweaks'
    echo 'q. Quit'
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Main Menu"

    case $option in
        1)
            log_message "INFO" "User chose Development"
            showDevelopmentMenu
            ;;
        2)
            log_message "INFO" "User chose AI"
            showAIMenu
            ;;
        3)
            log_message "INFO" "User chose System Tweaks"
            showSystemTweaksMenu
            ;;
        q)
            log_message "INFO" "User chose to quit"
            exit 1
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showMainMenu
            ;;
    esac
}

showMainMenu