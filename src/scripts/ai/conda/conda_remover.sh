#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Conda Removal at $(date)" >> "$LOG_FILE"

local option=$(whiptail --title "Conda Remover" --menu "What do you Want to Remove ?" 30 80 2 \
"Miniconda" "" \
"Anaconda" "" \
3>&1 1>&2 2>&3)

case $option in
    "Miniconda")
            log_message "INFO" "Searching for Miniconda"
            printc "YELLOW" "-> Searching for Miniconda..."
            minicondaPath=$(find $HOME -type d -iname "miniconda*")

            if [[ "$minicondaPath" == "" ]]; then

                log_message "INFO" "No Miniconda Installation Found !"
                print_msgbox "WARNING !" "No Miniconda Installation Found !"

            else 

                log_message "INFO" "Found Miniconda Installation"
                printc "GREEN" "Found :"
                echo $minicondaPath  
                echo -n "Press [ENTER] to Continue..."
                read
                log_message "INFO" "Deleting Miniconda"
                printc "YELLOW" "-> Deleting Miniconda..."
                rm -rf $minicondaPath

                log_message "INFO" "Miniconda Deleted Successfully"
                print_msgbox "Success !" "Miniconda Deleted Successfully
                Close and Re-open the Terminal For Changes to be Taken !"

            fi
        ;;
    "Anaconda")
            log_message "INFO" "Searching for Anaconda"
            printc "YELLOW" "-> Searching for Anaconda..."
            anacondaPath=$(find $HOME -type d -iname "anaconda*")

            if [[ "$anacondaPath" == "" ]]; then

                log_message "INFO" "No Anaconda Installation Found"
                print_msgbox "WARNING !" "No Anaconda Installation Found !"

            else
                log_message "INFO" "Found Anaconda Installation"
                printc "GREEN" "Found : "
                echo $anacondaPath
                echo -n "Press [ENTER] to Continue..."
                read

                log_message "INFO" "Deleting Anaconda"
                printc "YELLOW" "-> Deleting Anaconda..."
                rm -rf $anacondaPath

                log_message "INFO" "Anaconda Deleted Successfully"
                print_msgbox "Success !" "Anaconda Deleted Successfully
                Close and Re-open the Terminal For Changes to be Taken !"

            fi
        ;;
    *)
        handle_error "User chose to exit Script"
        ;;
esac