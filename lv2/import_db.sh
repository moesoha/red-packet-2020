#!/bin/sh

mongod --config /etc/mongod.conf &
sleep 10
mongorestore
killall mongod