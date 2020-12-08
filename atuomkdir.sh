#!/bin/sh

for i in 1 2 3;do
        echo "zkpk" | sudo -S mkdir -p /usr/local/mongodb$i/conf
        sudo mkdir -p /usr/local/mongodb$i/mongos/log
        sudo mkdir -p /usr/local/mongodb$i/config/data
        sudo mkdir -p /usr/local/mongodb$i/config/log
        sudo mkdir -p /usr/local/mongodb$i/shard1/data
        sudo mkdir -p /usr/local/mongodb$i/shard1/log
        sudo mkdir -p /usr/local/mongodb$i/shard2/data
        sudo mkdir -p /usr/local/mongodb$i/shard2/log
        sudo mkdir -p /usr/local/mongodb$i/shard3/data
        sudo mkdir -p /usr/local/mongodb$i/shard3/log
        sudo chown -R zkpk:zkpk /usr/local/mongodb$i
done
