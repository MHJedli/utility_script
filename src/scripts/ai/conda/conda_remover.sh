#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Conda Installation at $(date)" >> "$LOG_FILE"



while true; do

    printc "CYAN" "Want do you to Remove :"
    echo "1. Miniconda"
    echo "2. Anaconda"
    echo -n "Your Option : "
    read option
    
    case $option in
        1)
            printc "YELLOW" "-> Searching for Miniconda..."
            sleep 1
            sudo find $HOME -type d -iname miniconda*
            echo -n "Press [ENTER] to Continue..."
            read
            printc "YELLOW" "-> Deleting Miniconda..."
            sleep 1
            sudo find $HOME -type d -iname miniconda* -exec rm -rf {} +
            printc "GREEN" "-> Miniconda Deleted Successfully"
            echo -n "Press [ENTER] to Exit Script..."
            read
            break
            ;;
        2)
            printc "YELLOW" "-> Searching for Anaconda..."
            sleep 1
            sudo find $HOME -type d -iname anaconda
            echo -n "Press [ENTER] to Continue..."
            read
            printc "YELLOW" "-> Deleting Anaconda..."
            sleep 1
            find $HOME -type d -iname anaconda -exec rm -rf {} +
            printc "GREEN" "-> Anaconda Deleted Successfully"
            echo -n "Press [ENTER] to Exit Script..."
            read
            break
            ;;
        *)
            invalidOption
            clear
            ;;
    esac

done