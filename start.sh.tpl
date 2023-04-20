#!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install epel -y
sudo yum install docker -y 
sudo systemctl start docker
sudo systemctl enable docker
