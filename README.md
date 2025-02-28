# My Utility Script :
*  A TUI script that helps you install development tools depending on your use case.
*  This script is meant for Ubuntu or Ubuntu-based and Fedora or Fedora-based users.
<br><br>
*  Current Script Directory Structure :
```
.
└── src
    ├── menus
    └── scripts
        ├── ai
        ├── dev
        ├── drivers
        └── tweaks

```
*  src : Directory for storing ressources <br>
*  src/menus : Directory for menus definition <br>
*  src/scripts : Directory for Installers Scripts related to each menu <br>
<br><br>
*  Available Scripts :
```
scripts
├── ai
|   ├── pytorch
|   |      └── pytorch_installer
|   ├── tensorflow
|   |      └── tensorflow_installer
|   └── conda
|          ├── conda_installer
|          └── conda_remover
├── dev
│   ├── android_studio
|   |      └── android_studio_installer
│   ├── angular
|   |      └── angular_installer
|   ├── oracle_vm
|   |      └── oracle_vm_installer
│   ├── flutter
|   |      └── flutter_installer
|   └── docker
|          ├── docker_installer
|          └── docker_remover
├── drivers
│    ├── cuda_installer
|    |     ├── cuda_installer
|    |     └── cuda_switcher
│    └── nvidia
|          ├── nvidia_driver_installer
|          └── nvidia_driver_remover
├── tweaks 
|    ├── keyboard_rgb_fix
|    |     ├── keyboard_rgb_fix_installer
|    |     └── keyboard_rgb_fix_remover
|    ├── spotify
|    |     ├── spotify_installer
|    |     └── spotify_remover
|    ├── pipewire
|    |     └── pipewire_installer
|    └── wine
|          ├── wine_installer
|          └── wine_remover
└── utilities
     ├── ide
     |     ├── intellij_idea_community
     |     |      ├── intellij_idea_community_installer
     |     |      └── intellij_idea_community_remover
     |     └── pycharm_community
     |            ├── pycharm_community_installer
     |            └── pycharm_community_remover
     |
     ├── office
     |     ├── libre_office
     |     |      ├── libre_office_installer
     |     |      └── libre_office_remover
     |     └── only_office
     |            ├── only_office_installer
     |            └── only_office_remover
     |
     └── vscode
            ├── vscode_installer
            └── vscode_remover
```
>[!note]
> Current available scripts for Fedora or Fedora-Based Distributions :
> - AI Scripts
> - Drivers Scripts
> - Angular
> - Oracle VM
> - Flutter
> - Docker
> - VS Code

<br>
*  Screenshots of the script :
<br><br>

![Screenshot from 2025-01-17 11-44-22](https://github.com/user-attachments/assets/b4ce1b03-07fe-4a16-a83f-d9069c36a017)

![Screenshot from 2025-01-17 11-44-38](https://github.com/user-attachments/assets/1252381a-6212-4060-a07a-548dd36af81c)

![Screenshot from 2025-01-17 11-44-45](https://github.com/user-attachments/assets/0b63d747-d847-45b5-a849-3b33ff8896a4)

![Screenshot from 2025-01-17 11-44-54](https://github.com/user-attachments/assets/c1ce9227-fe46-46af-8147-c0ed16cfc16f)

![Screenshot from 2025-01-17 11-45-02](https://github.com/user-attachments/assets/63690e1a-ab58-41cc-984e-595cb062ca24)

<br>
* DEMO :<br>

Live Script Installation of Conda on Ubuntu 24.04 :
  

https://github.com/user-attachments/assets/cb23403f-8ee3-49e7-bf38-89c38ffed16d




To run the script :
<pre>
    $ git clone https://github.com/MHJedli/utility_script.git
    $ cd utility_script/
    $ chmod +x utility_script.sh
    $ ./utility_script.sh (Recommended) 
    or
    $ bash utility_script.sh
</pre>

> [!NOTE]
> The script is improving by time. Expect new features in the future.
