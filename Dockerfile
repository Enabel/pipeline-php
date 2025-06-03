ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    curl \
    && docker-php-ext-install intl pdo pdo_mysql opcache zip gd

# Installation de Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Installation de symfony-cli
RUN wget https://get.symfony.com/cli/installer -O - | bash \
    && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Configuration recommandée pour Symfony
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Variables d'environnement pour Symfony
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    SYMFONY_ALLOW_APPDEV=1 \
    PATH="/var/www/html/vendor/bin:${PATH}"

# Droits sur le dossier de travail
RUN chown -R www-data:www-data /var/www/html

# Exposer le port 9000 (php-fpm)
EXPOSE 9000

CMD ["php-fpm"]