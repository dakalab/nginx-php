FROM ubuntu:18.04
LABEL maintainer="hyperjiang@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /tmp/temp
WORKDIR /tmp/temp

COPY sources.list ./

RUN apt-get update && \
    apt-get install -y -q build-essential cron curl git gnupg net-tools wget

RUN wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && cat ./sources.list >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y nginx

RUN apt-get install -y -q php-fpm \
    php-dev \
    php-bz2 \
    php-curl \
    php-gd \
    php-imap \
    php-intl \
    php-mbstring \
    php-mysql \
    php-pgsql \
    php-soap \
    php-tidy \
    php-xdebug \
    php-xmlrpc \
    php-zip

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# clean up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/temp/

RUN mkdir /app
WORKDIR /app

EXPOSE 443 80

RUN mkdir -p /etc/nginx/sites-available/ \
    && mkdir -p /etc/nginx/sites-enabled/ \
    && mkdir -p /etc/nginx/ssl/ \
    && rm -Rf /etc/nginx/conf.d
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx-site.conf /etc/nginx/sites-available/default.conf
COPY conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
COPY index.php /app/index.php

COPY start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]
