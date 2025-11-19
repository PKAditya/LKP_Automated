# LKP_Automated

## Overview
This tool helps you to install and execute the LKP(Linux Kernel Performance) jobs.

These jobs selectively include:
    1. Hackbench
    2. Ebizzy
    3. Unixbench

## Getting Started

### Pre-Requisites
Ensure you have 'git' and 'make' installed on your system.

> [!NOTE]
> Always run this script with Super User priviledges.

### Installation & Usage 

1. Clone the Repository:
```bash
    $ git clone https://github.com/PKAditya/LKP_Automated.git
    $ cd LKP_Automated
```

2. Run the setup:
```bash
    $ sudo make
```

3. Select the relevant option:
```
    Option "1" : Install and run LKP jobs
    Option "2" : Install LKP jobs
```

Once you run the setup step, when you select the option 1 it will create a service file.

### Managing the service

1. To temporarily stop the service
```bash
    $ sudo systemctl stop auto_lkp.service
```

2. To permanently disable the service
```bash
    $ sudo systemctl disable auto_lkp.service
```

### supported systems:

Current version of this script only supports limited number of distros, these include

- Ubuntu
- Velinux
- Centos
- Euler
- Anolis
- CloudOS
- Rocky Linux
- Oracle
- Redhat
- Arch Linux

In case of support needed please contact the author of this script.