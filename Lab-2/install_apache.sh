#! /bin/bash
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
ipaddr = $(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<h1>Web Server with internal ip: $ipaddr </h1>" | sudo tee /var/www/html/index.html

