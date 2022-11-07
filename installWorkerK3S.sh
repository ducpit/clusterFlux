
echo 'interface eth0' | sudo tee -a /etc/dhcpcd.conf
echo metric 500 | sudo tee -a /etc/dhcpcd.conf
sudo systemctl restart dhcpcd.service
curl -vsfL https://get.k3s.io | K3S_URL=https://192.168.128.47:6443 K3S_TOKEN="K1066b902b8bfe33bc08225e0873a3137025b211db3e38940340e2624a425a13d27::server:ef7384dff035bdf6dda07a3586d0b98f" INSTALL_K3S_EXEC="--snapshotter=native" sh -
sudo sed -i '61,62d' /etc/dhcpcd.conf
sudo systemctl restart dhcpcd.service
