# lnmp
lnmp集成环境(centos7+nginx-1.14.2+php-7.0.33+redis-5.0.3+mysql-5.6+nodejs-11+wkhtmltox-0.12.6)

## 使用教程(Quick start)
### 下载(Download)
```
docker pull qinlinhui/lnmp
```
### 启动(Start)
```
# 端口映射自行指定,容器名称自行指定为lnmp
docker run -dit --privileged=true --name=lnmp qinlinhui/lnmp

# 高级用法(Advanced usage)
docker run -dit \
-p 81:80 \
-p 444:443 \
-p 3307:3306 \
-p 9001:9000 \
-v /xxx/www:/www \
-v /xxx/mysql:/data/mysql \
--privileged=true \
--name=lnmp \
qinlinhui/lnmp
```
### 连接(Connect)
```
# 容器名称与上一步保持一致
docker exec -it lnmp /bin/bash
```
### 状态(Status)
```
ps aux|grep nginx
ps aux|grep mysql
ps aux|grep php-fpm
ps aux|grep redis
```
### 设置初始密码(Default password)
```
/usr/local/mysql/bin/mysqladmin -u root password '123456'
```
### 初始化(initialize)
```
# 默认已初始化数据库
初始化数据库
/usr/local/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/data/mysql/data \
默认初始化数据库目录：/data/mysql/data
可以自行修改位置，如果修改位置记得重新初始化数据库
```
### 警告(Warning)
```
# 请保持清醒头脑，明确自己是在容器内还是在服务器本身执行命令，以及-v挂载对文件的影响，以免造成不可挽回的损失
```
### 配置(Config)
```
#配置文件路径(Config file path)
# Nginx
/usr/local/nginx/conf/nginx.conf
/usr/local/nginx/conf/conf.d/
# MySQL
/etc/my.cnf
# PHP
/usr/local/php/lib/php.ini
/usr/local/php/etc/php-fpm.conf
/usr/local/php/etc/php-fpm.d/www.conf
# Redis
/usr/local/redis/etc/redis.conf
```
### 日志(log)
```
#日志文件路径(log file path)
# Nginx
/usr/local/nginx/logs/
# PHP
/usr/local/php/var/log/php-fpm.log
/usr/local/php/var/log/php_errors.log
# MYSQL
/usr/local/mysql/error.log
# Redis
/var/log/redis/redis.log
```

### PHP扩展(PHP extension)
```
# 默认已安装部分扩展在目录：/usr/local/php/lib/php/extensions/no-debug-non-zts-20151012
# 如果要启用指定扩展，则需要修改php.ini，加上
extension=xxx.so
# xxx为PHP扩展的文件名，然后重启php
service php-fpm restart
```
### 版本(Version)
```
# 各版本详细信息请参考
https://github.com/15035574759/lnmp
```
