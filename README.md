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
|   ├── frameworks
|   |      ├── pytorch
|   |      └── tensorflow
|   └── tools
|          ├── conda
|          └── jupyter
├── dev    
|   ├── mobile
|   |      ├── android_studio
|   |      ├── waydroid
|   |      └── flutter
│   ├── virtualization       
|   |       ├── oracle_vm
|   |       ├── virtual_machine_manager
|   |       └── docker
|   └── web
|          ├── angular
|          └── mongodb
├── drivers
│    ├── cuda
|    |     ├── cuda_installer
|    |     └── cuda_switcher
│    └── nvidia
├── tweaks 
|    ├── keyboard_rgb_fix
|    ├── spotify
|    ├── pipewire
|    └── wine
└── utilities
     ├── ide
     |     ├── intellij_idea_community
     |     ├── pycharm_community
     |     └── vscode
     └── office
           ├── libre_office
           └── only_office
```
>[!note]
> Current available scripts for Fedora or Fedora-Based Distributions :
> - AI Scripts
> - Drivers Scripts
> - Angular
> - MongoDB
> - Oracle VM
> - Flutter
> - Docker
> - VS Code
> - Wine
> - Waydroid

>[!note]
> - The script can work in interactive and non-interactive mode
> - Meaning, you can be guided to install your application by following the GUI menus
> - or you can install them or delete them directly using the command line

<br>
*  Screenshots of the script :
<br><br>

![Screenshot From 2025-05-01 20-27-05](https://github.com/user-attachments/assets/8df02abd-d437-4532-a6c3-a43f2cf7eda9)

![Screenshot From 2025-05-01 20-27-13](https://github.com/user-attachments/assets/b975ebe4-96e1-413d-8bab-1aaa7225222b)

![Screenshot From 2025-05-01 20-27-25](https://github.com/user-attachments/assets/e3a70ad0-c07c-40eb-a38f-698e411a9cce)

![Screenshot From 2025-05-01 20-27-39](https://github.com/user-attachments/assets/482061e3-2cb6-41d9-a817-68dbc8e42219)

![Screenshot From 2025-05-01 20-28-25](https://github.com/user-attachments/assets/7e86f960-f635-43b8-b3fa-ee365c9d6527)


<br>
* DEMO :<br>

Live Script Installation of Conda on Ubuntu 24.04 :
  

https://github.com/user-attachments/assets/cb23403f-8ee3-49e7-bf38-89c38ffed16d




To run the script :
<pre>
    $ git clone https://github.com/MHJedli/utility_script.git
    $ cd utility_script/
    $ chmod +x utility_script.sh
    $ ./utility_script.sh (it uses the interactive mode by default)
</pre>
Example of the non-interactive use :
![Screenshot from 2025-05-01 20-22-48](https://github.com/user-attachments/assets/7d647d73-f90b-4cb8-883c-d225f03e1356)


> [!NOTE]
> The script is improving by time. Expect new features in the future.
