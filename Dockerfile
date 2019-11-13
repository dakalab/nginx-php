FROM ubuntu:18.04
LABEL maintainer="hyperjiang@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /tmp/temp
WORKDIR /tmp/temp

COPY sources.list ./

RUN apt-get update && \
    apt-get install -y -q build-essential cron curl git gnupg net-tools wget zlib1g-dev

RUN wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && cat ./sources.list >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y nginx

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

RUN apt-get install -y -q php-fpm \
    php-dev \
    php-bz2 \
    php-curl \
    php-gd \
    php-imap \
    php-intl \
    php-mbstring \
    php-mysql \
    php-pear \
    php-pgsql \
    php-sqlite3 \
    php-soap \
    php-tidy \
    php-xdebug \
    php-xmlrpc \
    php-zip

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN pecl channel-update pecl.php.net && pecl install grpc-1.25.0 protobuf-3.10.0

COPY conf/grpc.ini /etc/php/7.2/mods-available/grpc.ini
COPY conf/protobuf.ini /etc/php/7.2/mods-available/protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/fpm/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/cli/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/fpm/conf.d/20-protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/cli/conf.d/20-protobuf.ini

RUN sed -i \
        -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size = 8M/post_max_size = 100M/g" \
        -e "s/short_open_tag = Off/short_open_tag = On/g" \
        /etc/php/7.2/fpm/php.ini

# clean up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/temp/

RUN mkdir -p /app/public
WORKDIR /app

EXPOSE 443 80

RUN mkdir -p /etc/nginx/sites-available/ \
    && mkdir -p /etc/nginx/sites-enabled/ \
    && mkdir -p /etc/nginx/certs/ \
    && rm -Rf /etc/nginx/conf.d
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx-site.conf /etc/nginx/sites-available/default.conf
COPY conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
COPY index.php /app/public/index.php

COPY start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]
