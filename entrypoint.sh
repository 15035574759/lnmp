#!/bin/bash
set -e

echo `service nginx status`
echo '1.启动nginx....'
/etc/init.d/nginx restart
sleep 3
echo `service nginx status`

echo `service php-fpm status`
echo '2.启动php-fpm....'
/etc/init.d/php-fpm restart
sleep 3
echo `service php-fpm status`

DATADIR='/data/mysql/data'
chown -R mysql:mysql $DATADIR
echo `service mysqld status`
echo '3.启动mysqld....'
/etc/init.d/mysqld restart
sleep 3
echo `service mysqld status`

echo `service redis status`
echo '4.启动redis....'
/etc/init.d/redis restart
sleep 3
echo `service redis status`
