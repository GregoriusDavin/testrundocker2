FROM php:8.2-fpm

#working directory
WORKDIR /var/www/html 

#dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip syslog-ng libpq-dev \
    git curl \
    lua-zlib-dev \
    libmemcached-dev \
    nginx syslog-ng libpq-dev build-essential libssl-dev zlib1g-dev libjpeg-dev libgmp-dev libicu-dev freetds-dev libaspell-dev libsnmp-dev libtidy-dev libxslt-dev libzip-dev libonig-dev libbz2-dev libmcrypt-dev libxslt-dev curl libcurl4-openssl-dev libedit-dev apt-utils libxml2-dev

#install php 
RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath curl mbstring

#install supervisor
RUN apt-get -y update
RUN apt-get install -y supervisor

#clear cache 
RUN rm -rf *
RUN apt-get clean && rm -rf /var/lib/apt/lists*

COPY . .

#PHP log
RUN mkdir /var/log/php
RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

#add laravel user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www
RUN chmod -R ug+w /var/www/html/storage
RUN chmod -R 777 /var/www/html/storage/

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
RUN composer install --ignore-platform-reqs
RUN composer dump-autoload
RUN php artisan optimize

ADD entrypoint.sh /root/entrypoint.sh

EXPOSE 80