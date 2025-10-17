# Création des images nécessaires
docker pull nginx
docker pull php:fpm

# Création des conteneurs avec les volumes bind mount
docker container run -d --name HTTP -p 8080:80 -v ${PWD}/config/:/etc/nginx/conf.d -v ${PWD}/src/:/app nginx # le conteneur finis par s'éteindre car il n'est pas en lien avec le conteneur PHP
docker container run -d --name SCRIPT -v ${PWD}/src/:/var/www/html php:fpm

# Création d'un réseau bridge personnalisé
docker network create ETAPE1_RESEAU

# Connexion des conteneurs au réseau personnalisé
docker network connect ETAPE1_RESEAU HTTP
docker network connect ETAPE1_RESEAU SCRIPT

# On rallume notre conteneur HTTP pour qu'il prenne en compte les changements
docker container restart HTTP


