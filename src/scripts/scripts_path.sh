#!/usr/bin/env bash

SCRIPT_DIR=$(pwd)

# Script Paths
declare -A scriptPaths=(

    # Dev Scripts
    ["angular_installer"]="${SCRIPT_DIR}/src/scripts/dev/web/angular/angular_installer.sh"
    ["angular_remover"]="${SCRIPT_DIR}/src/scripts/dev/web/angular/angular_remover.sh"

    ["android_studio_installer"]="${SCRIPT_DIR}/src/scripts/dev/mobile/android_studio/android_studio_installer.sh"
    ["android_studio_remover"]="${SCRIPT_DIR}/src/scripts/dev/mobile/android_studio/android_studio_remover.sh"

    ["flutter_installer"]="${SCRIPT_DIR}/src/scripts/dev/mobile/flutter/flutter_installer.sh"
    ["flutter_remover"]="${SCRIPT_DIR}/src/scripts/dev/mobile/flutter/flutter_remover.sh"

    ["oracle_vm_installer"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/oracle_vm/oracle_vm_installer.sh"
    ["oracle_vm_remover"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/oracle_vm/oracle_vm_remover.sh"

    ["virtual_machine_manager_installer"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/virtual_machine_manager/virtual_machine_manager_installer.sh"
    ["virtual_machine_manager_remover"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/virtual_machine_manager/virtual_machine_manager_remover.sh"

    ["docker_installer"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/docker/docker_installer.sh"
    ["docker_remover"]="${SCRIPT_DIR}/src/scripts/dev/virtualization/docker/docker_remover.sh"

    # Drivers Scripts
    ["nvidia_driver_installer"]="${SCRIPT_DIR}/src/scripts/drivers/nvidia/nvidia_driver_installer.sh"
    ["nvidia_driver_remover"]="${SCRIPT_DIR}/src/scripts/drivers/nvidia/nvidia_driver_remover.sh"

    ["cuda_installer"]="${SCRIPT_DIR}/src/scripts/drivers/cuda/cuda_installer.sh"
    ["cuda_remover"]="${SCRIPT_DIR}/src/scripts/drivers/cuda/cuda_remover.sh"

    ["cuda_switcher"]="${SCRIPT_DIR}/src/scripts/drivers/cuda/cuda_switcher.sh"
    
    # AI Scripts
    ["jupyter_installer"]="${SCRIPT_DIR}/src/scripts/ai/tools/jupyter/jupyter_installer.sh"
    ["jupyter_remover"]="${SCRIPT_DIR}/src/scripts/ai/tools/jupyter/jupyter_remover.sh"

    ["conda_installer"]="${SCRIPT_DIR}/src/scripts/ai/tools/conda/conda_installer.sh"
    ["conda_remover"]="${SCRIPT_DIR}/src/scripts/ai/tools/conda/conda_remover.sh"

    ["pytorch_installer"]="${SCRIPT_DIR}/src/scripts/ai/frameworks/pytorch/pytorch_installer.sh"
    ["pytorch_remover"]="${SCRIPT_DIR}/src/scripts/ai/frameworks/pytorch/pytorch_remover.sh"

    ["tensorflow_installer"]="${SCRIPT_DIR}/src/scripts/ai/frameworks/tensorflow/tensorflow_installer.sh"
    ["tensorflow_remover"]="${SCRIPT_DIR}/src/scripts/ai/frameworks/tensorflow/tensorflow_remover.sh"

    # Tweaks Scripts
    ["pipewire_installer"]="${SCRIPT_DIR}/src/scripts/tweaks/pipewire/pipewire_installer.sh"
    ["pipewire_remover"]="${SCRIPT_DIR}/src/scripts/tweaks/pipewire/pipewire_remover.sh"

    ["keyboard_rgb_fix_installer"]="${SCRIPT_DIR}/src/scripts/tweaks/keyboard_rgb_fix/keyboard_rgb_fix_installer.sh"
    ["keyboard_rgb_fix_remover"]="${SCRIPT_DIR}/src/scripts/tweaks/keyboard_rgb_fix/keyboard_rgb_fix_remover.sh"

    ["spotify_installer"]="${SCRIPT_DIR}/src/scripts/tweaks/spotify/spotify_installer.sh"
    ["spotify_remover"]="${SCRIPT_DIR}/src/scripts/tweaks/spotify/spotify_remover.sh"

    ["wine_installer"]="${SCRIPT_DIR}/src/scripts/tweaks/wine/wine_installer.sh"
    ["wine_remover"]="${SCRIPT_DIR}/src/scripts/tweaks/wine/wine_remover.sh"

    # Utilities Scripts
    ["vscode_installer"]="${SCRIPT_DIR}/src/scripts/utilities/ide/vscode/vscode_installer.sh"
    ["vscode_remover"]="${SCRIPT_DIR}/src/scripts/utilities/ide/vscode/vscode_remover.sh"

    ["onlyoffice_installer"]="${SCRIPT_DIR}/src/scripts/utilities/office/only_office/only_office_installer.sh"
    ["onlyoffice_remover"]="${SCRIPT_DIR}/src/scripts/utilities/office/only_office/only_office_remover.sh"

    ["intellij_community_installer"]="${SCRIPT_DIR}/src/scripts/utilities/ide/intellij_idea_community/intellij_idea_community_installer.sh"
    ["intellij_community_remover"]="${SCRIPT_DIR}/src/scripts/utilities/ide/intellij_idea_community/intellij_idea_community_remover.sh"

    ["pycharm_community_installer"]="${SCRIPT_DIR}/src/scripts/utilities/ide/pycharm_community/pycharm_community_installer.sh"
    ["pycharm_community_remover"]="${SCRIPT_DIR}/src/scripts/utilities/ide/pycharm_community/pycharm_community_remover.sh"

    ["libre_office_installer"]="${SCRIPT_DIR}/src/scripts/utilities/office/libre_office/libre_office_installer.sh"
    ["libre_office_remover"]="${SCRIPT_DIR}/src/scripts/utilities/office/libre_office/libre_office_remover.sh"

)