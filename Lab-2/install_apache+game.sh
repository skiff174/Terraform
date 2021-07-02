#! /bin/bash
sudo yum install -y httpd git
sudo systemctl start httpd
sudo systemctl enable httpd
sudo git clone https://github.com/skiff174/Puzzle15.git /var/tmp/Puzzle15
sudo rsync -avlP /var/tmp/Puzzle15/ /var/www/html/

