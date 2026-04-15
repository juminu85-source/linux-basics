#!/bin/bash
sudo useradd testuser2
sudo usermod -d /home/newhome testuser2
grep "testuser2" /etc/passwd
