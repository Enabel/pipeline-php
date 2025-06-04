ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions @composer intl pdo pdo_mysql opcache zip gd redis xdebug pcov

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash 
RUN apt install symfony-cli -y

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/html/vendor/bin:${PATH}"    

RUN chown -R www-data:www-data /var/www/html
