#------------------------------------------
FROM php:8.0.0-fpm-alpine3.12 AS development
#------------------------------------------

WORKDIR /var/www

RUN apk update

RUN apk add --update --no-cache \
    nodejs \
    npm \
    yarn \
    curl \
    libzip-dev \
    mysql-client \
    zip \
    gnu-libiconv \
    --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted

RUN docker-php-ext-install zip pdo pdo_mysql mysqli

COPY --from=composer:2.0.6 /usr/bin/composer /usr/bin/composer

ENV PATH /opt/bin:$PATH

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENTRYPOINT [ "sh", "/var/www/entrypoint.sh" ]

CMD [ "server" ]

#------------------------------------------
FROM development AS test
#------------------------------------------


COPY . /var/www

RUN yarn install --frozen-lockfile \
    && yarn prod \
    && rm -rf node_modules

RUN composer install

RUN php artisan test

#------------------------------------------
FROM development AS production
#------------------------------------------

COPY --from=test /var/www /var/www

RUN rm -rf /var/www/vendor

RUN composer install --no-dev \
    --ignore-platform-reqs \
    --no-scripts \
    --no-interaction \
    --no-progress

CMD [ "server:production" ]