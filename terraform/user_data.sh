#!/bin/bash

sudo dnf update -y
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker


sudo dnf -y install openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd



sudo docker run -d -p 8080:80 --name apache httpd:latest