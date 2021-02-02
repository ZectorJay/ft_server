FROM debian:buster

#updating OS + wget
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget

EXPOSE 80
EXPOSE 443

#install all things
RUN apt-get -y install nginx
RUN apt-get -y install php-fpm php-mysql
RUN apt-get -y install mariadb-server
RUN apt-get -y install vim


RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-latest-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.4-all-languages phpmyadmin
RUN mv phpmyadmin /var/www/html/

#nginx config to make localhost active and restarting to apply
COPY /srcs/default /etc/nginx/sites-available/


#instal wordpress + unpack
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz && rm latest.tar.gz
RUN mv wordpress /var/www/html/
COPY srcs/wp-config.php /var/www/html/wordpress/wp-config.php
RUN chmod 755 var/www/html/*

RUN openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=RU/ST=Ivanovo/L=IVANOVO/O=42Kazan/OU=Ivan/CN=localhost" -keyout /etc/ssl/cert.key -out /etc/ssl/bundle.crt
RUN chmod 600 /etc/ssl/cert.key /etc/ssl/bundle.crt

#закидываю всякие настройки в контейнер и оттуда запускаю их
#среди них - установка wp, запуск mysql
#создание базы данных и пользователя в ней
COPY /srcs/launch.sh /
RUN chmod 755 /launch.sh
CMD /launch.sh
