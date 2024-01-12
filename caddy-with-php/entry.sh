#!/bin/sh
if [ "${1}" = "-D" ]; then
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
else
    exec "$@"
fi