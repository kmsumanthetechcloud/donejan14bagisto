Dockerfile
ubuntu@ip-172-31-22-141:/home/test_bagisto/public_html/docker/php$ cat Dockerfile 
FROM php:8.3-fpm

########################################
# SYSTEM DEPENDENCIES
########################################
RUN apt-get update && apt-get install -y \
    git unzip curl zip mariadb-client \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    && docker-php-ext-install \
        gd \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        pcntl \
        bcmath \
        intl \
        calendar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

########################################
# COMPOSER
########################################
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

########################################
# APP CODE
########################################
WORKDIR /var/www
COPY . .

########################################
# 🔥 REQUIRED LARAVEL FOLDERS (FIX)
########################################
RUN mkdir -p \
    storage/framework/cache \
    storage/framework/sessions \
    storage/framework/views \
    bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap \
    && chmod -R 775 storage bootstrap

########################################
# PHP DEPENDENCIES
########################################
RUN composer install --no-dev --optimize-autoloader

########################################
# START PHP-FPM
########################################
CMD ["php-fpm"]
