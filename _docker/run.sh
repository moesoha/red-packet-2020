#!/bin/sh

/usr/sbin/nginx &
/usr/bin/mongod --config /etc/mongod.conf &
/usr/local/sbin/php-fpm -D

touch /var/log/nginx/project.log
tail -f /var/log/nginx/project.log
