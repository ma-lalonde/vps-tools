#!/bin/bash

source .env
WAN_IP=$(wget -qO- ifconfig.me/ip)
docker volume create --name ovpn-data
docker run -v ovpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://${SITE} -C 'AES-256-GCM' -a 'SHA384' -p 'route ${WAN_IP} 255.255.255.255 net_gateway' -e 'duplicate-cn' -e 'max-clients 10'
docker run -e EASYRSA_KEY_SIZE=4096 -v ovpn-data:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki


sudo sysctl -w net.ipv4.ip_forward=1
sudo ufw allow 1194/udp
sudo ufw disable
sudo ufw enable

docker-compose up -d