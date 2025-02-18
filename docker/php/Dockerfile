# Offical Docker Image for PHP
# https://hub.docker.com/_/php
FROM php:8.4-fpm

# Set Current Directory
WORKDIR /var/www/vhost/

# Install dependencies
RUN apt-get clean && apt-get update && apt-get upgrade -y && apt-get install -y \
    autoconf \
    pkg-config \
    git \
    libcurl4-openssl-dev \
    libonig-dev \
    libpng-dev \
    libssl-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    wget \
    zip \
    tzdata \
    libpq-dev \
    libsqlite3-dev \
    libjpeg-dev \
    libfreetype6-dev \
    curl

RUN docker-php-ext-configure intl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# PHP Extensions

RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd

RUN docker-php-ext-install -j$(nproc) \
    mysqli \
    opcache \
    pdo_mysql \
    pcntl \
    xml \
    zip \
    intl

RUN docker-php-ext-install -j$(nproc) \
    pdo_pgsql \
    pgsql

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install pnpm globally
RUN npm install -g pnpm

# Set the custom cache directory for pnpm
ENV XDG_CACHE_HOME=/tmp
ENV PNPM_CACHE_DIR=/tmp/.pnpm-cache

# Install Composer from Official Docker Image
# https://hub.docker.com/_/composer
COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

# Install phpredis extension
RUN pecl install redis && docker-php-ext-enable redis
