FROM php:8.4-apache

# ---------- Actualización de paquetes ----------
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libsqlite3-dev \
    libonig-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite

# ---------- Activar mod_rewrite ----------
RUN a2enmod rewrite

# ---------- Configuración Apache ----------
RUN sed -i 's|/var/www/html|/var/www/public_html/public|g' /etc/apache2/sites-available/000-default.conf

# ---------- Configuración PHP recomendada ----------
RUN { \
        echo 'memory_limit=512M'; \
        echo 'upload_max_filesize=50M'; \
        echo 'post_max_size=50M'; \
        echo 'max_execution_time=180'; \
        echo 'date.timezone=America/Mexico_City'; \
    } > /usr/local/etc/php/conf.d/symfony.ini

# ---------- Composer ----------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ---------- Copiar la aplicación ----------
WORKDIR /var/www/public_html
COPY . /var/www/public_html

# ---------- Instalar dependencias Symfony ----------
RUN composer install --no-dev --optimize-autoloader

# ---------- Permisos para Symfony ----------
RUN mkdir -p var && \
    chown -R www-data:www-data var && \
    chown -R www-data:www-data public

# ---------- Optimizar Symfony ----------
RUN php bin/console cache:clear --env=prod && \
    php bin/console cache:warmup --env=prod

EXPOSE 80

CMD ["apache2-foreground"]
