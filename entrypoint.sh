#!/bin/bash
set -e

echo `service nginx status`
echo '1.启动nginx....'
service nginx start
sleep 3
echo `service nginx status`

echo `service php-fpm status`
echo '2.启动php-fpm....'
service php-fpm start
sleep 3
echo `service php-fpm status`

DATADIR='/usr/local/mysql/data'
chown -R mysql:mysql $DATADIR
echo `service mysqld status`
echo '3.启动mysqld....'
service mysqld start
sleep 3
echo `service mysqld status`

echo `service redis status`
echo '4.启动redis....'
service redis start
sleep 3
echo `service redis status`
