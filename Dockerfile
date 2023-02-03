FROM caddy:alpine as caddy
FROM php:8-fpm-alpine
# 复制caddy相关文件
COPY --from=caddy /config /config
COPY --from=caddy /data /data
COPY --form=caddy /etc/caddy /etc/caddy
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

RUN set -eux && \
	apk update &&\
	apk add --no-cache  \
    openssl  \
    openssl-dev  \
    autoconf  \
    g++  \
    make  \
    pcre-dev  \
    icu-dev  \
    ca-certificates  \
    mailcap  \
    postgresql-libs  \
    zlib \
    zlib-dev \
    libzip \
    libzip-dev \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libxslt \
    libxslt-dev \
    postgresql-libs \
    postgresql-dev \
    libgcrypt-dev &&\
	docker-php-ext-install -j "$(nproc)" exif zip mysqli  pdo_mysql mbstring bcmath intl opcache sockets pcntl pgsql pdo_pgsql gd &&\
    docker-php-ext-configure gd --with-jpeg &&\
    pecl install redis &&\
    docker-php-ext-enable redis