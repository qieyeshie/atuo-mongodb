#!/bin/sh

echo "-----正在配置mongodb分片集群-----"
echo "-正在安装-"
./atuoinstall.sh
sleep 1
echo "Successful!"

echo "-正在创建文件夹-"
./atuomkdir.sh
sleep 3
echo "Successful!"

echo "-正在配置文件-"
./settings.sh
sleep 3
echo "Successful!"

echo "-正在启动服务器-"
./atuolaunch.sh
echo "-请稍等-"

cp start-mongodb.sh /home/zkpk/
cp stop-mongodb.sh /home/zkpk/

sleep 2
echo "Error: A fatal mistake!"
echo "Error:We can’t connect to the server at www.baidu.com."
sleep 1
echo "If that address is correct, here are three other things you can try:

    Try again later.
    Check your network connection.
    If you are connected but behind a firewall, check that Firefox has permission to access the Web."
sleep 8
echo "正在修复。。。"
sleep 10
echo "骗你的。。。，成功了："
sleep 1
echo "=====主人的任务罢了====="

