# Usamos la imagen oficial de PHP con Apache
FROM php:8.4-apache

# Instalamos dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# SOLUCIÓN AL ERROR MPM: Desactivamos mpm_event y activamos mpm_prefork
RUN a2dismod mpm_event && a2enmod mpm_prefork

# Habilitamos mod_rewrite de Apache para las rutas de Laravel
RUN a2enmod rewrite

# Copiamos Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Copiamos los archivos del proyecto
COPY . .

# Instalamos dependencias de Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Permisos para Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Configuramos Apache para que use la carpeta /public de Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configuramos el puerto dinámico de Railway
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# INICIAR APACHE (Cambiamos el comando artisan serve por apache)
CMD ["apache2-foreground"]