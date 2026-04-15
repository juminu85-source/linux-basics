#!/bin/bash
sudo groupadd mygroup
sudo useradd testuser4
sudo usermod -aG mygroup testuser4
grep "mygroup" /etc/group
