FROM alpine:3.21
RUN apk update
RUN apk add --no-cache bash php8 curl supervisor redis php8-zlib php8-xml php8-phar php8-intl php8-dom php8-xmlreader php8-ctype php8-session php8-mbstring php8-tokenizer php8-gd php8-redis php8-bcmath php8-iconv php8-pdo php8-posix php8-gettext php8-simplexml php8-sodium php8-sysvsem php8-fpm php8-mysqli php8-json php8-openssl php8-curl php8-sockets php8-zip php8-pdo_mysql php8-xmlwriter php8-opcache php8-gmp php8-pdo_sqlite php8-sqlite3 php8-pcntl php8-fileinfo git mailcap libcap

RUN mkdir /www
RUN mkdir /wwwlogs
RUN mkdir -p /run/php
RUN mkdir -p /run/caddy
RUN mkdir -p /run/supervisor

COPY config/php-fpm.conf /etc/php8/php-fpm.d/www.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apkArch="$(apk --print-arch)"; \
    case "${apkArch}" in \
        aarch64) arch='arm64' ;; \
        x86_64) arch='amd64' ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    url="https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_v2.8.4_linux_${arch}.tar.gz"; \
    curl --silent --show-error --fail --location --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - ${url} | tar --no-same-owner -C /usr/bin/ -xz caddy && \
    chmod 0755 /usr/bin/caddy && \
    addgroup -S caddy && \
    adduser -D -S -s /sbin/nologin -G caddy caddy && \
    setcap cap_net_bind_service=+ep `readlink -f /usr/bin/caddy` && \
    /usr/bin/caddy -version

WORKDIR /www
EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
