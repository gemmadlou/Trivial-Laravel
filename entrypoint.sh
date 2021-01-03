#!/bin/sh *
# Alpine shell is `sh`
# Provision the environment in here!

function Permission {

  echo "Ensuring laravel logs directory existence and permissions..."
  mkdir -p storage/logs
  mkdir -p storage/app/public
  mkdir -p storage/framework/cache
  mkdir -p storage/framework/cache/data
  mkdir -p storage/framework/sessions
  mkdir -p storage/framework/testing
  mkdir -p storage/framework/views
  chown -R 1000:1000 storage
  chmod -R 0777 storage

  mkdir -p bootstrap/cache/data
  chown -R 1000:1000 bootstrap/cache
  chmod -R 0777 bootstrap/cache
}

function Decache {
    echo "Decaching"
    php artisan config:clear
    php artisan cache:clear
    php artisan view:clear
    php artisan route:clear
}

function Optimize {
  echo "Optimizing"
  composer dump-autoload --no-dev -o
  php artisan config:cache
  php artisan route:cache
  php artisan view:cache
  echo "Optimizing done"
}

case $1 in

  server)
    Permission

    echo "Listening on http://localhost:${DOCKER_WEBSERVER_PORT}"

    php-fpm
  ;;

  server:production)
    Permission
    Optimize
    php-fpm
  ;;

  *)
    echo "Running container commands..."
    exec "$@"
  ;;

esac

exit 0