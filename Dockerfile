FROM php:7.4-fpm-alpine

COPY entrypoint.sh /

RUN     apk add --no-cache openssl curl ca-certificates && \
        printf "%s%s%s%s\n" \
                "@nginx " \
                "http://nginx.org/packages/alpine/v" \
                `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
                "/main" \
                | tee -a /etc/apk/repositories && \
        curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub && \
        openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout && \
        mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ && \
        apk del openssl curl ca-certificates --purge && \
        apk add --no-cache nginx@nginx 

RUN     docker-php-source extract && \
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
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
        chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]