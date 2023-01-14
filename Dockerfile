FROM php:7.4-fpm-alpine
RUN docker-php-source extract && \
        apk update && \
        apk add --no-cache autoconf build-base && \
        MAKEFLAGS="-j $(nproc)" pecl install redis && \
        apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev freetype libjpeg-turbo libpng && \
        docker-php-ext-configure gd --with-freetype --with-jpeg && \
        docker-php-ext-configure mysqli && \
        docker-php-ext-install -j$(nproc) gd && \
        docker-php-ext-install -j$(nproc) mysqli && \
        docker-php-ext-enable gd opcache redis mysqli && \
        docker-php-source delete && \
        apk del autoconf build-base freetype-dev libjpeg-turbo-dev libpng-dev --purge && \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
