# AlpineWSL

Alpine Linux on WSL (Windows 10 1803 or later)
based on [wsldl](https://github.com/yuk7/wsldl)
but adds the following capabilities:

* Git-LFS (Allows for files over 4GB that Windows OS has limited)
* Sphinx and multiple supporting packages like PlantUML and Graphwiz and Latex support
* Travis CLI tool
* MKISOFS Capability
* Added [wslgit](https://github.com/andy-5/wslgit) for Windows WSL Git & Git-LFS integration

![screenshot](https://raw.githubusercontent.com/wiki/yuk7/wsldl/img/Arch_Alpine_Cent.png)

[![Build Status](https://img.shields.io/travis/binarylandscapes/AlpineWSL.svg?style=flat-square)](https://travis-ci.org/binarylandscapes/AlpineWSL)
[![Github All Releases](https://img.shields.io/github/downloads/binarylandscapes/AlpineWSL/total.svg?style=flat-square)](https://github.com/binarylandscapes/AlpineWSL/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/binarylandscapes/AlpineWSL.svg?style=flat-square)

## [Download](https://github.com/binarylandscapes/AlpineWSL/releases/latest)

## Requirements

* Windows 10 1803 April 2018 Update x64 or later.
* Windows Subsystem for Linux feature is enabled.

---
**IMPORTANT**

Be aware that if installing any WSL instance on Windows 10 1803+, your system automatically is configured with NTFS "Case Sensitive" enabled for any folder created by the WSL instance. This may have issues with Windows usage of files in those folders.

[Per-directory case sensitivity and WSL](https://blogs.msdn.microsoft.com/commandline/2018/02/28/per-directory-case-sensitivity-and-wsl/)

---

## References

* [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/about)

## Install

### 1. [Download](https://github.com/binarylandscapes/AlpineWSL/releases/latest) Alpine.zip

### 2. Extract zip file to a new Alpine directory containing all files (Recommend C:\TEMP or Downloads folder)

### 3. Run ```addWSLfeature.ps1``` to add Windows Subsystem for Linux feature and reboot, if not already done

### 4. Run ```install.ps1``` from a Powershell window to

* Checks for and removes previous AlpineWSL distro (if distro location matches script parameters)
* Copies files from zip to ```C:\Users\<user>\.wsl\<distroName>\``` for install location
* Registers to WSL, silently
* Completes system\user configuration for Git, Git-LFS and Sphinx. **Will prompt for password of distro user**
* Creates a desktop shortcut
* Performs cleanup

Note -  Exe filename is using to the instance name to register. If you rename it, you can register with a different name and have multiple installs.

```dos
install.ps1 [parameter [default value]] :
  - `--distroName <Alpine>`: Sets the name of <installer> exe file, this must match the filename of the actual exe
  - `--user <$env:UserName.ToLower()>`: Sets the username for this distro and Git to your Windows user name that opened Powershell
  - `--email <username@domain>`: Sets the email for Git. This is forced prompted to enter during script
```

## How-to-Use(for Installed Instance)

### exe Usage

```dos
Usage :
    <no args>
      - Open a new shell with your default settings.

    silent
      - Use during installation of distro to supress all error messages and install completion prompt

    run <command line>
      - Run the given command line in that distro. Inherit current directory.

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

    backup
      - Output backup.tar.gz to the current directory using tar command.

    clean
     - Uninstall the distro.

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
