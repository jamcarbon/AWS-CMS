#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd
mysql -h terraform-20220907055625034600000003.czalq65fdmds.ap-south-1.rds.amazonaws.com -u root -p$w#CffEeoXNaG mydb