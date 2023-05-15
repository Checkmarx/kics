FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends zend-server-php-5.6=8.5.17+b19 \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/local/zend/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/local/zend/bin/php \
    && /usr/local/zend/bin/php composer.phar self-update && /usr/local/zend/bin/php composer.phar update