#!/bin/bash

read -p "Enter a file name for the new client cert (without the .ovpn extension): <filename>.ovpn " FILENAME
    if [ -n $FILENAME ]
	then
		docker-compose down
		docker run -v ovpn-data:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $FILENAME
		docker run -v ovpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $FILENAME > $FILENAME.ovpn
		docker-compose up -d
	else
		echo "Please enter a valid file name
	fi