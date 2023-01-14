#!/bin/sh
if [ $NGINX_EXTRA_CONFIG ]; then
    echo "$NGINX_EXTRA_CONFIG" > /etc/nginx/vhost_extra_config
fi

(nginx && kill "$$") &
(php-fpm && kill "$$") &
wait