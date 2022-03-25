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

!! Problem login daten stehen in dateien

- Register MAC of the Networkinterface by IT Support
- Setting Up Permanent Proxy for All Users
To permanently set up proxy access for all users, you have to edit the /etc/environment file.
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
Example
3. Save the file and exit. The changes will be applied the next time you log in.


Setting Up Proxy for APT
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
```


### Konfigure PXE
update bootloader of raspberry Pis
## Konfigure Desktop PC
# Static Ip for Cluster Network
 Easyst way is with the Ubuntu Networkmanager
 1. Choose your network interface. In my case i coosed the faster Network interface PCI network interface
 2. coose IPv4 and Method = manuel an give wish adress
 3. Restart Networkmanager with ``` sudo systemctl restart NetworkManager.service``` or ```sudo service network-manager restart```
 4. start Switch and check with ifconfig if the right ip is choosen
 
# dnsmaasq
https://computingforgeeks.com/insztall-and-configure-dnsmasq-on-ubuntu/  25.3.2022
Confiurge DHCP server and PXE server for Network boot
Ubuntu 18.04+ comes with systemd-resolve which yu need to disable sice it binds port 53 which will conflict dnsmasq port
```
sudo systemctl diable systemd-resolved
sudo systemctl stop systemd-resolved
```
Also remove the symlinked resolv.conf file
```
ls -lh /etc/resolv.conf
sudo unlink /etc/resolv.conf
```
then create new resolv.conf
```
echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf
```
Install dnsmasq
```
sudo apt update
sudo apt install dnsmasq
```





# static IP
# rootfileSystem
# 


### Kubernetes

## Leaf-Node (Raspberry PI)



