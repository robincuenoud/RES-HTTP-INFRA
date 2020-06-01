# RES - HTTP Infra - Step 1 - Apache Static
## Image Docker
Comme image Docker on va utiliser l'image php officiel, car elle est plus agréable à utiliser et elle est déjà configurée pour le php. On la trouve sur https://hub.docker.com/_/php/

Dans la documentation sur le repo de l'image sur Docker Hub on trouve que mettre dans notre `Dockerfile` 

```dockerfile
FROM php:7.2-apache
COPY content/ /var/www/html/
```

La première ligne importe l'image, la seconde permet de copier un fichier de notre machine sur la machine docker dans le dossier `/var/www/html/` ce qui est le fichier par défaut de apache ou mettre les fichiers web (php,js,html,etc..) qui seront fournis par le serveur... 

## Exploration de l’image

On lance le container avec `docker run -d -p 9090:80 php:7.2-apache` 
`-d` pour récupérer la console, `-p` pour faire du port mapping.

Pour vérifier que le container s’est bien lancé on peut regarder `docker logs <container_name>`  et ainsi

on obtient par exemple : 

![image-20200601123416612](images/1.1)

On peut aussi vérifier que on y à bien accès avec `telnet 192.168.1.100 9090` ce qui nous renvoie cela :

![image-20200601123822152](images/1.2)

(erreur 403) Ce qui est normal car il y’a rien encore dans notre serveur apache.

Pour explorer l’image on a besoin d’y accéder en mode interactif (obtenir un shell dedans par exemple), 

on peut utiliser la commande `docker exec -it <container_name> /bin/bash` pour obtenir un bash dedans et regarder la configuration qui se trouve dans `/etc/apache2` 

![image-20200601124029756](images/1.31)

## Ajout de contenu à l’image

* Ajout d’un fichier `index.html` dans le dossier `content/` 

* Build de l’image avec `docker build -t res/apache-php .` (le `.` signifie le dossier courant)

* Lancement de l’image avec `docker run -p 9090:80 -d res/apache-php` (note: pour lancer d’autres images en même temps on doit mettre un port différent)

Maintenant on peut aller voir notre index sur le navigateur ou par telnet.

## Ajout d’un Template

* Téléchargement d’une Template  https://startbootstrap.com/themes/grayscale/ dans le dossier `content`
* re build de l’image et on la lance 

Note: J’ai personnalisé le contenu en modifiant les fichiers sources…..

Et tadaa……..

![image-20200601125053707](images/1.4)

