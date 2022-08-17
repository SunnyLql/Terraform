#!/bin/bash

# install jenkins and docker
sudo apt update
sudo apt install -y openjdk-11-jdk
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins


# install docker
sudo apt install -y docker.io

# add Jenkins user to Docker group
sudo usermod -a -G docker jenkins
sudo service jenkins restart
sudo systemctl daemon-reload
sudo service docker stop
sudo service docker start

# install cli
sudo apt -y install awscli

# install terraform 
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install -y terraform

# install packer

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
chown jenkins:jenkins /var/jenkins_home
cp -r /var/lib/jenkins /var/jenkins_home 
cp * -r .bash_history .cache .groovy .java .lastStarted .viminfo /var/jenkins_home
usermod -d /var/jenkins_home/ jenkins
sed -i 's|/var/lib/$NAME|/var/jenkins_home|g' /etc/default/jenkins
sed -i 's|/var/lib/jenkins|/var/jenkins_home|g' /lib/systemd/system/jenkins.service
sed -i 's|/var/lib/jenkins|/var/jenkins_home|g' /etc/passwd
systemctl daemon-reload
sudo service jenkins restart