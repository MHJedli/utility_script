#!/bin/bash


# Function that log every step taken for easier debugging
# Parameters :
# $1 : Log Level [INFO, WARN, ERROR]
# $@ : Log Message
# Exemple :
# log_message "INFO" "Script execution started"
# log_message "ERROR" "An error occurred in the script"
log_message() {
    local LOG_LEVEL="$1"
    shift
    local MESSAGE="$@"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LOG_LEVEL] $MESSAGE" >> "$LOG_FILE"
}

# Function that handle errors
# Parameters :
# $1 : Log Message
# $? : argument that will be used with 'trap' command to catch the exit status
handle_error() {
    local exit_status=$?
    local msg="$1"
    log_message "ERROR" "$msg (Exit status: $exit_status)"
    echo "An error occurred: $msg"
    echo "Please check the log file at $LOG_FILE for more details."
    read
    exit $exit_status
}

# invalidOption print Function
invalidOption() {
    echo "No Option Selected !"
    echo "Press Enter To Continue ..."
    read
    if [ $# -gt 0 ]; then
    "$1"
    fi
}

# Function to check internet connectivity
check_internet() {
    ping -c 1 -q google.com >&/dev/null
    return $?
}