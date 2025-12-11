#!/usr/bin/env bash

# External Functions/Files
DIRECTORY_PATH=$(pwd)
UTILS="${DIRECTORY_PATH}/src/utils.sh"
source "$UTILS"

LOG_FILE="${DIRECTORY_PATH}/src/logfile.log"

trap 'handle_error "An unexpected error occurred."' ERR
clear

install_quantum_espresso(){

    log_message "INFO" "Retrieving Available Versions Of Quantum Espresso"
    printc "YELLOW" "-> Retrieving Available Versions Of Quantum Espresso..."
    local qe_versions=()
    mapfile -t qe_versions <<< $(curl -s "https://gitlab.com/api/v4/projects/QEF%2Fq-e/repository/tags" | jq -r '.[].name' | grep "^qe-" | sed 's/^qe-//' | sed 's/-.*//' | sort -r | uniq)

    local qe_versions_list_options=()
    for version in "${qe_versions[@]}"; do
        qe_versions_list_options+=("$version" "")
    done
    
    SELECTED_QE_VERSION=$(whiptail --title "Select The Version of Quantum Espresso To Install :" --menu "Select a version" $HEIGHT $WIDTH 5 "${qe_versions_list_options[@]}" 3>&1 1>&2 2>&3)

    if [[ $? -ne 0 ]]; then
        handle_error "No option selected. Exiting..."
    fi

    log_message "INFO" "Downloading Quantum Espresso Version ${SELECTED_QE_VERSION}"
    printc "YELLOW" "-> Downloading Quantum Espresso Version ${SELECTED_QE_VERSION}..."
    local download_qe_link="https://gitlab.com/QEF/q-e/-/archive/qe-${SELECTED_QE_VERSION}/q-e-qe-${SELECTED_QE_VERSION}.zip"
    local download_qe_path=$DIRECTORY_PATH/tmp
    wget -c -P "$download_qe_path/" "$download_qe_link" || handle_error "Error while downloading Quantum Espresso Version ${SELECTED_QE_VERSION}"

    log_message "INFO" "Extracting Quantum Espresso Version ${SELECTED_QE_VERSION}"
    printc "YELLOW" "-> Extracting Quantum Espresso Version ${SELECTED_QE_VERSION}..."
    unzip -d $HOME $DIRECTORY_PATH/tmp/q-e-qe-${SELECTED_QE_VERSION}.zip || handle_error "Error while extracting Quantum Espresso Version ${SELECTED_QE_VERSION}"
    cd $HOME/q-e-qe-${SELECTED_QE_VERSION}

    log_message "INFO" "Configuring Quantum Espresso Version ${SELECTED_QE_VERSION} Installation"
    printc "YELLOW" "-> Configuring Quantum Espresso Version ${SELECTED_QE_VERSION} Installation..."
    local intelmkl_version=$(basename $(find /opt/intel/oneapi/mkl -maxdepth 1 -type d -name '20*' -print -quit))
    ./configure --with-scalapack=intel \
                BLAS_LIBS="-lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_lp64 -liomp5 -lpthread -lifcore -lm -ldl" \
                LAPACK_LIBS="-lmkl_scalapack_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_lp64 -liomp5 -lpthread -lifcore -lm -ldl" \
                SCALAPACK_LIBS="-lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64" \
                FFT_LIBS="-lfftw3" \
                FFT_INCLUDE="/usr/include" \
                LIBDIRS="/usr/lib/x86_64-linux-gnu /opt/intel/oneapi/mkl/${intelmkl_version}/lib/intel64" || handle_error "Error while configuring Quantum Espresso Version ${SELECTED_QE_VERSION} Installation"
    sed -i 's/^DFLAGS *=/DFLAGS = -D__FFTW /' make.inc
    sudo ldconfig

    log_message "INFO" "Compiling Quantum Espresso Version ${SELECTED_QE_VERSION}"
    printc "YELLOW" "-> Compiling Quantum Espresso Version ${SELECTED_QE_VERSION}..."
    make all -j$(nproc) || handle_error "Error while compiling Quantum Espresso Version ${SELECTED_QE_VERSION}"

    log_message "INFO" "Adding Quantum Espresso Version ${SELECTED_QE_VERSION} to PATH"
    printc "YELLOW" "-> Adding Quantum Espresso Version ${SELECTED_QE_VERSION} to PATH..."
    echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.bashrc

}

install_gipaw(){

    log_message "INFO" "Downloading GIPAW v${SELECTED_QE_VERSION}"
    printc "YELLOW" "-> Downloading GIPAW v${SELECTED_QE_VERSION}..."
    local download_gipaw_link="https://github.com/dceresoli/qe-gipaw/releases/download/${SELECTED_QE_VERSION}/qe-gipaw-${SELECTED_QE_VERSION}.tar.bz2"
    local download_gipaw_path=$DIRECTORY_PATH/tmp
    wget -c -P "$download_gipaw_path/" "$download_gipaw_link"

    log_message "INFO" "Installing GIPAW v${SELECTED_QE_VERSION}"
    printc "YELLOW" "-> Installing GIPAW v${SELECTED_QE_VERSION}..."
    tar -xf $DIRECTORY_PATH/tmp/qe-gipaw-${SELECTED_QE_VERSION}.tar.bz2 -C $HOME
    cd $HOME/qe-gipaw-${SELECTED_QE_VERSION}
    ./configure --with-qe-source="../q-e-qe-${SELECTED_QE_VERSION}" || handle_error "Error while configuring GIPAW Installation"
    make all -j$(nproc) || handle_error "Error while compiling GIPAW"
    
    printc "YELLOW" "-> Adding GIPAW to PATH..."
    echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.bashrc

}

# Begin Quantum Espresso & GIPAW Installation
echo "Continue script execution in Quantum Espresso & GIPAW Installation at $(date)" >> "$LOG_FILE"

log_message "INFO" "Installing Quantum Espresso & GIPAW for ${DISTRIBUTION_NAME}"
printc "GREEN" "Installing Quantum Espresso & GIPAW for ${DISTRIBUTION_NAME}..."

print_msgbox "Important" "
Make sure you have Intel oneAPI base and HPC toolkits installed on your system.
"

log_message "INFO" "Checking for Internet Connection"
printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then
    log_message "INFO" "Internet Connection Available. Continuing..."
    printc "GREEN" "-> Internet Connection Available. Continuing..."
    
    log_message "INFO" "Verifying required packages"
    printc "YELLOW" "-> Verifying required packages..."
    verify_packages "jq" "make" "git" "unzip" "curl" "libfftw3-dev"

    install_quantum_espresso
    install_gipaw
    
    echo "Script Execution in Quantum Espresso v${SELECTED_QE_VERSION} & GIPAW Ended Successfully at $(date)" >> "$LOG_FILE"
    print_msgbox "Succes" "Quantum Espresso v${SELECTED_QE_VERSION} & GIPAW installed successfully!"
    print_msgbox "Information" "Restart your terminal to update your PATH"
    
else
    printc "RED" "No Internet Connection !"
fi
# End Quantum Espresso & GIPAW Installation
