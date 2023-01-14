FROM php:7.4-fpm-alpine
RUN docker-php-source extract && \
        apk update && \
        apk add freetype-dev libjpeg-turbo-dev libpng-dev && \
        docker-php-ext-configure gd --with-freetype --with-jpeg && \
        docker-php-ext-configure mysqli && \
        docker-php-ext-install -j$(nproc) gd && \
        docker-php-ext-install -j$(nproc) mysqli && \
        MAKEFLAGS="-j $(nproc)" pecl install redis && \
        docker-php-ext-enable gd opcache redis mysqli && \
        docker-php-source delete && \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
