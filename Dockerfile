# Use the official PHP image as the base image
FROM php:7.3-apache

# Set the working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zip \
    libzip-dev \
    unzip

# Clear the application cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure and install the GD library
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

# Install other PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy the Laravel application into the container
COPY . /var/www/html

# Set proper permissions for the Laravel application
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the custom Apache configuration file
COPY laravel.conf /etc/apache2/conf-available/laravel.conf

# Enable the new configuration
RUN a2enconf laravel

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
