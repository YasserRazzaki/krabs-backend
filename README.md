# Bienvenue dans le back-end du projet Le Krabs

Partie back-end du projet Le Krabs, réalisé dans le cadre de notre projet de recherche de Master 1 Informatique à l'Université de Montpellier.

Développée avec Symfony, cette API gère l'authentification JWT, l'accès à la base de données MySQL et la communication avec le front-end Angular via CORS.

## 🚀 Prérequis

Avant de commencer, assurez-vous d'avoir installé les outils suivants :

- PHP 8.x, avec les extensions PDO, MySQL et OpenSSL ;
- Composer, pour la gestion des dépendances PHP ;
- MySQL / MariaDB, pour la gestion de la base de données ;
- Symfony CLI, optionnel mais recommandé.

## 🛠️ Configuration et installation

### 1. Installer les dépendances

Depuis la racine du dossier `back/`, exécutez la commande suivante :

```bash
composer install
```

Cette commande installe les dépendances PHP définies dans le fichier `composer.json`.

### 2. Configurer les variables d'environnement

Créez ou modifiez le fichier `.env.local` à la racine du dossier `back/` :

```dotenv
# Base de données
DATABASE_URL="******127.0.0.1:3306/karabs_db?serverVersion=8.0&charset=utf8mb4"

# Configuration CORS : autoriser Angular en développement
CORS_ALLOW_ORIGIN='^https?://(localhost|127\.0\.0\.1):[0-9]+$'

# Configuration JWT
JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=votre_passphrase_jwt
```

> **Important**
>
> - Remplacez `votre_mot_de_passe` par le mot de passe de votre utilisateur MySQL.
> - Remplacez `votre_passphrase_jwt` par la phrase secrète utilisée pour protéger la clé privée JWT.
> - Vérifiez que la version indiquée dans `serverVersion` correspond à votre installation de MySQL ou MariaDB.
> - Ne versionnez jamais le fichier `.env.local` ni la clé privée JWT dans Git.

### 3. Générer les clés JWT

Si les clés JWT ne sont pas encore présentes, générez-les avec la commande suivante :

```bash
php bin/console lexik:jwt:generate-keys
```

Les clés sont normalement créées dans le dossier `config/jwt/` :

- `private.pem` : clé privée utilisée pour signer les jetons JWT ;
- `public.pem` : clé publique utilisée pour vérifier les jetons JWT.

Assurez-vous que la passphrase configurée correspond à celle utilisée lors de la génération des clés.

### 4. Créer la base de données

Si vous souhaitez repartir d'une base de données vierge, exécutez :

```bash
mysql -u root -p -e "DROP DATABASE IF EXISTS karabs_db; CREATE DATABASE karabs_db;"
```

> ⚠️ **Attention :** cette commande supprime définitivement la base `karabs_db` existante et toutes les données qu'elle contient.

Assurez-vous ensuite que l'utilisateur `karabs_user` existe et dispose des droits nécessaires sur cette base de données.

### 5. Importer les données SQL

Si le fichier `bdd_karabs.sql` se trouve à la racine du projet, au même niveau que les dossiers `back/` et `front/`, exécutez la commande suivante depuis le dossier `back/` :

```bash
mysql -u karabs_user -p karabs_db < ../bdd_karabs.sql
```

Cette commande importe la structure et les données contenues dans le fichier SQL.

### 6. Synchroniser les migrations Doctrine

Si nécessaire, synchronisez le stockage des migrations et appliquez les migrations disponibles :

```bash
php bin/console doctrine:migrations:sync-metadata-storage
php bin/console doctrine:migrations:migrate
```

> **Remarque :** si le fichier SQL contient déjà la structure complète de la base de données, vérifiez l'état des migrations avant de les appliquer afin d'éviter les conflits de schéma.

## ⚡ Démarrage du serveur

Depuis la racine du dossier `back/`, démarrez le serveur Symfony avec l'une des méthodes suivantes.

### Méthode recommandée : Symfony CLI

```bash
symfony server:start
```

### Méthode alternative : serveur PHP intégré

```bash
php -S 127.0.0.1:8000 -t public
```

L'API sera alors accessible à l'adresse suivante : <http://localhost:8000>.

## 🔗 Communication avec le front-end

Le front-end Angular communique avec l'API Symfony via HTTP, généralement à l'adresse <http://localhost:8000>.

En cas d'erreur CORS :

- vérifiez la valeur de `CORS_ALLOW_ORIGIN` dans le fichier `.env.local` ;
- assurez-vous que l'origine utilisée par Angular, par exemple `http://localhost:4200`, est autorisée ;
- vérifiez la configuration CORS de Symfony et du bundle utilisé par le projet.

## 📝 Résolution des problèmes

### Vérifier la configuration Symfony

Pour afficher les informations sur l'environnement Symfony :

```bash
php bin/console about
```

Pour consulter les routes disponibles dans l'API :

```bash
php bin/console debug:router
```

### Problèmes de connexion à MySQL

Si la connexion à la base de données échoue, vérifiez les points suivants :

- le serveur MySQL ou MariaDB est démarré ;
- les identifiants renseignés dans `DATABASE_URL` sont corrects ;
- la base de données `karabs_db` existe ;
- l'utilisateur `karabs_user` dispose des droits nécessaires ;
- le port de connexion et la version du serveur sont correctement configurés.

### Problèmes liés aux clés JWT

Si l'authentification JWT ne fonctionne pas :

- vérifiez la présence des fichiers `private.pem` et `public.pem` dans `config/jwt/` ;
- vérifiez les chemins définis dans les variables d'environnement ;
- vérifiez que `JWT_PASSPHRASE` correspond à la passphrase de la clé privée.

## 📁 Structure indicative du projet

```text
back/
├── config/
│   └── jwt/
│       ├── private.pem
│       └── public.pem
├── migrations/
├── public/
├── src/
├── .env
├── .env.local
├── composer.json
└── README.md
```

La structure exacte peut varier selon l'organisation du projet.

## ✅ Résumé des commandes

Voici les principales commandes à retenir pour installer et démarrer le back-end :

```bash
# Installer les dépendances
composer install

# Générer les clés JWT si nécessaire
php bin/console lexik:jwt:generate-keys

# Appliquer les migrations si nécessaire
php bin/console doctrine:migrations:migrate

# Démarrer le serveur Symfony
symfony server:start
```

---

*Back-end Le Krabs — Master 1 Informatique, Université de Montpellier.*
