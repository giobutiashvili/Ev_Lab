FROM php:8.1-apache

# Workdir
WORKDIR /var/www/html

# Apache rewrite (Laravel routing)
RUN a2enmod rewrite

# System deps + PHP extensions (ONLY REQUIRED)
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libzip-dev \
    libonig-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo_mysql zip mbstring

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project
COPY . .

# PHP deps
RUN composer install --no-dev --optimize-autoloader

# Frontend build
RUN npm install && npm run build

# Permissions
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# Apache serves /public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf

EXPOSE 80

CMD ["apache2-foreground"]
