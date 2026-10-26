# Bienvenue dans la partie Back-end du projet Krabs !
Partie Back-end du projet "Le Krabs" de notre Projet de Recherche M1 Informatique à l'Université de Montpellier réalisée avec Symfony.

Elle gère l'authentification JWT, l'accès à la base de données MySQL et la communication avec le front-end Angular via CORS.

🚀 Prérequis

Avant de commencer, assurez-vous d'avoir installé les outils suivants :

PHP 8.x, avec les extensions PDO, MySQL et OpenSSL.
Composer, pour la gestion des dépendances PHP.
MySQL / MariaDB, pour la base de données.
Symfony CLI, optionnel mais recommandé.
🛠️ Configuration et installation
1. Installer les dépendances

Depuis la racine du dossier back/, exécutez :

bash
composer install

2. Configurer les variables d'environnement

Créez ou modifiez le fichier .env.local à la racine du dossier back/ :

ini
# Base de données
DATABASE_URL="mysql://karabs_user:votre_mot_de_passe@127.0.0.1:3306/karabs_db?serverVersion=8.0&charset=utf8mb4"

# Configuration CORS : autoriser Angular en développement
CORS_ALLOW_ORIGIN='^https?://(localhost|127\.0\.0\.1):[0-9]+$'

# Configuration JWT
JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=votre_passphrase_jwt


Important :

Remplacez votre_mot_de_passe par le mot de passe de votre utilisateur MySQL.
Remplacez votre_passphrase_jwt par la phrase secrète utilisée pour protéger la clé privée JWT.
Vérifiez que la version indiquée dans serverVersion correspond à votre installation de MySQL ou MariaDB.
Ne versionnez pas le fichier .env.local ni les clés privées JWT dans Git.
3. Générer les clés JWT

Si les clés JWT ne sont pas encore présentes, générez-les avec la commande suivante :

bash
php bin/console lexik:jwt:generate-keys


Les clés sont normalement créées dans le dossier config/jwt/ :

private.pem : clé privée utilisée pour signer les jetons JWT.
public.pem : clé publique utilisée pour vérifier les jetons JWT.

Assurez-vous que la passphrase configurée correspond à celle utilisée lors de la génération des clés.

4. Créer et configurer la base de données

Si vous souhaitez repartir d'une base de données vierge, exécutez :

bash
mysql -u root -p -e "DROP DATABASE IF EXISTS karabs_db; CREATE DATABASE karabs_db;"

Attention : cette commande supprime définitivement la base karabs_db existante et toutes les données qu'elle contient.

Assurez-vous ensuite que l'utilisateur karabs_user existe et dispose des droits nécessaires sur la base de données.

5. Importer les données SQL

Si le fichier bdd_karabs.sql se trouve à la racine du projet, au même niveau que les dossiers back/ et front/, lancez cette commande depuis le dossier back/ :

bash
mysql -u karabs_user -p karabs_db < ../bdd_karabs.sql


Cette commande importe la structure et les données contenues dans le fichier SQL.

6. Synchroniser les migrations Doctrine

Si nécessaire, synchronisez le stockage des migrations et appliquez les migrations disponibles :

bash
php bin/console doctrine:migrations:sync-metadata-storage
php bin/console doctrine:migrations:migrate


Remarque : si le fichier SQL contient déjà la structure complète de la base, vérifiez l'état des migrations avant de les appliquer afin d'éviter des conflits de schéma.

⚡ Démarrage du serveur

Depuis la racine du dossier back/, démarrez le serveur Symfony avec l'une des méthodes suivantes.

Méthode recommandée : Symfony CLI
bash
symfony server:start

Méthode alternative : serveur PHP intégré
bash
php -S 127.0.0.1:8000 -t public


L'API sera alors accessible à l'adresse :

http://localhost:8000

🔗 Communication avec le front-end

Le front-end Angular communique avec l'API Symfony via HTTP, généralement sur http://localhost:8000.

En cas d'erreur CORS :

Vérifiez la valeur de CORS_ALLOW_ORIGIN dans .env.local.
Assurez-vous que l'origine utilisée par Angular, par exemple http://localhost:4200, est autorisée.
Vérifiez la configuration CORS de Symfony et du bundle utilisé par le projet.
📝 Résolution des problèmes

Vérifier la configuration Symfony

Pour vérifier la configuration générale de l'environnement :

bash
php bin/console about


Pour consulter les routes disponibles :

bash
php bin/console debug:router

Problèmes de connexion à MySQL
Vérifiez que le serveur MySQL ou MariaDB est démarré.
Vérifiez les identifiants renseignés dans DATABASE_URL.
Vérifiez que la base karabs_db existe.
Vérifiez les droits de l'utilisateur karabs_user.

La structure exacte peut varier selon l'organisation du projet.

✅ Résumé des commandes
bash
# Installer les dépendances
composer install

# Générer les clés JWT si nécessaire
php bin/console lexik:jwt:generate-keys

# Appliquer les migrations si nécessaire
php bin/console doctrine:migrations:migrate

# Démarrer le serveur
symfony server:start