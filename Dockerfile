# Usamos la imagen oficial de PHP con Apache
FROM php:8.4-apache

# Instalamos dependencias del sistema y extensiones de PHP necesarias para Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Habilitamos mod_rewrite de Apache (necesario para las rutas de Laravel)
RUN a2enmod rewrite

# Copiamos Composer desde su imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Copiamos todos los archivos de tu proyecto al contenedor
COPY . .

# ¡El método Composer! Instalamos las dependencias de Laravel
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Damos permisos a las carpetas que Laravel necesita para escribir
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Cambiamos el DocumentRoot de Apache a la carpeta "public" de Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Railway inyecta una variable $PORT dinámica. Configuramos Apache para que escuche en ese puerto.
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Comando por defecto para iniciar Apache
CMD ["apache2-foreground"]