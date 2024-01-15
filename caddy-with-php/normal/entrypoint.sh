#!/bin/sh
set -e
# php-fpm daemonize
php-fpm -D
# execute cmd
exec "$@"