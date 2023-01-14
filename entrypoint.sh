(nginx -g 'daemon off;' && kill "$$") &
(php-fpm && kill "$$") &
wait