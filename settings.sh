#!/bin/sh

for i in 1 2 3;do
	echo "## 配置文件内容
pidfilepath = /usr/local/mongodb$i/config/log/configsrv.pid
dbpath = /usr/local/mongodb$i/config/data
logpath = /usr/local/mongodb$i/config/log/congigsrv.log
logappend = true
bind_ip = 0.0.0.0
port = 2100$i
fork = true
#declare this is a config db of a cluster;
configsvr = true
#副本集名称
replSet=configs
#设置最大连接数
maxConns=20000" > /usr/local/mongodb$i/conf/config.conf
	echo "#配置文件内容
pidfilepath = /usr/local/mongodb$i/shard1/log/shard1.pid
dbpath = /usr/local/mongodb$i/shard1/data
logpath = /usr/local/mongodb$i/shard1/log/shard1.log
logappend = true
bind_ip = 0.0.0.0
port = 2701$i
fork = true
#副本集名称
replSet=shard1
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数
maxConns=20000" > /usr/local/mongodb$i/conf/shard1.conf
	echo "#配置文件内容
pidfilepath = /usr/local/mongodb$i/shard2/log/shard2.pid
dbpath = /usr/local/mongodb$i/shard2/data
logpath = /usr/local/mongodb$i/shard2/log/shard2.log
logappend = true
bind_ip = 0.0.0.0
port = 2702$i
fork = true
#副本集名称
replSet=shard2
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数 
maxConns=20000" > /usr/local/mongodb$i/conf/shard2.conf
	echo "#配置文件内容
pidfilepath = /usr/local/mongodb$i/shard3/log/shard3.pid
dbpath = /usr/local/mongodb$i/shard3/data
logpath = /usr/local/mongodb$i/shard3/log/shard3.log
logappend = true
bind_ip = 0.0.0.0
port = 2703$i
fork = true
#副本集名称
replSet=shard3
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数
maxConns=20000" > /usr/local/mongodb$i/conf/shard3.conf
	echo "#内容
pidfilepath = /usr/local/mongodb$i/mongos/log/mongos.pid
logpath = /usr/local/mongodb$i/mongos/log/mongos.log
logappend = true
bind_ip = 0.0.0.0
port = 2000$i
fork = true
#监听的配置服务器,只能有1个或者3个 configs为配置服务器的副本集名字
configdb = configs/localhost:21001,localhost:21002,localhost:21003
#设置最大连接数
maxConns=20000" > /usr/local/mongodb$i/conf/mongos.conf
done

#for i in 1 2 3;do
#	chmod 664 /usr/local/mongodb$i/conf/*
#done
