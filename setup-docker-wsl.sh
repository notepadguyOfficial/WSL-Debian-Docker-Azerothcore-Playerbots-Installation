#!/bin/bash

sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install ca-certificates curl wget gnupg lsb-release apt-transport-https

wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb

sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg
echo -e "deb https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main
deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/wsl-transdebian.list > /dev/null

sudo apt-get update
sudo apt-get install systemd-genie

curl https://get.docker.com | sh

sudo usermod -aG docker $USER

sudo curl -L "https://github.com/docker/compose/releases/download/2.32.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "genie -i" >> ~/.bashrc

exit