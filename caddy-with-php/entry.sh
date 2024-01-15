#!/bin/sh
if [ "${1}" = "-D" ]; then
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
else
    exec "$@"
fi

# first arg is `-f` or `--some-option`
#if [ "${1#-}" != "$1" ]; then
#	set -- php-fpm "$@"
#fi
#
#exec "$@"