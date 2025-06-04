ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-cli-alpine

# Nettoyer le cache après installation
RUN apk add --no-cache bash git curl zip nodejs npm \
 && npm install -g corepack \
 && corepack enable \
 && corepack prepare yarn@stable --activate \
 && npm cache clean --force

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions @composer apcu curl gd intl mbstring opcache pcov pdo pdo_mysql redis xml xdebug xsl zip

RUN mkdir -p /var/www/html \
 && git config --global --add safe.directory /var/www/html \
 && chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash
RUN apk add --no-cache symfony-cli

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/html/vendor/bin:${PATH}"

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
 && echo "date.timezone=Europe/Brussels" > /usr/local/etc/php/conf.d/timezone.ini