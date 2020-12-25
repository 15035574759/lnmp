# 创建基于centos7的php7.2镜像

# 基础镜像
FROM centos:7

#维护者
MAINTAINER qinlh@outlook.com

#安装nginx-1.14.2
RUN groupadd www \
    && useradd -r -g www -s /bin/false www \
    && yum install -y pcre-devel wget net-tools gcc zlib zlib-devel make openssl-devel \
    && mkdir /home/soft \
    && cd /home/soft \
    && wget http://sw.mhscedu.com/nginx-1.14.2.tar.gz \
    && tar -zxvf nginx-1.14.2.tar.gz \
    && cd nginx-1.14.2 \
    && ./configure \ 
    && make \
    && make install \
    && /usr/local/nginx/sbin/nginx

# 安装php-7.0.33
RUN groupadd www-data \
    && useradd -r -g www-data -s /bin/false www-data \
    && yum install -y php-devel gcc libXpm-devel libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel gmp gmp-devel libmcrypt libmcrypt-devel readline readline-devel libxslt libxslt-devel psmisc \
    && cd /home/soft \
    && wget http://sw.mhscedu.com/php-7.0.33.tar.gz \
    && tar zxvf php-7.0.33.tar.gz \
    && cd php-7.0.33 \
    && ./configure \ 
    --prefix=/usr/local/php \
    --with-curl \
    --with-freetype-dir \
    --with-gd \
    --with-gettext \
    --with-iconv-dir \
    --with-kerberos \
    --with-libdir=lib64 \
    --with-libxml-dir \
    --with-mysqli \
    --with-openssl \
    -with-pcre-regex \
    --with-pdo-mysql \
    --with-pdo-sqlite \
    --with-pear \
    --with-png-dir \
    --with-xmlrpc \
    --with-xsl \
    --with-zlib \
    --enable-fpm \
    --enable-bcmath \
    --enable-libxml \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-opcache \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-sysvsem\
    --enable-xml \
    --enable-zip \
    && make \ 
    && make install \
    && ln -sf /usr/local/php/bin/php /usr/bin/php

# 安装redis扩展
RUN cd /home/soft/ \
    && wget http://pecl.php.net/get/redis-4.2.0.tgz \
    && tar -zxvf redis-4.2.0.tgz \
    && cd redis-4.2.0 \
    && phpize \
    && ./configure --with-php-config=/usr/local/php/bin/php-config \
    && make \
    && make install

# 安装redis-5.0.3服务
RUN cd /home/soft/ \
    && wget http://download.redis.io/releases/redis-5.0.3.tar.gz \
    && tar -zxvf redis-5.0.3.tar.gz \
    && cd redis-5.0.3 \
    && make \
    && make install PREFIX=/usr/local/redis \
    && cp /home/soft/redis-5.0.3/redis.conf /usr/local/redis/bin/ \
    && ln -sf /usr/local/redis/bin/redis-cli /usr/bin/redis

# 安装手动编译Mysql-5.6
RUN groupadd mysql && useradd -r -g mysql -s /bin/false mysql \
    && mkdir -p /data/mysql/data \
    && chown -R mysql:mysql /data/mysql \
    && yum -y install gcc gcc-c++ cmake ncurses-devel bison initscripts perl perl-devel autoconf \
    && cd /home/soft/ \
    && wget http://mirrors.163.com/mysql/Downloads/MySQL-5.6/mysql-5.6.48.tar.gz \
    && tar -zxvf mysql-5.6.48.tar.gz \
    && cd mysql-5.6.48 \
    && cmake -DMYSQL_USER=mysql \
    -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DINSTALL_DATADIR=/data/mysql/data \
    -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
    -DDEFAULT_CHARSET=utf8  \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DEXTRA_CHARSETS=all \
    -DWITH_EMBEDDED_SERVER=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    && make \
    && make install \
    && chown -R mysql:mysql /usr/local/mysql \
    && cp /home/soft/mysql-5.6.48/support-files/my-default.cnf /usr/local/mysql/my-default.cnf \
    && cp /home/soft/mysql-5.6.48/support-files/my-default.cnf /etc/my.cnf \
    && cp /home/soft/mysql-5.6.48/support-files/mysql.server /etc/init.d/mysqld \
    && chmod a+x /etc/init.d/mysqld \
    && /usr/local/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/data/mysql/data \
    && ln -sf /usr/local/mysql/bin/mysql /usr/bin/mysql
    # && /usr/local/mysql/bin/mysqladmin -u root password '123456'

# yum安装Mysql-5.6
# RUN groupadd mysql && useradd -r -g mysql -s /bin/false mysql \
#     && rpm -qa|grep mariadb|xargs rpm -e --nodeps \
#     && cd /home/soft/ \
#     && wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm \
#     && rpm -ivh mysql-community-release-el7-5.noarch.rpm \
#     && yum install -y mysql-server \
#     && rpm -qa | grep mysql \
#     && systemctl start mysqld.service \
#     && systemctl enable mysqld.service

# 安装导出PDF工具wkhtmltopdf
COPY ./wkhtmltox/wkhtmltox-0.12.6-1.centos7.x86_64.rpm /home/soft/
COPY ./wkhtmltox/MSYHBD.TTC /usr/share/fonts/
COPY ./wkhtmltox/MSYHL.TTC /usr/share/fonts/
COPY ./wkhtmltox/simsun.ttc /usr/share/fonts/
RUN yum install -y fontconfig libXrender xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 libXext libjpeg openssl\
    && rpm -ivh /home/soft/wkhtmltox-0.12.6-1.centos7.x86_64.rpm || true

# 安装node.js-v10.15.1
RUN cd /home/soft/ \
    && wget http://cdn.npm.taobao.org/dist/node/v10.15.1/node-v10.15.1-linux-x64.tar.xz \
    && tar zxvf node-v10.13.0.tar.xz \
    && ln -sf /home/soft/node-v10.15.1-linux-x64/bin/npm /usr/bin/npm \
    && ln -sf /home/soft/node-v10.15.1-linux-x64/bin/node /usr/bin/node \
    && ln -sf /home/soft/node-v10.15.1-linux-x64/bin/npx /usr/bin/npx \
    && npm install -g pm2 \
    && ln -sf /home/soft/node-v10.15.1-linux-x64/bin/pm2 /usr/bin/pm2

# 初始化
CMD ["/usr/sbin/init"]