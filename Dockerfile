FROM php:8.4-apache

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

# 3. Définir le dossier de travail
WORKDIR /var/www/html

# 4. Installer Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 5. Copier UNIQUEMENT composer.json et composer.lock en premier
COPY composer.json composer.lock ./

# 6. Installer les dépendances SANS exécuter les scripts tout de suite
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-interaction

# 7. MAINTENANT, copier le reste du code source
COPY . /var/www/html

# 7.bis Créer un fichier .env vide pour éviter l'erreur de Dotenv pendant le build
RUN touch .env

# 8. Exécuter enfin les scripts post-installation de Composer (cache:clear, etc.)
RUN composer run-script post-install-cmd --no-interaction

# 9. Rediriger le DocumentRoot d'Apache vers public/
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# 10. Créer le dossier var/ et donner les bons droits sur var/ et vendor/
RUN mkdir -p /var/www/html/var && chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

EXPOSE 80