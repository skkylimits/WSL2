# WSL 2 

Read more about WSl https://learn.microsoft.com/en-us/windows/wsl/install

⚙️ Tegenhanger in moderne Linux-systemen

ifconfig	ip addr	netwerkinterfaces
netstat -tulnp	ss -tulnp	sockets en poorten
route -n	ip route show	routing-tabellen
arp -a	ip neigh show	ARP-entries
hostname	hostnamectl	systeeminfo

## Pre-requisites

### Enable Virtualization

Enable svm mode in BIOS

### Windows Terminal

https://github.com/skkylimits/WindowsTerminal

## Install

```powershell
wsl --install
```

```powershell
wsl --install -d Ubuntu
```

### VS Code

Install VS Code on host machine

Install Remote Extension

https://code.visualstudio.com/docs/remote/wsl

```
 sudo apt-get install wget ca-certificates
```

https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode

Run update to use code .

```
sudo apt update -y
```

### ~/.bashrc

Paste .bashrc from github into directory

### Windows Terminal

Overwrite the default settings.json from the above mentioned github repo.

## setup.sh

Run the setup.sh to install packages.

