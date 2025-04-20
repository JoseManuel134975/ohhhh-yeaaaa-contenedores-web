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
touch dockerfile

echo -e "FROM httpd:latest" | sudo tee -a dockerfile > /dev/null 
echo -e "RUN apt update" | sudo tee -a dockerfile > /dev/null 
echo -e "RUN apt install nano" | sudo tee -a dockerfile > /dev/null 
echo -e "EXPOSE 80" | sudo tee -a dockerfile > /dev/null 
echo -e "EXPOSE 443" | sudo tee -a dockerfile > /dev/null 

sudo docker build -t my-image:my-image .
sudo docker run -d --name my-container -p 8080:80 -p 8443:443 my-image:my-image