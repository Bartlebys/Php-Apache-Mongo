FROM bartlebys/php-apache-mongo:latest
MAINTAINER Benoit Pereira da Silva <https://pereira-da-silva.com>

COPY /html /var/www/html/

################################
## CONFIGURE AND ENABLE XDEBUG #
################################

#Erase the current Configuration of xdebug
RUN     echo "" > /usr/local/etc/php/conf.d/xdebug.ini

#Configure XDEBUG
RUN     HOST_IN_CONTAINER_IP=$(/sbin/ip route|awk '/default/ { print $3 }')\
        &&echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_host=$HOST_IN_CONTAINER_IP" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_mode=req" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/xdebug.ini\
        && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini

# Enable XDEBUG's extension
RUN    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini