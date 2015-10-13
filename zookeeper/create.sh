#!/bin/sh

IMAGE=registry.modio.io/zookeeper:3.4.6
VOL_NAME=zookeeper-data
VOL_PATH=/var/lib/zookeeper
HOST=$1
NAME=zookeeper

docker pull $IMAGE

exists=`docker ps -a|grep $VOL_NAME`
if [ -z "$exists" ]; then
	docker run -v $VOL_PATH --name $VOL_NAME $IMAGE true
fi

exists=`docker ps -a|grep $NAME`
if [ ! -z "$exists" ]; then
	docker stop $NAME
	docker rm $NAME
fi

docker create -t -i -p 2181:2181 -p 2888:2888 -p 3888:3888 --hostname $HOST --name $NAME --dns 172.17.42.1 -e ZOO_ID=$2 -e ZOO_SRV=$3 --restart always --volumes-from $VOL_NAME $IMAGE
