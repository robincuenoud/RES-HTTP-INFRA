# RES-Static-HTTP-server-with-apache-httpd
Repo for RES lab step 1

# Structure du dossier 
... complete

# Image Docker
Comme image Docker on va utiliser l'image php officiel, car elle est plus agréable à utiliser et elle est déjà configurée pour le php.

Dans la documentation sur le repo de l'image sur Docker Hub on trouve comment l'importer
`FROM php:5.6-apache
COPY src/ /var/www/html/` 

La première ligne importe l'image, la seconde permet de copier un fichier de notre machine sur la machine docker dans le dossier `/var/www/html/` ce qui est le fichier par défaut de apache ou mettre les fichiers web (php,js,html,etc..) qui seront fournis par le serveur... 

On va ensuite tester une fois avec 
`docker run -d -p 9090:80 php:5.6-apache` 
`-d` pour récuperer la console, `-p` pour faire du port mapping.

41:56