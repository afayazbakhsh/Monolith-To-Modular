FROM php:8.1.10-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    tzdata\
    git \
    unzip \
    zip \
    curl \
    libreoffice-writer\
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libgd-dev

# These optimizers have been suggested by "spatie" in order to optimize images.
# Github: https://github.com/spatie/laravel-image-optimizer
# Github: https://github.com/spatie/image-optimizer
RUN apt-get install -y \
     jpegoptim \
     optipng \
     pngquant \
     gifsicle \
     webp


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install pdo_mysql exif pcntl soap zip gd bcmath

##install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start bash server
EXPOSE 9000
CMD ["php-fpm"]