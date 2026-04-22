# Cambiamos a una imagen de PHP limpia sin Apache
FROM php:8.4-cli

# Instalamos dependencias y extensiones (agregamos libsqlite3-dev por si acaso)
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copiamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . .

# Instalamos dependencias
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# En Railway, el puerto es dinámico. Usamos el comando "serve" de Laravel directamente.
# Esto evita todos los errores de configuración de Apache.
CMD php artisan serve --host=0.0.0.0 --port=$PORT