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
sudo nano /etc/environment
export HTTP_PROXY="[username]:[password]@[proxy-web-or-IP-address]:[port-number]"
export HTTPS_PROXY="[username]:[password]@[proxy-web-or-IP-address]:[port-number]"
export FTP_PROXY="[username]:[password]@ [proxy-web-or-IP-address]:[port-number]"
...
export NO_PROXY="localhost,127.0.0.1,::1"
3. Save the file and exit. The changes will be applied the next time you log in.


etting Up Proxy for APT
On some systems, the apt command-line utility needs a separate proxy configuration, because it does not use system environment variables.

1. To define proxy settings for apt, create or edit (if it already exists) a file named apt.conf in /etc/apt directory:
2. sudo nano /etc/apt/apt.conf
Acquire::http::Proxy "http://[username]:[password]@ [proxy-web-or-IP-address]:[port-number]";
Acquire::https::Proxy "http://[username]:[password]@ [proxy-web-or-IP-address]:[port-number]";
3. Save the file and exit. The configuration will be applied after a reboot.

### Konfigure PXE

### Kubernetes

## Leaf-Node (Raspberry PI)



