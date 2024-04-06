#!/bin/bash
sudo apt-get update
sudo apt install openjdk-8-jdk #install java jdk.
cd /opt
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -zxvf latest-unix.tar.gz
sudo mv /opt/nexus-3.49.0-02   /opt/nexus
sudo adduser nexus
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work
#nexus configurations. 
#sudo vi /opt/nexus/bin/nexus.rc
#run_as_user="nexus"
#starting nexus
#sudo su  -nexus
#/opt/nexus/bin/nexus start
#/opt/nexus/bin/nexus status
  # <server>
  #     <id>nexus</id>
     #  <username>admin</username>
 ## </server>
