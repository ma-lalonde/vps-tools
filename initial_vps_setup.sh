#!/bin/bash

# This file performs a few initial security settings modifications. To be run once on a fresh server.

# Ask a yes/no question to the user
function yesno()
{
    while true; do
            read -p "$1" yn
            case $yn in
                    [Yy]* ) return 0;; #true
                    [Nn]* ) return 1;; #false
                    * ) echo "Please answer yes or no.";;
            esac
    done
}


# Make sure user is OK
if [ $EUID = 0 ]
# Logged in as root
then
    echo "You are running as root. Please change to another user to continue."
    read -p "Which user would you like to change to / create? " USERNAME
    if [ -n $USERNAME ]
    # If entered username is not empty
    then
        if !  id -u "$USERNAME" >/dev/null 2>&1 
        # If user does not exist, create it
        then
            sudo useradd -m ${USERNAME} -G sudo
            sudo passwd ${USERNAME}
            chsh -s /bin/bash ${USERNAME}
        fi

		mv -v /root/* /home/${USERNAME} > /dev/null
        cd /home/${USERNAME}
		chown -R ${USERNAME}: /home/${USERNAME}/*

        # Log into proper user
        su ${USERNAME}
    else
        echo "Please enter a valid username."
        exit 1;
    fi
fi

# Set proper user mask for installation
echo "umask 0022" | sudo tee -a /etc/profile > /dev/null

# Ask to disable root login (security)
if yesno "SECURITY - Do you want to disable root login? It is recommended to do so. (y/n): "
then
	sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
fi

# Ask to disable IPv6 (security)
if yesno "SECURITY - Do you want to disable IPv6? It is recommended to do so. (y/n): "
then
	sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
	sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
	sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
fi

# Update packages
echo "Updating packages..."
sudo add-apt-repository ppa:teejee2008/ppa
sudo add-apt-repository universe
sudo apt update && sudo apt upgrade -y

# Enable firewall (not optional)
echo "Enabling firewall..."
sudo apt install ufw
sudo ufw allow OpenSSH
sudo ufw enable
echo "Done."

# Install Fail2Ban
if yesno "Install Fail2Ban? It will automatically give temporary bans to bad login requests through SSH and other services. (y/n): "
then
	sudo apt install fail2ban
	sudo systemctl start fail2ban
	sudo systemctl enable fail2ban
	echo "Fail2Ban installed. Read its documentation for further security customization."
fi

# Install Docker
if yesno "Install Docker and Docker-Compose? (y/n): "
then
    echo "Installing docker and docker-compose..."
    sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common python3-pip -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker ${USERNAME}
    sudo pip3 install docker-compose
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    

    printf "~/$THIS_FILE\n" >> ~/.bashrc
    echo "\nThis machine will reboot in 10 seconds and resume installation at next login."
    sleep 10
    printf "DOCKER_INSTALLED=1\n" >> $FILE
fi

# Ask to reboot.
if yesno "Installation complete. Docker requires restart. Reboot now? (y/n): "
then
	sudo reboot now
fi


