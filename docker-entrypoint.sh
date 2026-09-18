#!/bin/sh
# docker-entrypoint.sh

# Change ownership for volume if the volume is empty
if [ -z "$(ls -A /var/www/html/var/persistent)" ]; then
  chown -R www-data:www-data /var/www/html/var/persistent
fi

exec "$@"