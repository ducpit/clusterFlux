#! /bin/bash
macArray="dc:a6:32:e3:8b:9d"
macArray+=("dc:a6:32:e3:96:db")
macArray+=("dc:a6:32:e3:98:33")
macArray+=("dc:a6:32:e3:97:b3")
macArray+=("dc:a6:32:e3:96:80")
macArray+=("dc:a6:32:e3:96:9e")
macArray+=("dc:a6:32:e3:95:36")
macArray+=("dc:a6:32:e3:98:57")
macArray+=("dc:a6:32:e3:96:20")
macArray+=("dc:a6:32:e3:95:06")
macArray+=("dc:a6:32:e3:8b:ec")
macArray+=("dc:a6:32:e3:97:2a")
macArray+=("dc:a6:32:e3:98:81")
macArray+=("dc:a6:32:e3:98:3f")
macArray+=("dc:a6:32:b3:f7:76")
macArray+=("dc:a6:32:b3:f7:a9")
macArray+=("dc:a6:32:c6:76:2b")
macArray+=("dc:a6:32:e3:97:34")
macArray+=("dc:a6:32:e3:82:76")
macArray+=("dc:a6:32:b3:f7:5b")
macArray+=("dc:a6:32:b3:f5:f9")
macArray+=("dc:a6:32:b3:f7:a2")
macArray+=("dc:a6:32:b3:f7:70")
macArray+=("dc:a6:32:b3:f6:d4")
macArray+=("dc:a6:32:b3:f3:a1")
macArray+=("dc:a6:32:b3:f7:97")
macArray+=("dc:a6:32:e3:97:d5")
macArray+=("dc:a6:32:e3:9b:36")
macArray+=("dc:a6:32:e3:96:ae")
macArray+=("dc:a6:32:e3:97:88")
macArray+=("dc:a6:32:e3:8a:d9")
macArray+=("dc:a6:32:e3:98:65")
macArray+=("dc:a6:32:e3:95:fc")
macArray+=("dc:a6:32:e3:9a:d9")
macArray+=("dc:a6:32:e3:97:40")
macArray+=("dc:a6:32:e3:95:21")
macArray+=("dc:a6:32:e3:98:9c")
macArray+=("dc:a6:32:e3:98:ae")
macArray+=("dc:a6:32:e3:98:36")
macArray+=("dc:a6:32:e3:97:c7")
macArray+=("dc:a6:32:e3:97:e5")
macArray+=("dc:a6:32:e3:98:7b")
macArray+=("dc:a6:32:e3:98:1e")
macArray+=("dc:a6:32:e3:97:97")
macArray+=("dc:a6:32:e3:97:d9")

#sudo apt-get install dnsmasq tcpdump nfs-kernel-server nfs-common rpcbind

#sudo systemctl enable dnsmasq.service

echo \# Interface on which dnsmasq operates > /etc/dnsmasq.conf
echo interface=enp0s25 >> /etc/dnsmasq.conf
echo \# Port 0 disabel DNS functionality >> /etc/dnsmasq.conf
echo port=0 >> /etc/dnsmasq.conf
echo \# Dynamic Adressing 50-200, 12 hour lease >> /etc/dnsmasq.conf
echo dhcp-range=192.168.128.50,192.168.128.200,12h >> /etc/dnsmasq.conf
echo \# logging >> /etc/dnsmasq.conf
echo log-dhcp >> /etc/dnsmasq.conf
echo \# TFTP Setings >> /etc/dnsmasq.conf
echo enable-tftp >> /etc/dnsmasq.conf
echo tftp-root=/tftpboot >> /etc/dnsmasq.conf
echo \# Enabe PXE for Raspberry Pi >> /etc/dnsmasq.conf
echo pxe-service=0,\"Raspberry Pi Boot\" >> /etc/dnsmasq.conf
echo tftp-unique-root >> /etc/dnsmasq.conf
echo \# Static IP Assingments >> /etc/dnsmasq.conf

for i in ${!macArray[@]}; do
    ((k=i+1))
    ((u=k+1)) 
    echo dhcp-host=${macArray[$i]},leafNode$k,192.168.128.$u >> /etc/dnsmasq.conf
done


#sudo systemctl restart dnsmasq.service
#sudo systemctl enable rpcbind
#sudo systemctl enable nfs-kernel-server

#sudo systemctl restart rpcbind
#sudo systemctl restart nfs-kernel-server

# Export
echo \# Shared Folders  > /etc/exports
for i in ${!macArray[@]}; do
    ((k=i+1))
    ((u=k+1)) 
    echo /nfs/leafNode$k 192.168.128.$u\(rw,sync,no_subtree_check,no_root_squash\) >> /etc/exports
    echo /tftpboot/192.168.128.$u 192.168.128.$u\(rw,sync,no_subtree_check,no_root_squash\) >> /etc/exports
done