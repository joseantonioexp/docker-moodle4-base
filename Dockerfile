FROM php:8.0-apache

ENV PHP_INI_DIR /usr/local/etc/php
COPY ./php.ini "$PHP_INI_DIR/php.ini"

RUN apt-get -y update && apt-get install -y \
    g++ \
    libzip-dev \
    libxml2-dev \
    libicu-dev \
    libpng-dev \
    zlib1g-dev 

RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql && docker-php-ext-install pgsql
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip
RUN docker-php-ext-install opcache
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN apt-get install -y libxml2-dev
RUN pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3  xmlrpc
RUN docker-php-ext-install soap
RUN apt-get install -y locales locales-all


# Redis
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis


WORKDIR /var/www/html/
RUN mkdir /var/www/moodledata


RUN chown -R www-data:www-data /var/www/moodledata
RUN chmod 777 /var/www/moodledata

#COPY ./src /var/www/html
COPY ./config.php /var/www/html/config.php
RUN chown -R www-data:www-data /var/www/html/*

RUN apt-get update && \
    apt-get -y install tzdata cron

RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
    echo "Europe/Madrid" > /etc/timezone

RUN env >> /etc/environment
#RUN apt-get -y remove tzdata
RUN rm -rf /var/cache/apk/*
# Copy cron file to the cron.d directory
COPY cron /etc/cron.d/cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cron
# Apply cron job
RUN crontab /etc/cron.d/cron
# Create the log file to be able to run tail
RUN mkdir -p /var/log/cron

RUN groupadd crond-users && \
    chgrp crond-users /var/run/crond.pid && \
    usermod -a -G crond-users 


# Add a command to base-image entrypont scritp
COPY apache2-foreground /usr/local/bin/apache2-foreground
RUN chmod +x /usr/local/bin/apache2-foreground
