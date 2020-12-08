#!/bin/sh

for i in 1 2 3;do
	mongod -f /usr/local/mongodb$i/conf/config.conf
done

for i in 1 2 3;do
	for j in 1 2 3;do
		mongod -f /usr/local/mongodb$i/conf/shard$j.conf
	done
done

for i in 1 2 3;do
	mongos -f /usr/local/mongodb$i/conf/mongos.conf
done
