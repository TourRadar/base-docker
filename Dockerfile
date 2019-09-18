FROM centos:7
LABEL maintainer="Krzysztof Bednarczyk <chris@tourradar.com>"

RUN yum -y install telnet wget pstree bind-utils logwatch psmisc sudo cronie git mc iproute epel-release \
  && wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
  && rpm -Uvh remi-release-7.rpm \
  && yum-config-manager --enable remi \
  && yum-config-manager --enable remi-php71 \
  && yum -y install httpd mod_ssl php php-fpm php-opcache php-common php-cli php-bcmath php-mbstring php-pdo php-process php-xml php-soap php-redis php-mysql \
  && curl -sL https://rpm.nodesource.com/setup_11.x | bash - \
  && yum -y install nodejs-11.15.0 composer \
  && npm install -g gulp bower \
  && wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm \
  && rpm -ivh mysql-community-release-el7-5.noarch.rpm \
  && yum -y install mysql \
  && rm -f /etc/localtime \
  && ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime \
  && adduser tr \
  && mkdir -p /etc/php_extra /run/php-fpm/ \
  && wget http://browscap.org/stream?q=PHP_BrowsCapINI -O /etc/php_extra/browscap.ini \
  && rm -rf *.rpm \
  && yum clean all

ADD files/fpm-tr.conf /etc/php-fpm.d/fpm-tr.conf
ADD files/php-tr.ini /etc/php.d/php-tr.ini
