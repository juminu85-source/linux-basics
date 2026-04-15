#!/bin/bash
echo "linux" > data.txt
ln data.txt link_data.txt
echo "ubuntu" > link_data.txt
cat data.txt
