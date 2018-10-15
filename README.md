# AlpineWSL

Alpine Linux on WSL (Windows 10 FCU or later)
based on [wsldl](https://github.com/yuk7/wsldl)
but adds the following capabilities:

* Git-LFS (Allows for files over 4GB that Windows OS has limited)
* Sphinx and multiple supporting packages like PlantUML and Graphwiz and Latex support
* Travis CLI tool
* MKISOFS Capability
* Added [wslgit](https://github.com/andy-5/wslgit) for Windows WSL Git & Git-LFS integration

![screenshot](https://raw.githubusercontent.com/wiki/yuk7/wsldl/img/Arch_Alpine_Ubuntu.png)

[![Build Status](https://img.shields.io/travis/binarylandscapes/AlpineWSL.svg?style=flat-square)](https://travis-ci.org/binarylandscapes/AlpineWSL)
[![Github All Releases](https://img.shields.io/github/downloads/binarylandscapes/AlpineWSL/total.svg?style=flat-square)](https://github.com/binarylandscapes/AlpineWSL/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/binarylandscapes/AlpineWSL.svg?style=flat-square)

## [Download](https://github.com/binarylandscapes/AlpineWSL/releases/latest)

## Requirements

* Windows 10 1709 Fall Creators Update 64bit or later.
* Windows Subsystem for Linux feature is enabled.

## References

* [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/about)

## Install

### 1. [Download](https://github.com/binarylandscapes/AlpineWSL/releases/latest) installer zip

### 2. Extract all files in zip file to same directory (Recommend C:\TEMP)

### 3. Run addWSLfeature.ps1 to add Windows Subsystem for Linux feature and reboot, if not already done

### 4. Run install.ps1 from an Elevated Powershell window to

* Remove previous AlpineWSL
* Extract rootfs
* Copy needed scripts and exes
* Register to WSL
* Complete system Git configuration for Git and Git-LFS
* Set python as a pointer to python3
* Cleanup
* Create a desktop shortcut

Note -  Exe filename is using to the instance name to register. If you rename it you can register with a different name and have multiple installs.

## How-to-Use(for Installed Instance)

### exe Usage

```dos
Useage :
    <no args>
      - Launches the distro's default behavior. By default, this launches your default shell.

    run <command line>
      - Run the given command line in that distro.

    config [setting [value]]
      - `--default-user <user>`: Set the default user for this distro to <user>
      - `--default-uid <uid>`: Set the default user uid for this distro to <uid>
      - `--append-path <on|off>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <on|off>`: Switch of Mount drives

    get [setting]
      - `--default-uid`: Get the default user uid in this distro
      - `--append-path`: Get on/off status of Append Windows PATH to $PATH
      - `--mount-drive`: Get on/off status of Mount drives
      - `--lxuid`: Get LxUID key for this distro

    clean
     - Uninstalls the distro.

    help
      - Print this usage message.
```

#### How to uninstall instance

```dos
>Alpine.exe clean

```

## How-to-Build

AlpineWSL can build on GNU/Linux or WSL.

`curl`,`zip`,`unzip`,`tar`(gnu) and `sudo` is required for build.

```shell
$ make
```
