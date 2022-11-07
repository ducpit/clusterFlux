#! /bin/bash

echo Proxy Settings 
echo ! Achtung die Nutzerdaten sind inden Dateien /etc/enviroment und /etc/apt.conf in Klartext lesbar !
read -p "Bitte Nutzername eingeben:" nutzername
read -p "Bitte Passwort eingeben:" passwort

echo Nutzername: $nutzername
echo Passwort: $passwort

echo Acquire::http::proxy \"http://$nutzername:$passwort@proxy.h-ka.de:8888/\"\; > /etc/apt/apt.conf
echo Acquire::https::proxy \"http://$nutzername:$passwort@proxy.h-ka.de:8888/\"\; >> /etc/apt/apt.conf
echo Acquire::ftp::proxy \"ftp://$nutzername:$passwort@proxy.h-ka.de:8888/\"\; >> /etc/apt/apt.conf

echo PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin\" > /etc/environment
echo >> /etc/environment
echo HTTP_PROXY=\"http://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo HTTPS_PROXY=\"http://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo FTP_PROXY=\"http://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo http_proxy=\"http://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo https_proxy=\"http://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo ftp_proxy=\"ftp://$nutzername:$passwort@proxy.h-ka.de:8888/\" >> /etc/environment
echo NO_PROXY=\"localhost,127.0.0.1,::1\" >> /etc/environment
echo no_proxy=\"localhost,127.0.0.1,::1\" >> /etc/environment
