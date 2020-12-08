#!/bin/bash

tar -zxvf mongodb-linux-x86_64-ubuntu2004-4.4.2.tgz
mv mongodb-linux-x86_64-ubuntu2004-4.4.2 /home/zkpk/mongodb/
echo "" >> /home/zkpk/.bashrc
echo "export MONGODB_HOME=/home/zkpk/mongodb" >> /home/zkpk/.bashrc
echo "export PATH=/home/zkpk/mongodb/bin:\$PATH" >> /home/zkpk/.bashrc
cd /home/zkpk/
source .bashrc
