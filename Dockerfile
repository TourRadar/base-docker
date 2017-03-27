FROM centos:7

MAINTAINER Krzysztof Bednarczyk <chris@tourradar.com>

COPY install.sh /tmp/install.sh


RUN sh /tmp/install.sh