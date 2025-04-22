#!/bin/bash
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io -y

sudo systemctl enable docker
sudo systemctl start docker

cd /home/admin
sudo mkdir dockerfiles
touch dockerfiles/dockerfile_apache


echo -e "FROM httpd:latest" | sudo tee -a dockerfiles/dockerfile_apache > /dev/null 
echo -e "RUN apt update" | sudo tee -a dockerfiles/dockerfile_apache > /dev/null 
echo -e "RUN apt install nano -y" | sudo tee -a dockerfiles/dockerfile_apache > /dev/null 
echo -e "EXPOSE 80" | sudo tee -a dockerfiles/dockerfile_apache > /dev/null 
echo -e "EXPOSE 443" | sudo tee -a dockerfiles/dockerfile_apache > /dev/null 


touch dockerfiles/dockerfile_tomcat
echo -e "FROM tomcat:latest" | sudo tee -a dockerfiles/dockerfile_tomcat > /dev/null 


touch docker-compose.yml
echo -e "version: '3.8'

services:
  httpd:
    build:
      context: ./dockerfiles/dockerfile_apache
    image: josemanuel:httpd
    container_name: httpd-container
    ports:
      - "8080:80"
      - "8443:443"

  tomcat:
    build:
      context: ./dockerfiles/dockerfile_tomcat
    image: josemanuel:tomcat
    container_name: tomcat-container
    ports:
      - "8081:8080"
" | sudo tee -a docker-compose.yml > /dev/null