#!/usr/bin/env bash

#misc
yum -y install telnet wget pstree bind-utils logwatch psmisc sudo cronie git mc iproute


#disable selinux
sed -i.bak  s/SELINUX=enforcing/SELINUX=disabled/ /etc/selinux/config
setenforce 0

#install PHP 7.1
cd ~
wget -q http://rpms.remirepo.net/enterprise/remi-release-7.rpm
wget -q https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
yum-config-manager --enable remi-php71
rm -f remi-release-7.rpm
rm -f epel-release-latest-7.noarch.rpm


#app dependencies
yum -y install httpd mod_ssl  php php-fpm php-opcache php-common php-cli php-bcmath php-mbstring php-pdo php-process php-xml php-soap php-redis php-mysql

#nodejs
yum -y install nodejs npm composer
npm install -g gulp
npm install -g bower


cd ~
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
rm -f mysql-community-release-el7-5.noarch.rpm

#install MySQL tools
yum -y install mysql


#project setup
#set timezone ;( Here should be UTC but... ehh
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime

#needed to deploy script
yum install java unzip -y
cd ~
mkdir /usr/local/share/yui-compressor/
wget https://github.com/downloads/yui/yuicompressor/yuicompressor-2.4.7.zip
unzip yuicompressor-2.4.7.zip
mv ./yuicompressor-2.4.7/build/yuicompressor-2.4.7.jar  /usr/local/share/yui-compressor/yui-compressor.jar
rm -rf yuicompressor-2.4.7/


#create TR user
adduser tr

mkdir -p /etc/php_extra
#download new browscap
wget http://browscap.org/stream?q=PHP_BrowsCapINI -O /etc/php_extra/browscap.ini

#fpm config
TRFPMFILE=/etc/php-fpm.d/fpm-tr.conf
echo '[tr]' > $TRFPMFILE
echo 'user = tr' >> $TRFPMFILE
echo 'group = tr' >> $TRFPMFILE
echo 'listen = 127.0.0.1:9001' >> $TRFPMFILE
echo ';because of memory leak' >> $TRFPMFILE
echo 'pm.max_requests = 100' >> $TRFPMFILE
echo 'pm = dynamic' >> $TRFPMFILE
echo 'pm.max_children = 50' >> $TRFPMFILE
echo 'pm.start_servers = 5' >> $TRFPMFILE
echo 'pm.min_spare_servers = 5' >> $TRFPMFILE
echo 'pm.max_spare_servers = 35' >> $TRFPMFILE
echo 'php_admin_value[error_log] = /var/log/php-fpm/tr-error.log' >> $TRFPMFILE

#PHPINI
TRPHPINIDILE=/etc/php.d/php-tr.ini
echo '[PHP]' > $TRPHPINIDILE
echo 'realpath_cache_size=4096K' >> $TRPHPINIDILE
echo 'realpath_cache_ttl=600' >> $TRPHPINIDILE
echo 'upload_max_filesize = 20M' >> $TRPHPINIDILE
echo 'post_max_size = 20M' >> $TRPHPINIDILE
echo 'max_file_uploads = 50' >> $TRPHPINIDILE
echo '' >> $TRPHPINIDILE
echo '[Date]' >> $TRPHPINIDILE
echo 'date.timezone = "Europe/Prague"' >> $TRPHPINIDILE
echo '' >> $TRPHPINIDILE
echo '[opcache]' >> $TRPHPINIDILE
echo 'opcache.max_accelerated_files = 20000' >> $TRPHPINIDILE
echo '[browscap]' >> $TRPHPINIDILE
echo 'browscap = /etc/php_extra/browscap.ini' >> $TRPHPINIDILE


