## PHP 7.4 from docker hub bitnami
FROM bitnami/php-fpm:7.4-debian-11

## Install Apache Web Server and php module
RUN apt update; apt upgrade -y; apt install apache2 libapache2-mod-php -y;

## Copy Apache Web Server-PHP 7.4 contact Configure File
COPY php74.conf /etc/apache2/conf-enabled/php74.conf

## Use TCP Port for Web Server
EXPOSE 80
EXPOSE 443
EXPOSE 9000

## Use Volume of Pukiwiki Files; Or Custom PHP engine files
# VOLUME /var/www/html

## Run Apache Web Server and PHP at the same time
ENTRYPOINT bash -c "source /etc/apache2/envvars && apache2 && php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid -y /opt/bitnami/php/etc/php-fpm.conf"
