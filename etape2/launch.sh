# Etape 1
# Création des images nécessaires
docker pull nginx
docker pull php:fpm

# Création des conteneurs avec les volumes bind mount
docker container run -d --name HTTP -p 8080:80 -v ${PWD}/config/:/etc/nginx/conf.d -v ${PWD}/src/:/app nginx # le conteneur finis par s'éteindre car il n'est pas en lien avec le conteneur PHP
docker container run -d --name SCRIPT -v ${PWD}/src/:/var/www/html php:fpm

# Création d'un réseau bridge personnalisé
docker network create ETAPE2_RESEAU

# Connexion des conteneurs au réseau personnalisé
docker network connect ETAPE2_RESEAU HTTP
docker network connect ETAPE2_RESEAU SCRIPT

# On rallume notre conteneur HTTP pour qu'il prenne en compte les changements
docker container restart HTTP

# Etape 2 ajouté
# Création de l'image mariadb
docker pull mariadb

# Création du conteneur de la base de données (primitif)
docker container run -d --name DATA -v ${PWD}/database:/docker-entrypoint-initdb.d -e MARIADB_RANDOM_ROOT_PASSWORD=1234 mariadb

# Ajout de l'extension mysqli à PHP
docker image build -t php:fpm-mysqli .
docker container stop SCRIPT
docker container rm SCRIPT
docker container run -d --name SCRIPT -v ${PWD}/src/:/var/www/html php:fpm-mysqli

# On relie tout ça au réseau
docker network connect ETAPE2_RESEAU SCRIPT
docker network connect ETAPE2_RESEAU DATA

# Par sécurité on redémarre les conteneurs
docker container restart HTTP SCRIPT DATA