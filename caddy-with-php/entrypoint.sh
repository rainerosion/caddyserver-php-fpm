#!/bin/sh
set -e
# php-fpm daemonize
php-fpm -D
# start caddy
exec "$@"