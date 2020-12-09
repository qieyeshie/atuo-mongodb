#!/bin/sh

for i in zkpk@master zkpk@slave1 zkpk@slave2;do
	ssh $i 'killall mongod;killall mongos;netstat -tunlp'
done
