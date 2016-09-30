FROM php:5.6-apache
MAINTAINER Benoit Pereira da Silva <https://pereira-da-silva.com>

## Let's update apt-get (once)
RUN apt-get update

## Nano
RUN apt-get install -y nano

## Vim
RUN apt-get install -y vim


###############
#  Apache
###############

# Enable apache mods.
RUN a2enmod rewrite

###############
#   Mongo DB
###############

RUN apt-get install -y mongodb

################
#   PHP
################

# # # # # # # # # # # # # # # # # # # # # # # #
# Notes from https://hub.docker.com/_/php/
#
#  PHP Core Extensions :
#
#  For iconv, mcrypt and gd extensions, you can inherit the base image that you like, and write your own Dockerfile like this:
#
#   RUN apt-get update && apt-get install -y \
#           libfreetype6-dev \
#           libjpeg62-turbo-dev \
#           libmcrypt-dev \
#           libpng12-dev \
#      && docker-php-ext-install -j$(nproc) iconv mcrypt \
#      && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#      && docker-php-ext-install -j$(nproc) gd
#
#
#  PECL : (compiling extension)
#
#
# To install a PECL extension, use "pecl install" to download and compile it,
# then use "docker-php-ext-enable" to enable it
#
# e.g : memcached
#
#   RUN apt-get update && apt-get install -y libmemcached-dev \
#       && pecl install memcached \
#       && docker-php-ext-enable memcached
#
#
# # # # # # # # # # # # # # # # # # # # # # # #

# mcrypt
RUN apt-get install -y libmcrypt-dev
RUN docker-php-ext-install -j$(nproc) mcrypt

# iconv
RUN docker-php-ext-install -j$(nproc) iconv

# semaphore
RUN docker-php-ext-install -j$(nproc) sysvsem

# mongo

# We try both
RUN pecl install mongodb
RUN pecl install mongo &&\
    echo "extension=mongo.so" > /usr/local/etc/php/conf.d/ext-mongo.ini

# XDEBUG
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini
