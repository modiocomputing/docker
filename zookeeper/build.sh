#!/bin/sh

IMAGE=jbgeorg/zookeeper:3.4.6

docker build -t $IMAGE .
docker push $IMAGE
