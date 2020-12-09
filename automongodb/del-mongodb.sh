#!/bin/sh

for i in zkpk@master zkpk@slave1 zkpk@slave2;do
	ssh $i "echo \"zkpk\" | sudo -S rm -rf /usr/local/mongodb;ls /usr/local/"
done
