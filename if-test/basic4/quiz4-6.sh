#!/bin/bash
touch group_only.txt
sudo chgrp ubuntu3 group_only.txt
ls -l group_only.txt
