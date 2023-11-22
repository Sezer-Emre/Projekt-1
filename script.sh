#!/bin/bash
apt update -y
apt install unattended-upgrades -y # ?
cat <<EOF > /etc/apt/apt.conf.d/20auto-upgrades
Apt::Periodic::Update-Package-Lists "1";
Apt::Periodic::Unattended-Upgrade "1";
Apt::Periodic::Download-Upgradeable-Packages "1";
Apt::Periodic::AutocleanInterval "7";
EOF
systemctl start unattended-upgrades
systemctl enable unattended-upgrades
apt install docker.io -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ubuntu
newgrp docker
docker --version
apt install git-all
git version
apt install -y nginx
service nginx start

