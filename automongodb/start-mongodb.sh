#!/bin/sh

for i in zkpk@master zkpk@slave1 zkpk@slave2;do
	ssh $i "mongod -f /usr/local/mongodb/conf/config.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2;do
	for j in 1 2 3;do
		ssh $i "mongod -f /usr/local/mongodb/conf/shard$j\.conf"
	done
done

for i in zkpk@master zkpk@slave1 zkpk@slave2;do
	ssh $i "mongos -f /usr/local/mongodb/conf/mongos.conf"
done
