#!/bin/bash

#install docker
sudo su - 
mkdir /var/jenkins_home

sudo apt-get update
sudo apt-get install openjdk-8-jdk -y 
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
sudo apt install git -y
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker 
sudo docker version
sudo docker images

apt install npm -y 
npm i next -y

sudo apt install awscli -y

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
cd /var/www/html
echo "<html><h1> Jenkins is healthy</h1></html>" > index.html 

#mount ebs
sudo mkfs -t xfs /dev/nvme1n1  #sudo mkfs -t xfs /dev/xvdh
sudo mount /dev/nvme1n1 /var/jenkins_home  #sudo mount /dev/xvdh /var/jenkins_home

#update /ets/fstab
sudo cp /etc/fstab  /etc/fstab.orig
sudo chmod 666 /etc/fstab
#sudo echo UUID=$(blkid |grep xvdh |awk -F "\"" '{print $2}') /var/jenkins_home xfs defaults,nofail 0 2 >>/etc/fstab
sudo echo UUID=$(blkid |grep nvme1n1 |awk -F "\"" '{print $2}') /var/jenkins_home xfs defaults,nofail 0 2 >>/etc/fstab
sudo chmod 644 /etc/fstab
#change jenkins home path
chown -R jenkins:jenkins /var/jenkins_home
cp -r /var/lib/jenkins /var/jenkins_home 
cp * -r .bash_history .cache .groovy .java .lastStarted .viminfo /var/jenkins_home
usermod -d /var/jenkins_home/ jenkins
sed -i 's|/var/lib/$NAME|/var/jenkins_home|g' /etc/default/jenkins
sed -i 's|/var/lib/jenkins|/var/jenkins_home|g' /lib/systemd/system/jenkins.service
sed -i 's|/var/lib/jenkins|/var/jenkins_home|g' /etc/passwd
sudo usermod -a -G docker jenkins
sudo service jenkins restart
sudo systemctl daemon-reload
sudo service docker stop
sudo service docker start
systemctl daemon-reload
sudo service jenkins restart