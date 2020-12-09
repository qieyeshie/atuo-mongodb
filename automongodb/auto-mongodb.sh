#!/bin/sh

echo "=====正在部署分片集群====="
for i in zkpk@master zkpk@slave1 zkpk@slave2;
do
	ssh $i "echo \"zkpk\" | sudo -S mkdir -p /usr/local/mongodb/conf;sudo mkdir -p /usr/local/mongodb/mongos/log;sudo mkdir -p /usr/local/mongodb/config/data;sudo mkdir -p /usr/local/mongodb/config/log;sudo mkdir -p /usr/local/mongodb/shard1/data;sudo mkdir -p /usr/local/mongodb/shard1/log;sudo mkdir -p /usr/local/mongodb/shard2/data;sudo mkdir -p /usr/local/mongodb/shard2/log;sudo mkdir -p /usr/local/mongodb/shard3/data;sudo mkdir -p /usr/local/mongodb/shard3/log;sudo chown -R zkpk:zkpk /usr/local/mongodb"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "echo \"## 配置文件内容
pidfilepath = /usr/local/mongodb/config/log/configsrv.pid
dbpath = /usr/local/mongodb/config/data
logpath = /usr/local/mongodb/config/log/congigsrv.log
logappend = true
bind_ip = 0.0.0.0
port = 21000
fork = true
#declare this is a config db of a cluster;
configsvr = true
#副本集名称
replSet=configs
#设置最大连接数
maxConns=20000\" > /usr/local/mongodb/conf/config.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "echo \"#配置文件内容
pidfilepath = /usr/local/mongodb/shard1/log/shard1.pid
dbpath = /usr/local/mongodb/shard1/data
logpath = /usr/local/mongodb/shard1/log/shard1.log
logappend = true
bind_ip = 0.0.0.0
port = 27001
fork = true
#副本集名称
replSet=shard1
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数
maxConns=20000\" > /usr/local/mongodb/conf/shard1.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "echo \"#配置文件内容
pidfilepath = /usr/local/mongodb/shard2/log/shard2.pid
dbpath = /usr/local/mongodb/shard2/data
logpath = /usr/local/mongodb/shard2/log/shard2.log
logappend = true
bind_ip = 0.0.0.0
port = 27002
fork = true
#副本集名称
replSet=shard2
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数 
maxConns=20000\" > /usr/local/mongodb/conf/shard2.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "echo \"#配置文件内容
pidfilepath = /usr/local/mongodb/shard3/log/shard3.pid
dbpath = /usr/local/mongodb/shard3/data
logpath = /usr/local/mongodb/shard3/log/shard3.log
logappend = true
bind_ip = 0.0.0.0
port = 27003
fork = true
#副本集名称
replSet=shard3
#declare this is a shard db of a cluster;
shardsvr = true
#设置最大连接数
maxConns=20000\" > /usr/local/mongodb/conf/shard3.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "echo \"#内容
pidfilepath = /usr/local/mongodb/mongos/log/mongos.pid
logpath = /usr/local/mongodb/mongos/log/mongos.log
logappend = true
bind_ip = 0.0.0.0
port = 20000
fork = true
#监听的配置服务器,只能有1个或者3个 configs为配置服务器的副本集名字
configdb = configs/192.168.137.141:21000,192.168.137.142:21000,192.168.137.143:21000
#设置最大连接数
maxConns=20000\" > /usr/local/mongodb/conf/mongos.conf"
done

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "source /home/zkpk/.bashrc;mongod -f /usr/local/mongodb/conf/config.conf"
done

mongo --port 21000 <<EOF
use admin;
config={_id:"configs",members:[{_id:0,host:"192.168.137.141:21000"},{_id:1,host:"192.168.137.142:21000"},{_id:2,host:"192.168.137.143:21000"}]};
rs.initiate(config);
exit;
EOF

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "source /home/zkpk/.bashrc;mongod -f /usr/local/mongodb/conf/shard1.conf"
done

mongo --port 27001 <<EOF
use admin;
config={_id:"shard1",members:[{_id:0,host:"192.168.137.141:27001"},{_id:1,host:"192.168.137.142:27001"},{_id:2,host:"192.168.137.143:27001",arbiterOnly:true}]};
rs.initiate(config);
exit;
EOF

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "source /home/zkpk/.bashrc;mongod -f /usr/local/mongodb/conf/shard2.conf"
done

ssh zkpk@slave1 "mongo --port 27002 <<EOF
use admin;
config={_id:\"shard2\",members:[{_id:0,host:\"192.168.137.141:27002\",arbiterOnly:true},{_id:1,host:\"192.168.137.142:27002\"},{_id:2,host:\"192.168.137.143:27002\"}]};
rs.initiate(config);
exit;
EOF"

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
        ssh $i "source /home/zkpk/.bashrc;mongod -f /usr/local/mongodb/conf/shard3.conf"
done

mongo --port 27003 <<EOF
use admin;
config={_id:"shard3",members:[{_id:0,host:"192.168.137.141:27003"},{_id:1,host:"192.168.137.142:27003",arbiterOnly:true},{_id:2,host:"192.168.137.143:27003"}]};
rs.initiate(config);
exit;
EOF

for i in zkpk@master zkpk@slave1 zkpk@slave2
do
	ssh $i "source /home/zkpk/.bashrc;mongos -f /usr/local/mongodb/conf/mongos.conf"
done

mongo --port 20000 <<EOF
use admin;
sh.addShard("shard1/192.168.137.141:27001,192.168.137.142:27001,192.168.137.143:27001");
sh.addShard("shard2/192.168.137.141:27002,192.168.137.142:27002,192.168.137.143:27002");
sh.addShard("shard3/192.168.137.141:27003,192.168.137.142:27003,192.168.137.143:27003");
sh.status();
db.runCommand({enablesharding:"testdb"});
db.runCommand({shardcollection:"testdb.table1",key:{id:"hashed"}});
db.runCommand({shardcollection:"testdb.table2",key:{id:1}});
exit;
EOF

mongo 127.0.0.1:20000 <<EOF
use testdb;
for (var i=1;i<=10000;i++) db.table1.save({id:i,"test1":"testval1"});
db.table1.stats();
exit;
EOF
