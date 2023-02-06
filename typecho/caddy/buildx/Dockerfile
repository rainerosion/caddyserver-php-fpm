FROM --platform=$TARGETPLATFORM composer:latest as composer-build

FROM --platform=$TARGETPLATFORM php:8.1.15-fpm-alpine3.17
MAINTAINER rainerosion "admin@rainss.cn"

COPY --from=composer-build /usr/bin/composer /usr/bin/composer
COPY Caddyfile /etc/caddy/Caddyfile
ENV BUILD_DEPS \
    libzip-dev \
    icu-dev \
    postgresql-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    curl-dev \
    sqlite-dev \
    oniguruma-dev \
    libmemcached-dev

ENV RUN_DEPS \
    autoconf \
    g++ \
    make \
    libzip \
    icu \
    postgresql-libs \
    libpng \
    libwebp \
    libjpeg-turbo \
    curl \
    sqlite-libs \
    oniguruma \
    libmemcached

ENV PHP_EXTENSIONS \
    zip \
    intl \
    exif \
    pdo_mysql \
    pdo_pgsql \
    mysqli \
    pgsql \
    gd \
    curl \
    session \
    pdo_sqlite \
    fileinfo \
    mbstring

RUN set -eux && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache $RUN_DEPS && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
    docker-php-ext-configure gd --enable-gd --with-jpeg --with-webp && \
    docker-php-ext-install -j $(nproc) $PHP_EXTENSIONS && \
    pecl install redis memcached  && \
    docker-php-ext-enable redis memcached && \
    apk del .build-deps