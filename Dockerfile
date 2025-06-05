ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-cli

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get clean  \
 && rm -rf /var/lib/apt/lists/*  \
 && apt-get update --fix-missing  \
 && apt-get install -y --no-install-recommends \
        git \
        curl \
        ca-certificates \
        bash \
        zip \
        default-mysql-client \
        netcat-traditional \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install PHP extensions using mlocati/php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions @composer apcu bcmath curl gd intl mbstring opcache pcov pdo pdo_mysql redis xml xdebug xsl zip

# Configure directories and permissions
RUN mkdir -p /var/www/html \
 && git config --global --add safe.directory /var/www/html \
 && chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

# Install Symfony CLI
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
 && apt-get update  \
 && apt-get install -y symfony-cli \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="/var/www/html/vendor/bin:${PATH}"

# Configure PHP settings
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
 && echo "date.timezone=Europe/Brussels" > /usr/local/etc/php/conf.d/timezone.ini

# Install Node.js and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash \
 && apt-get install -y nodejs \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && npm install -g corepack \
 && corepack enable \
 && corepack prepare yarn@stable --activate \
 && npm cache clean --force

# Installer .NET Core (Required for Azure DevOps tasks)
RUN apt-get update  \
 && apt-get install -y wget apt-transport-https software-properties-common \
 && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y dotnet-runtime-6.0 \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && rm packages-microsoft-prod.deb
