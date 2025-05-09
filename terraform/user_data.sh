#!/bin/bash
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl enable docker
sudo systemctl start docker

cd /home/admin
curl -O https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war

touch docker-compose.yml

echo -e "version: '3.8'
services:
  apache:
    image: httpd:latest
    ports:
      - 8080:80
      
  tomcat:
    image: tomcat:latest
    ports:
      - 9090:9090
    volumes:
      - /home/admin/sample.war:/usr/local/tomcat/webapps/sample.war" | sudo tee -a docker-compose.yml > /dev/null


sudo docker-compose up