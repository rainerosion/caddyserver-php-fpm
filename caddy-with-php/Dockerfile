FROM caddy:alpine as caddy-build

FROM php:8.3-fpm-alpine3.19
LABEL maintainer="rainerosion <admin@rainss.cn>"

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
    freetype \
    ca-certificates \
    libcap \
    mailcap
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
    pecl install -o -f redis && \
    pecl install memcached imagick && \
    docker-php-ext-enable redis memcached imagick && \
    apk del .build-deps \

# web server
RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='b74311ec8263f30f6d36e5c8be151e8bc092b377789a55300d5671238b9043de5bd6db2bcefae32aa1e6fe94c47bbf02982c44a7871e5777b2596fdb20907cbf' ;; \
		armhf)   binArch='armv6'; checksum='88756642ca412db3a8da7a40b518861a6f524a8ac704021e8451d3cb38746f24243b1e561f4eec07e1575200d06bfd098783d2b7ee7ee07a971aed1c677da6e6' ;; \
		armv7)   binArch='armv7'; checksum='118776e879c280556abb7c03ff7c0081eda23c2aee0472aef176f733785e9501defaeaf334cd2443e31294809beafaea831d2e695aa68045160082aa3a966e2f' ;; \
		aarch64) binArch='arm64'; checksum='62252ade5e8dcec13a66154ee1978d959370be049cce52e7c4edefff14ef70bbb21630e3735092719bc3c31214e89dff99e55970ff0adec8ac0a94c6415b059a' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='65d27fe53f5e4fa79f3476f8902071c907aab74db1a2616342be3714d4252219fbb53b174ef588e20c51e7cfac84376c7a0a608091c2fe83b31dbf59dabeb237' ;; \
		s390x)   binArch='s390x'; checksum='c562190962a2db0248a4190616dd2ebaa02df2cf62f1a2c71f9d9de18af2a297df8000a06a11e8d3929dfd64f0c081d1e61961687ca220007459f2dbd0be2c81' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version \
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data
EXPOSE 80 443 2019
EXPOSE 443/udp
WORKDIR /srv