FROM php:8.2-apache

# 1. Installer les extensions système et PHP nécessaires à Symfony
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    git \
     && docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    zip \
    opcache

# 2. Activer mod_rewrite pour Apache (essentiel pour les routes Symfony)
RUN a2enmod rewrite

# 3. Copier le code source de l'application
COPY . /var/www/html

# 4. Rediriger le DocumentRoot d'Apache vers le dossier public/ de Symfony
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# 5. Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 6. Donner les bons droits sur les dossiers var/ (cache et logs)
RUN chown -R www-data:www-data /var/www/html/var

EXPOSE 80