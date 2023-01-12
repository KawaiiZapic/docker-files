FROM php:7.4-apache
RUN docker-php-source extract && \
        apt update && \
        apt install libfreetype6-dev libjpeg62-turbo-dev libpng-dev -y && \
        docker-php-ext-configure gd --with-freetype --with-jpeg && \
        docker-php-ext-configure mysqli && \
        docker-php-ext-install -j$(nproc) gd && \
        docker-php-ext-install -j$(nproc) mysqli && \
        MAKEFLAGS="-j $(nproc)" pecl install redis && \
        docker-php-ext-enable gd opcache redis mysqli && \
        a2enmod rewrite proxy proxy_http && \
        docker-php-source delete && \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
