#!/bin/sh

mongod --config /etc/mongod.conf &
echo "Wait 7s for mongod"
sleep 7
mongorestore
killall mongod
