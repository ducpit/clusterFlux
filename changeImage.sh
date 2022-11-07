#! /bin/bash

echo Check Image

startCount=1
numNodes=45

srcBoot="/media/masternode/boot"
srcFs="/media/masternode/rootfs"
echo Quelle Bootfilesystem: $srcBoot
echo Quelle Rootfilesystem: $srcFs

echo Check Filesystem
if [ -d "/tftpboot" ];then
    echo "Ordner /tftpboot existiert"
else
    echo "Erstelle Ordner /tftpboot"
    mkdir /tftpboot
fi
if [ -d "/nfs" ];then
    echo "Ordner /nfs existiert"
else
    echo "Erstelle Ordner /nfs"
    mkdir /nfs
fi

if [ -d "$srcBoot" ];then
    echo "Quelle Bootfilesystem vorhanden"
else
    echo "Error: ${srcBoot} not found. Can not continue."
    exit 1
fi

if [ -d "$srcFs" ];then
    echo "Quelle Bootfilesystem vorhanden"
else
    echo "Error: ${srcFs} not found. Can not continue."
    exit 1
fi

echo Welches Image aendern\? alle oder spezifisches
read -p "a/num ?" input

if [ "$input" == "a" ]
    then
        echo tauschen aller Images

        for (( i=$startCount; i<=$numNodes; i++ ))
        do
            # echo Check ob altes Image
            ((k=$i+1))
            
            destFs=/nfs/leafNode$i
            destBoot=/tftpboot/192.168.128.$k
            echo Kopierziel: $destFs
            echo Kopierziel: $destBoot

            if [ -d "$destFs" ];then
                echo "Image vorhanden, Rechte anpassen und loeschen"
                sudo chmod -v 777 $destFs
                rm -r $destFs
            else
                echo "Rootfs nicht vorhanden"            
            fi
            if [ -d "$destBoot" ];then
                echo "Image vorhanden Rechte anpassen und loeschen"
                sudo chmod -v 777 $destBoot
                rm -vr $destBoot
            else
                echo "Bootfs nicht vorhanden"
            fi

            # Image kopieren
            echo "Image kopieren"
            sudo cp -vrp $srcBoot $destBoot
            sudo cp -vrp $srcFs $destFs

            # Cmdtextline
            echo Anpassung cmdline.txt
            echo console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.128.47:$destFs,vers=3 rw ip=dhcp rootwait elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory textmode
            echo console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.128.47:$destFs,vers=3 rw ip=dhcp rootwait elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory textmode > $destBoot/cmdline.txt
            
            # #hostname aendern
            echo Anpassung /etc/hostname zu leafNode$i
            echo leafNode$i > $destFs/etc/hostname

            echo Anpassung hosts
            echo 127.0.0.1       localhost
            echo ::1             localhost ip6-localhost ip6-loopback
            echo ff02::1         ip6-allnodes
            echo ff02::2         ip6-allrouters
            echo 127.0.1.1               leafNode$i

            echo 127.0.0.1       localhost > $destFs/etc/hosts
            echo ::1             localhost ip6-localhost ip6-loopback >> $destFs/etc/hosts
            echo ff02::1         ip6-allnodes >> $destFs/etc/hosts
            echo ff02::2         ip6-allrouters >> $destFs/etc/hosts
            echo 127.0.1.1               leafNode$i >> $destFs/etc/hosts

            #fstab
            echo Anpasssungen /etc/fstab
            echo proc            /proc           proc    defaults          0       0
            echo 192.168.128.47:$destBoot /boot nfs defaults,vers=3 0 0

            echo proc            /proc           proc    defaults          0       0 > $destFs/etc/fstab
            echo 192.168.128.47:$destBoot /boot nfs defaults,vers=3 0 0 >> $destFs/etc/fstab

            # shh file erzeugen

            touch $destFs/boot/ssh

            echo ---------leafNode$i abgeschlossen-----------
        done
        
    else
        echo Tausche Image von Node $input

        echo Check ob altes Image 
        destFs=/nfs/leafNode$input
        ip=$(($input+1))
        destBoot=/tftpboot/192.168.128.$ip
        echo Kopierziel: $destFs
        echo Kopierziel: $destRoot

        if [ -d "$destFs" ];then
            echo "Image vorhanden, Rechte anpassen und loeschen"
            sudo chmod -v 777 $destFs
            rm -r $destFs
        else
            echo "Rootfs nicht vorhanden"            
        fi
        if [ -d "$destBoot" ];then
            echo "Image vorhanden Rechte anpassen und loeschen"
            sudo chmod -v 777 $destBoot
            rm -vr $destBoot
        else
            echo "Bootfs nicht vorhanden"
        fi

        # Image kopieren
        echo "Image kopieren"
        sudo cp -vrp $srcBoot $destBoot
        sudo cp -vrp $srcFs $destFs

        # Cmdtextline
        echo Anpassung cmdline.txt
        echo console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.128.47:$destFs,vers=3 rw ip=dhcp rootwait elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory textmode
        echo console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.128.47:$destFs,vers=3 rw ip=dhcp rootwait elevator=deadline cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory textmode > $destBoot/cmdline.txt
        
        # #hostname aendern
        echo Anpassung /etc/hostname zu leafNode$input
        echo leafNode$input > $destFs/etc/hostname

        echo Anpassung hosts
        echo 127.0.0.1       localhost
        echo ::1             localhost ip6-localhost ip6-loopback
        echo ff02::1         ip6-allnodes
        echo ff02::2         ip6-allrouters
        echo 127.0.1.1               leafNode$input

        echo 127.0.0.1       localhost > $destFs/etc/hosts
        echo ::1             localhost ip6-localhost ip6-loopback >> $destFs/etc/hosts
        echo ff02::1         ip6-allnodes >> $destFs/etc/hosts
        echo ff02::2         ip6-allrouters >> $destFs/etc/hosts
        echo 127.0.1.1               leafNode$input >> $destFs/etc/hosts

        #fstab
        echo Anpasssungen /etc/fstab
        echo proc            /proc           proc    defaults          0       0
        echo 192.168.128.46:$destBoot /boot nfs defaults,vers=3 0 0

        echo proc            /proc           proc    defaults          0       0 > $destFs/etc/fstab
        echo 192.168.128.46:$destBoot /boot nfs defaults,vers=3 0 0 >> $destFs/etc/fstab

        touch $destFs/boot/ssh


fi
