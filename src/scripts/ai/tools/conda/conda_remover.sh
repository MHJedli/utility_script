#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"
    
LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

# Begin Conda Removal
echo "Continue script execution in Conda Removal at $(date)" >> "$LOG_FILE"

log_message "YELLOW" "Showing Conda Remover Menu"
OPTIONS_LIST=$(whiptail --title "Conda Remover" --menu "What do you Want to Remove ?" $HEIGHT $WIDTH 2 \
"Miniconda" "" \
"Anaconda" "" \
3>&1 1>&2 2>&3)

case $OPTIONS_LIST in
    "Miniconda")
            log_message "INFO" "Searching for Miniconda"
            printc "YELLOW" "-> Searching for Miniconda..."
            MINICONDA_PATH=$(find $HOME -type d -iname "miniconda*")

            if [[ -z "$MINICONDA_PATH" ]]; then

                log_message "INFO" "No Miniconda Installation Found !"
                print_msgbox "WARNING !" "No Miniconda Installation Found !"

            else 

                log_message "INFO" "Found Miniconda Installation"
                printc "GREEN" "Found :"
                echo "$MINICONDA_PATH"  
                echo -n "Press [ENTER] to Continue..."
                read

                log_message "INFO" "Deleting Miniconda"
                printc "YELLOW" "-> Deleting Miniconda..."
                rm -rf "$MINICONDA_PATH"

                log_message "INFO" "Miniconda Deleted Successfully"
                print_msgbox "Success !" "Miniconda Deleted Successfully
                Close and Re-open the Terminal For Changes to be Taken !"

            fi
        ;;
    "Anaconda")
            log_message "INFO" "Searching for Anaconda"
            printc "YELLOW" "-> Searching for Anaconda..."
            ANACONDA_PATH=$(find $HOME -type d -iname "anaconda*")

            if [[ -z "$ANACONDA_PATH" ]]; then

                log_message "INFO" "No Anaconda Installation Found"
                print_msgbox "WARNING !" "No Anaconda Installation Found !"

            else
                log_message "INFO" "Found Anaconda Installation"
                printc "GREEN" "Found : "
                echo "$ANACONDA_PATH"
                echo -n "Press [ENTER] to Continue..."
                read

                log_message "INFO" "Deleting Anaconda"
                printc "YELLOW" "-> Deleting Anaconda..."
                rm -rf "$ANACONDA_PATH"

                log_message "INFO" "Anaconda Deleted Successfully"
                print_msgbox "Success !" "Anaconda Deleted Successfully
                Close and Re-open the Terminal For Changes to be Taken !"

            fi
        ;;
    *)
        handle_error "User chose to exit Script"
        ;;
esac
# End Conda Removal