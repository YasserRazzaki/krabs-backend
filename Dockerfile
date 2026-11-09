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

# 2. Activer mod_rewrite pour Apache
RUN a2enmod rewrite

# 3. Définir le dossier de travail par défaut
WORKDIR /var/www/html

# 4. Installer Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Copier d'abord les fichiers de configuration de Composer (optimise le cache Docker)
COPY composer.json composer.lock ./

# 6. Installer les dépendances PHP pour la production
RUN composer install --no-dev --optimize-autoloader --no-interaction

# 7. Copier le reste du code source de l'application
COPY . /var/www/html

# 8. Rediriger le DocumentRoot d'Apache vers le dossier public/ de Symfony
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# 9. Créer le dossier var/ et donner les bons droits sur var/ et vendor/
RUN mkdir -p /var/www/html/var && chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

EXPOSE 80