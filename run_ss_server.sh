#!/bin/bash

PORT=443
PASSWD="byte!@#520"

docker run --name ss-server -d -p $PORT:$PORT oddrationale/docker-shadowsocks -s 0.0.0.0 -p $PORT -k $PASSWD -m aes-256-cfb
