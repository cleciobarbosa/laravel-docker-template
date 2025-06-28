# my-laravel-app/Dockerfile
FROM php:8.3-fpm

# Install system dependencies required for PHP extensions
# Use apt-get for Debian-based images (like php:8.3-fpm)
RUN apt-get update && \
    apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    libxpm-dev \
    zlib1g-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instale extensões PHP necessárias para Laravel e GD
# Certifique-se de que gd está listado APÓS suas dependências de sistema serem instaladas
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm && \
    docker-php-ext-install pdo_mysql exif pcntl bcmath gd sockets zip

# Instale o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Copie os arquivos da aplicação para o contêiner
COPY . .

# Permissões para o diretório de armazenamento e cache
# CORREÇÃO AQUI: o grupo deve ser 'www-data', não 'www-data:www:data'
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Instale as dependências do Composer
RUN composer install --no-dev --optimize-autoloader

# Gere a chave da aplicação Laravel (se ainda não tiver uma)
RUN if [ ! -f .env ] || ! grep -q "APP_KEY=" .env; then php artisan key:generate; fi

# Exponha a porta 9000 para o PHP-FPM
EXPOSE 9000