# Use the official PHP image with Apache
FROM php:7.4-apache

# Expose HTTP port
EXPOSE 80

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo pdo_mysql mysqli zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy project files into container
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy environment variables (ensure .env exists in repo)
COPY .env /var/www/html/.env

# Optional: disable the installer (skip DB page)
RUN if [ -f /var/www/html/install/index.php ]; then mv /var/www/html/install/index.php /var/www/html/install/index.php.disabled; fi

# Default command
CMD ["apache2-foreground"]
