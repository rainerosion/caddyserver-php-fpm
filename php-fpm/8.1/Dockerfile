FROM composer:latest as composer-build

FROM php:8.1-fpm-alpine3.17
MAINTAINER rainerosion "admin@rainss.cn"

COPY --from=composer-build /usr/bin/composer /usr/bin/composer
# build dependencies
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
    libmemcached-dev \
    zlib-dev \
    imagemagick-dev \
    freetype-dev
# runtime dependencies
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
    libmemcached \
    shadow \
    zlib \
    imagemagick \
    freetype
# php extensions
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
    mbstring \
    bcmath
# set default uid and gid for www-data
ARG UID=1000
ARG GUID=1000
# fpm user
ARG USER=www-data
RUN set -eux && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache $RUN_DEPS && \
    usermod -u $UID -o $USER && \
    groupmod -g $GUID -o $USER && \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS && \
    docker-php-ext-configure gd --enable-gd --with-jpeg --with-webp --with-freetype && \
    docker-php-ext-install -j $(nproc) $PHP_EXTENSIONS && \
    pecl install redis memcached imagick && \
    docker-php-ext-enable redis memcached imagick && \
    apk del .build-deps