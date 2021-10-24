#!/bin/bash

read -p "Enter a file name for the new client cert (without the .ovpn extension): <filename>.ovpn " FILENAME
    if [ -n $FILENAME ]
	then
		docker-compose down
		docker-compose run --rm openvpn_udp easyrsa build-client-full $FILENAME
		docker-compose run --rm openvpn_udp ovpn_getclient $FILENAME > $FILENAME.ovpn
		docker-compose up -d
	else
		echo "Please enter a valid file name
	fi