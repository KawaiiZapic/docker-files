#!/bin/sh
(nginx && kill "$$") &
(php-fpm && kill "$$") &
wait