#!/bin/bash
sudo useradd testuser7
sudo chage -E 2025-01-01 testuser7
sudo chage -l testuser7 | grep "Account expires"
