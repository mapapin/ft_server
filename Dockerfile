FROM debian:buster

MAINTAINER mapapin <mapapin@student.42.fr>

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli php-mbstring
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install mariadb-server

COPY ./srcs/init.sh ./
COPY ./srcs/nginx-conf ./tmp/nginx-conf
COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
COPY ./srcs/wp-config.php ./tmp/wp-config.php

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD sh init.sh
