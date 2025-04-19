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
touch httpd.conf

echo -e "LoadModule ssl_module modules/mod_ssl.so" | sudo tee -a httpd.conf > /dev/null 
echo -e "LoadModule rewrite_module modules/mod_rewrite.so" | sudo tee -a httpd.conf > /dev/null 
echo -e "LoadModule headers_module modules/mod_headers.so" | sudo tee -a httpd.conf > /dev/null 
echo -e "LoadModule auth_basic_module modules/mod_auth_basic.so" | sudo tee -a httpd.conf > /dev/null 

echo -e "DocumentRoot /usr/local/apache2/htdocs" | sudo tee -a httpd.conf > /dev/null 
echo -e "Listen 80" | sudo tee -a httpd.conf > /dev/null 
echo -e "Listen 443" | sudo tee -a httpd.conf > /dev/null 
echo -e "Include conf/extra/httpd-vhosts.conf" | sudo tee -a httpd.conf > /dev/null 


echo -e "AddLanguage en .en" | sudo tee -a httpd.conf > /dev/null 
echo -e "AddLanguage en .es" | sudo tee -a httpd.conf > /dev/null 
echo -e "LanguagePriority en es" | sudo tee -a httpd.conf > /dev/null 
echo -e "<Directory "/usr/local/apache2/htdocs">
    AuthType Basic
    AuthName "Restricted Access"
    AuthUserFile /usr/local/apache2/conf/.htpasswd
    Require valid-user
</Directory>" | sudo tee -a httpd.conf > /dev/null 


touch vh.conf

echo -e "<VirtualHost *:443>
    DocumentRoot "/usr/local/apache2/htdocs/"
    ServerName your-domain.com
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/cert.pem
    SSLCertificateKeyFile /etc/ssl/private/key.pem

    ErrorDocument 404 /error404.html

    RewriteEngine On
    RewriteRule ^/oldpage$ /newpage [R=301,L]
</VirtualHost>" | sudo tee -a vh.conf > /dev/null 


touch dockerfile

echo -e "FROM httpd:latest" | sudo tee -a dockerfile > /dev/null 
echo -e "RUN apt-get update" | sudo tee -a dockerfile > /dev/null 
echo -e "WORKDIR /usr/local/apache2/conf" | sudo tee -a dockerfile > /dev/null 
echo -e "RUN htpasswd -cb .htpasswd admin admin" | sudo tee -a dockerfile > /dev/null 
echo -e "RUN rm /usr/local/apache2/conf/httpd.conf" | sudo tee -a dockerfile > /dev/null 
echo -e "COPY httpd.conf /usr/local/apache2/conf/httpd.conf" | sudo tee -a dockerfile > /dev/null 
echo -e "EXPOSE 80 443" | sudo tee -a dockerfile > /dev/null 


sudo docker build -t my-image:my-image .
sudo docker run -d --name my-container -p 8080:80 -p 8443:443 my-image:my-image
# sudo docker run -d -p 8080:80 --name apache httpd:latest