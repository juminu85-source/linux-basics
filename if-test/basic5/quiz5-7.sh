#!/bin/bash
sudo groupadd oldgroup
sudo groupmod -n newgroup oldgroup
grep "newgroup" /etc/group
