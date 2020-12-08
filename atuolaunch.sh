#!/bin/sh

echo "-正在启动配置服务器-"
for i in 1 2 3;do
	mongod -f /usr/local/mongodb$i/conf/config.conf
done

mongo --port 21001 <<EOF
use admin;
config={_id:"configs",members:[{_id:0,host:"localhost:21001"},{_id:1,host:"localhost:21002"},{_id:2,host:"localhost:21003"}]};
rs.initiate(config);
exit
EOF

echo "-正在启动分片服务器-"
for i in 1 2 3;do
        for j in 1 2 3;do
                mongod -f /usr/local/mongodb$i/conf/shard$j.conf
        done
done

mongo --port 27011 <<EOF
use admin;
config={_id:"shard1",members:[{_id:0,host:"localhost:27011"},{_id:1,host:"localhost:27012"},{_id:2,host:"localhost:27013",arbiterOnly:true}]};
rs.initiate(config);
exit
EOF

mongo --port 27022 <<EOF
use admin;
config={_id:"shard2",members:[{_id:0,host:"localhost:27021",arbiterOnly:true},{_id:1,host:"localhost:27022"},{_id:2,host:"localhost:27023"}]};
rs.initiate(config);
exit
EOF

mongo --port 27031 <<EOF
use admin;
config={_id:"shard3",members:[{_id:0,host:"localhost:27031"},{_id:1,host:"localhost:27032",arbiterOnly:true},{_id:2,host:"localhost:27033"}]};
rs.initiate(config);
exit
EOF

echo "-正在启动路由服务器-"
for i in 1 2 3;do
        mongos -f /usr/local/mongodb$i/conf/mongos.conf
done

mongo --port 20001 <<EOF
use admin;
sh.addShard("shard1/localhost:27011,localhost:27012,localhost:27013");
sh.addShard("shard2/localhost:27021,localhost:27022,localhost:27023");
sh.addShard("shard3/localhost:27031,localhost:27032,localhost:27033");
sh.status();
db.runCommand({enablesharding:"testdb"});
db.runCommand({shardcollection:"testdb.table1",key:{id:"hashed"}});
db.runCommand({shardcollection:"testdb.table2",key:{id:1}});
exit
EOF
echo "-完成启动-"
