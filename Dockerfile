FROM ubuntu:18.04
LABEL maintainer="hyperjiang@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /tmp/temp
WORKDIR /tmp/temp

COPY sources.list ./

RUN apt-get update && \
    apt-get install -y -q build-essential cron curl git gnupg net-tools unzip wget \
    libfreetype6-dev libpng-dev libssl-dev libxml2-dev librdkafka-dev zlib1g-dev libzip-dev libmcrypt-dev

RUN wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && cat ./sources.list >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y nginx

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

RUN apt-get install -y -q \
    php-bcmath \
    php-bz2 \
    php-curl \
    php-dev \
    php-fpm \
    php-gd \
    php-imap \
    php-intl \
    php-mbstring \
    php-mysql \
    php-pear \
    php-pgsql \
    php-soap \
    php-sqlite3 \
    php-tidy \
    php-xdebug \
    php-xml \
    php-xmlrpc \
    php-zip

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN pecl channel-update pecl.php.net
RUN echo "\n" | pecl install apcu-5.1.18
RUN pecl install grpc-1.29.1;
RUN echo "\n" | pecl install mcrypt-1.0.3;
RUN pecl install mongodb-1.7.4;
RUN pecl install protobuf-3.12.2;
RUN pecl install rdkafka-4.0.3;
RUN echo "\n\n" | pecl install redis-5.2.2;
RUN pecl install seaslog-2.1.0;
RUN echo "yes\nyes\nyes\nyes\n" | pecl install swoole-4.5.2;
RUN pecl install yac-2.2.1;
RUN pecl install yaf-3.2.3;

COPY conf/apcu.ini /etc/php/7.2/mods-available/apcu.ini
COPY conf/grpc.ini /etc/php/7.2/mods-available/grpc.ini
COPY conf/mcrypt.ini /etc/php/7.2/mods-available/mcrypt.ini
COPY conf/mongodb.ini /etc/php/7.2/mods-available/mongodb.ini
COPY conf/protobuf.ini /etc/php/7.2/mods-available/protobuf.ini
COPY conf/rdkafka.ini /etc/php/7.2/mods-available/rdkafka.ini
COPY conf/redis.ini /etc/php/7.2/mods-available/redis.ini
COPY conf/seaslog.ini /etc/php/7.2/mods-available/seaslog.ini
COPY conf/swoole.ini /etc/php/7.2/mods-available/swoole.ini
COPY conf/yac.ini /etc/php/7.2/mods-available/yac.ini
COPY conf/yaf.ini /etc/php/7.2/mods-available/yaf.ini
RUN ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/fpm/conf.d/20-apcu.ini
RUN ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/cli/conf.d/20-apcu.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/fpm/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/cli/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/fpm/conf.d/20-mcrypt.ini
RUN ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/cli/conf.d/20-mcrypt.ini
RUN ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/fpm/conf.d/20-mongodb.ini
RUN ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/cli/conf.d/20-mongodb.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/fpm/conf.d/20-protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/cli/conf.d/20-protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/fpm/conf.d/20-rdkafka.ini
RUN ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/cli/conf.d/20-rdkafka.ini
RUN ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/fpm/conf.d/20-redis.ini
RUN ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/cli/conf.d/20-redis.ini
RUN ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/fpm/conf.d/20-seaslog.ini
RUN ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/cli/conf.d/20-seaslog.ini
RUN ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/20-swoole.ini
RUN ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/20-swoole.ini
RUN ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/fpm/conf.d/20-yac.ini
RUN ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/cli/conf.d/20-yac.ini
RUN ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/fpm/conf.d/20-yaf.ini
RUN ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/cli/conf.d/20-yaf.ini

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
    && rm -Rf /etc/nginx/conf.d
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/sites-available/default.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
COPY index.php /app/public/index.php

COPY start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]
