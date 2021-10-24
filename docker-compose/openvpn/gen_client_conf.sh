#!/bin/bash

read -p "Enter a file name for the new client cert (without the .ovpn extension): <filename>.ovpn " FILENAME
    if [ -n $FILENAME ]
	then
		docker-compose down
		docker run -e EASYRSA_KEY_SIZE=4096 -v ovpn-data:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $FILENAME
		docker-compose run --rm openvpn_udp ovpn_getclient $FILENAME > $FILENAME.ovpn
		docker-compose up -d
	else
		echo "Please enter a valid file name
	fi