#!/bin/bash

# Install and start nexus as a service 
# This script works on RHEL 7 & 8 OS 
# Your server must have atleast 4GB of RAM


# Step 1: Login to your Linux server and update the yum packages. Also install required utilities.

sudo yum update -y
sudo yum install wget -y

# Step 2: Install OpenJDK 1.8

sudo yum install java-1.8.0-openjdk.x86_64 -y

# Step 3: Create a directory named app and cd into the directory.

sudo mkdir /app && cd /app

# Step 4: Download the latest nexus. You can get the latest download links fo for nexus from here.

sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz

# Untar the downloaded file.

sudo tar -xvf nexus.tar.gz

# Rename the untared file to nexus.

sudo mv nexus-3* nexus

# Step 5: As a good security practice, it is not advised to run nexus service with root privileges. So create a new user named nexus to run the nexus service.

sudo adduser nexus

# Change the ownership of nexus files and nexus data directory to nexus user.

sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

# Step 6: Open /app/nexus/bin/nexus.rc file
# Uncomment run_as_user parameter and set it as following.
# run_as_user="nexus"

sudo sed -i 's/^#run_as_user.*/run_as_user="nexus"/' /app/nexus/bin/nexus.rc

# echo "run_as_user=\"nexus\"" | sudo tee -a /app/nexus/bin/nexus.rc

# Step 7: Run nexus as a systemd service. 
# Create a nexus systemd unit file.

sudo tee /etc/systemd/system/nexus.service <<EOF
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF


# Step 8: Manage Nexus 
# add nexus service to boot
sudo chkconfig nexus on

# Step 9: allow Systemd to access the nexus binary in path /app/nexus/bin/nexus

sudo chcon -R -t bin_t /app/nexus/bin/nexus

# Step 10: start nexus service
#sudo systemctl enable nexus
sudo systemctl start nexus

# Step 11: check status of nexus service
sudo systemctl status nexus
echo "end of nexus installation"