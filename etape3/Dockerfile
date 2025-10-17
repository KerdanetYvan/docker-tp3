FROM php:fpm

RUN docker-php-ext-install mysqli && \ 
    docker-php-ext-enable mysqli

WORKDIR /var/www/html
COPY ./src/ /var/www/html/