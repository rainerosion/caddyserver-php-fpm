FROM --platform=$TARGETPLATFORM caddy:alpine as caddy-build

FROM --platform=$TARGETPLATFORM php:8.3-fpm-alpine3.19
LABEL maintainer="rainerosion <admin@rainss.cn>"

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data
ENV CADDY_VERSION 2.7.6

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
    mailcap \
    supervisor
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
# web server and php-fpm
RUN set -eux; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
    apk update; \
    apk add --no-cache $RUN_DEPS; \
    usermod -u $UID -o $USER; \
    groupmod -g $GUID -o $USER; \
    apk add --no-cache --virtual .build-deps $BUILD_DEPS; \
    mkdir -p  \
      /config/caddy \
      /data/caddy \
      /etc/caddy \
      /usr/share/caddy  \
      /etc/supervisor/conf.d  \
      /srv ; \
    wget -O /etc/caddy/Caddyfile "https://p.iblog.site/https://github.com/caddyserver/dist/raw/cd39178d252a610fee6aa8465c787d9c780007a2/config/Caddyfile"; \
    wget -O /usr/share/caddy/index.html "https://p.iblog.site/https://github.com/caddyserver/dist/raw/cd39178d252a610fee6aa8465c787d9c780007a2/welcome/index.html"; \
    echo "<?php phpinfo();" > /usr/share/caddy/info.php; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
    	x86_64)  binArch='amd64' ;; \
    	armhf)   binArch='armv6' ;; \
    	armv7)   binArch='armv7' ;; \
    	aarch64) binArch='arm64' ;; \
    	ppc64el|ppc64le) binArch='ppc64le' ;; \
    	s390x)   binArch='s390x' ;; \
    	*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
    esac; \
    wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/caddy_${CADDY_VERSION}_linux_${binArch}.tar.gz"; \
    tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
    rm -f /tmp/caddy.tar.gz; \
    setcap cap_net_bind_service=+ep /usr/bin/caddy; \
    chmod +x /usr/bin/caddy; \
    caddy version; \
    docker-php-ext-configure gd --enable-gd --with-jpeg --with-webp --with-freetype; \
    docker-php-ext-install -j $(nproc) $PHP_EXTENSIONS; \
    pecl install -o -f redis; \
    pecl install memcached imagick; \
    docker-php-ext-enable redis memcached imagick; \
    apk del .build-deps; \
    curl --tlsv1 -v -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer;

COPY ../listener.php /srv/listener.php
COPY ../supervisord.conf /etc/supervisord.conf
COPY ../conf /etc/supervisor/conf.d/

EXPOSE 80
EXPOSE 443
EXPOSE 2019
EXPOSE 443/udp

WORKDIR /srv

CMD ["supervisord","-n","-c","/etc/supervisord.conf"]