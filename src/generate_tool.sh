#!/usr/bin/env bash

generate_installer_file(){
local installer_target_file=$1
local tool_name=$2

cat > "$installer_target_file" <<EOF
#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=\$(pwd)
UTILS="\${DIRECTORY_PATH}/src/utils.sh"
source "\$UTILS"

LOG_FILE="\${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_for_ubuntu_or_based(){
    echo "To be implemented: Install ${tool_name} for Ubuntu or based distributions"
}

install_for_fedora_or_based(){
    
    echo "To be implemented: Install ${tool_name} for Fedora or based distributions"
}

# Begin ${tool_name} Installation
echo "Continue script execution in ${tool_name} Installation at \$(date)" >> "\$LOG_FILE"

log_message "INFO" "Installing ${tool_name} for \${DISTRIBUTION_NAME}"
printc "GREEN" "Installing ${tool_name} for \${DISTRIBUTION_NAME}..."

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."

if check_internet; then
    log_message "INFO" "Internet Connection Detected. Proceeding with ${tool_name} Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with ${tool_name} Installation..."

    if [[ "\$DISTRIBUTION" == "ubuntu" || -n "\$UBUNTU_BASE" ]]; then
        install_for_ubuntu_or_based
    elif [[ "\$DISTRIBUTION" == "fedora" || -n "\$FEDORA_BASE" ]]; then
        install_for_fedora_or_based
    else
        handle_error "Unsupported distribution: \${DISTRIBUTION}"
    fi

    echo "Script Execution in ${tool_name} Installation Ended Successfully at \$(date)" >> "\$LOG_FILE"
    print_msgbox "Success !" "${tool_name} Installed Successfully"
else
    handle_error "No Connection Available ! Exiting..."
fi
# End ${tool_name} Installation
EOF

chmod +x "$installer_target_file"
echo "Installer template created at $installer_target_file"
}

generate_remover_file(){
local remover_target_file=$1
local tool_name=$2

cat > "$remover_target_file" <<EOF
#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=\$(pwd)
UTILS="\${DIRECTORY_PATH}/src/utils.sh"
source "\$UTILS"
    
LOG_FILE="\${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

remove_for_ubuntu_or_based(){
    echo "To be implemented: Remove ${tool_name} for Ubuntu or based distributions"
}

remove_for_fedora_or_based(){
    echo "To be implemented: Remove ${tool_name} for Fedora or based distributions"
}

# Begin ${tool_name} Removal
if ! command -v <TOOL_NAME_COMMAND> &> /dev/null; then

    log_message "INFO" "${tool_name} is not installed. Exiting..."
    printc "RED" "${tool_name} is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "${tool_name} is installed. Continue..."
    printc "GREEN" "-> ${tool_name} is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing ${tool_name} for \${DISTRIBUTION_NAME}"
    printc "YELLOW" "-> Removing ${tool_name} for \${DISTRIBUTION_NAME}..."
    if [[ "\$DISTRIBUTION" == "ubuntu" || -n "\$UBUNTU_BASE" ]]; then
        remove_for_ubuntu_or_based
    elif [[ "\$DISTRIBUTION" == "fedora" || -n "\$FEDORA_BASE" ]]; then
        remove_for_fedora_or_based
    else
        handle_error "Unsupported distribution: \${DISTRIBUTION}"
    fi


    echo "${tool_name} Remover Script Execution Completed Successfully at \$(date)" >> "\$LOG_FILE"
    print_msgbox "Success !" "${tool_name} Removed Successfully"

fi
# End ${tool_name} Removal
EOF

chmod +x "$remover_target_file"
echo "-> Remover template created at ${remover_target_file}"
}

main(){
    cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    for TOOL_NAME in "$@"; do
        local lowercase_tool_name=$(echo "$TOOL_NAME" | tr '[:upper:]' '[:lower:]')
        local target_dir=$(pwd)/templates/${lowercase_tool_name}
        local installer_target_file="${target_dir}/${lowercase_tool_name}_installer.sh"
        local remover_target_file="${target_dir}/${lowercase_tool_name}_remover.sh"

        mkdir -p "$target_dir"

        generate_installer_file "$installer_target_file" "$TOOL_NAME"
        generate_remover_file "$remover_target_file" "$TOOL_NAME"

        echo "-> Installer and remover scripts for ${TOOL_NAME} have been created successfully."
        echo "-> You can now find the installer and remover scripts in the directory: ${target_dir}"
    done
}

main "$@"
