# clusterFlux
Description of the creation of a high performance cluster, from 45 Raspberry Pis, with Kubernetes running Jupiterlabs.

## Setup Master (Here Desktop PC)
### Install OS [Ubuntu Install Tutorial](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview)
1. Download here [Ubuntu](https://ubuntu.com/download/desktop) Version: Ubuntu 20.04 LTS
2. Flash to USB Drive
3. Boot from Flash Drive
4. Run Install
5. Standart Konfigurations minimal installation
6. Create User => Username: masternode, Password: masterNode
7. remove installation medium and reboot

Fire wall -> ssh bootos
```console
sudo ufw allow ssh
```
#### Change USB-Boot-Drive to normal USB Stick

[Link](https://www.diskpart.com/articles/unboot-usb-1984.html)
Windos: open cmd.exe type ``` diskpart ```
 
        ```console
        list disk
        select disk n 
        clean
        create partition primary
        format fs=ntfs quick
        exit
        ```

## Script based Instalation or detail Guied

## Scrpt Based Konfiguration
1. Download and install Ubuntu Image
2. Do Proxy Settings if needet with settingsProxy.py file
3. update System  and Install Requiremnets
   - dnsmasq
   - nfs-kernel-server
   - nfs-common
   - tcpdmp
   - net-tools
4. Do dhcp if needet with settingsProxy.py file mac's of devices Needed
5. Download RPI Images and flash it on a SD Card then use changeImage.py
6. Do exports changes with settingsExports.py

## Detail Guide

### Konfigure Proxy Setting
```diff
- !! Attention, the login data is unencrypted in the files !!
```
#### Set Up Proxy for all Users
1. Register MAC of the Networkinterface by IT Support
2. Expand /etc/environment like the examplell 
```console
sudo nano /etc/environment
HTTP_PROXY="[username]:[password]@[proxy-web-or-IP-address]:[port-number]/";
HTTPS_PROXY="[username]:[password]@[proxy-web-or-IP-address]:[port-number]/";
FTP_PROXY="[username]:[password]@ [proxy-web-or-IP-address]:[port-number]/";
http_proxy="http://mama1010:pwdfromMama1010@proxy.h-ka.de:8888/";
also lowercase http_proxy
...
NO_PROXY="localhost,127.0.0.1,::1"
```
3. Save the file and exit. The changes will be applied the next time you log in.


#### Setting Up Proxy for APT
On some systems, the apt command-line utility needs a separate proxy configuration, because it does not use system environment variables.

1. To define proxy settings for apt, create or edit (if it already exists) a file named apt.conf in /etc/apt directory:
2. sudo nano /etc/apt/apt.conf
```console
Acquire::http::Proxy "http://[username]:[password]@[proxy-web-or-IP-address]:[port-number]/";
Acquire::https::Proxy "http://[username]:[password]@[proxy-web-or-IP-address]:[port-number]/";
...
Acquire::https::Proxy "http://mama1010:pwdfromMama1010@proxy.h-ka.de:8888/";

```
3. Save the file and exit. The configuration will be applied after a reboot.

## update Desktop PC
```console
sudo apt-get update
sudo apt-get upgrade
sudo apt install net-tools
sudo apt-get install dnsmasq tcpdmp nfs-kernel-server
```

## Static Ip for Cluster Network
 Easyst way is with the Ubuntu Networkmanager
 1. Choose your network interface. In my case i coosed the faster Network interface PCI network interface
 2. coose IPv4 and Method = manuel an give wish adress
 3. Restart Networkmanager with ``` sudo systemctl restart NetworkManager.service``` or ```sudo service network-manager restart```
 4. start Switch and check with ifconfig if the right ip is choosen
 
## Dnsmasq
[Tutorial](https://computingforgeeks.com/insztall-and-configure-dnsmasq-on-ubuntu/)  25.3.2022
Confiurge DHCP server and PXE server for Networkboot
1. Copy Default dnsmasq file 
2. apply dnsmasq settings in /etc/dnsmasq.conf
```
sudo cp /etc/dnsmasq.conf /etc/default_dnsmasq.conf
sudo rm /etc/dnsmasq.conf
sudo touch /etc/dnsmasq.conf

sudo nano /etc/dnsmasq.conf
-----------------------------------------
interface=
port= 0 #no DNS only DHCP and TFTP
dhcp-range=192.168.128.50,192.168.128.200,12h
log-dhcp
enable-tftp
tftproot=/tftpboot
pxe-service=0,"Raspberry Pi Boot"
tftp-unique-root
dhcp-host=MAC,CLIENTNAME,IP
-----------------------------------------

sudo systemctl enable dnsmasq.service
sudo systemctl restart dnsmasq.service
sudo reboot
```

## NFS Swttings
### Installation
[link](https://wiki.ubuntuusers.de/NFS/)
sudo apt-get install nfs-kernel-server 
sudo apt-get install nfs-common
### Freigaben
Datei /etc/exports 

check with exports -ra there is no exaption

# Freigabe gilt nur für 192.168.1.13, jedoch nur mit Leserechten:
/PFAD/ZUR/FREIGABE2      192.168.1.13(ro,async)
# Freigabe gilt für alle IPs von 192.168.1.1 bis 192.168.1.255, mit Lese-/Schreibrechten:
/PFAD/ZUR/FREIGABE3       192.168.1.0/255.255.255.0(rw,async)
# Freigabe gilt nur für den Rechner mit dem Namen notebook
/PFAD/ZUR/FREIGABE4      notebook(ro,async)
 



## Downlad Raspberry Pi Image

In the following section we crate the bootfiles and the rootfile system of the rapis
1. Download Raspberry Pi Image [Download](https://www.raspberrypi.com/software/operating-systems/)
2. Flash Os image on SD Card
3. Create ssh file with the following commadn ``` sudo nano touch /media/masternode/rootfs/ ```
4. Copy Files in the right Directriys
### Rootfile System
```console
sudo mkdir -p /nfs/leafNode1
sudo cp -a /media/masterNode/rootfs/* /nfs/leafNode1/
```

### Bootfiles
```console
sudo mkdir -p /tftpboot/IP_LeafNode_N
sudo cp -a /media/masterNode/bootf/* /tftpboot/IP_LeafNode_N/
```

### NFS-Server settings
change File like the example

```console
sudo nano /etc/exports
/nfs/leafNode1 *(rw,sync,no_subtree_check,no_root_squash)
```
```console
sudo systemctl enable rpcbind
sudo systemctl restart rpcbind
sudo systemctl enable nfs-kernel-server
sudo systemctl restart nfs-kernel-server
```

### Changes at  LeafNode Files
```console
sudo nano /tftpboot/IP_LeafNode_N/cmdline.txt

root=/dev/nfs nfsroot=192.168.128.46:/nfs/client1 rw ip=dhcp rootwait elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory
```
```console
sudo nano /nfs/leafNode1/etc/fstab
comment all out with out proc line
```
```console
sudo rm -r /tftpboot/192.168.128.1
sudo rm -r /nfs/leafNode1
sudo mkdir -p /nfs/leafNode1
sudo mkdir -p /tftpboot/192.168.128.1
sudo cp -a /media/masternode/boot/* /tftpboot/192.168.128.1
sudo cp -a /media/masternode/rootfs/* /nfs/leafNode1

sudo touch /nfs/leafNode1/boot/ssh
sudo nano /nfs/leafNode1/etc/hostname
sudo nano /nfs/leafNode1/etc/hosts
sudo nano /tftpboot/192.168.128.1/cmdline.txt
sudo nano /nfs/leafNode1/etc/fstab
```



### Konfigure PXE
update the Bootloader [Tutorial](https://www.raspberry-pi-geek.de/ausgaben/rpg/2018/02/raspi-via-netzwerk-booten/)








# static IP
# rootfileSystem
# 


### Kubernetes

## Leaf-Node (Raspberry PI)
Download image and flash on  SD
First DNSMasq Sciprt settings
Image change scripts
exportsscrpiz


time to change script 45 min
