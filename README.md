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
```

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

root=/dev/nfs nfsroot=192.168.128.46:/nfs/client1 rw ip=dhcp rootwait elevator=deadline
```
```console
sudo nano /nfs/leafNode1/etc/fstab
comment all out with out proc line
```



### Konfigure PXE
update the Bootloader [Tutorial](https://www.raspberry-pi-geek.de/ausgaben/rpg/2018/02/raspi-via-netzwerk-booten/)








# static IP
# rootfileSystem
# 


### Kubernetes

## Leaf-Node (Raspberry PI)



