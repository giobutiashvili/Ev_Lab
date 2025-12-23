# Base image PHP 8.1 + Apache
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    curl \
    npm \
    && docker-php-ext-install pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

RUN apt-get update && apt-get install -y unzip git libzip-dev zip curl \
    && docker-php-ext-install pdo_mysql zip mbstring tokenizer ctype xml
RUN mkdir -p /var/www/html/vendor && chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/www/html/vendor \
    && chown -R www-data:www-data /var/www/html
# Copy composer.lock and composer.json
COPY composer.json composer.lock ./

RUN docker-php-ext-install pdo_mysql zip mbstring tokenizer ctype xml
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Install Node dependencies & build assets
RUN npm install
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
