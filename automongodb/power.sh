#!/bin/bash

echo "=====关机请按\"1\"====="
echo "=====重启请按\"2\""
echo "=====取消请按\"0\""

read x

if [ $x == 1 ];then
	for i in zkpk@slave2 zkpk@slave1 zkpk@master;do
		ssh $i "echo \"zkpk\" | sudo -S poweroff"
	done
elif [ $x == 2 ];then
	for i in zkpk@slave2 zkpk@slave1 zkpk@master;do
		ssh $i "echo \"zkpk\" | sudo -S reboot"
	done
else [ $x == 0 ];
	echo "have a rest"
fi
	

