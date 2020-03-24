FROM php:7.4-fpm-alpine


# Install packages
RUN apk --no-cache add nginx supervisor curl tzdata mysql-client

RUN docker-php-ext-install mysqli pdo_mysql && docker-php-ext-enable mysqli

RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && echo "Europe/Berlin" > /etc/timezone

# Configure nginx
COPY ./config/local/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY ./config/local/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY ./config/local/php.ini /etc/php7/conf.d/zzz_custom.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

# Configure supervisord
COPY ./config/local/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# setup for tinker
RUN mkdir -p /var/tmp/nginx

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/tmp/nginx && \
  chown -R nobody.nobody /var/log/nginx

COPY ./config/local/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html

# install wordpress
RUN wp core download

# Expose the port nginx is reachable on
EXPOSE 8080


# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

# just local env
ENTRYPOINT sh /entrypoint.sh && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf