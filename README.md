<<<<<<< HEAD
# RES - HTTP Infra - Step 1 - Apache Static
## Image Docker
Comme image Docker on va utiliser l'image php officiel, car elle est plus agréable à utiliser et elle est déjà configurée pour le php. On la trouve sur https://hub.docker.com/_/php/

Dans la documentation sur le repo de l'image sur Docker Hub on trouve que mettre dans notre `Dockerfile` 

```dockerfile
FROM php:7.2-apache
COPY content/ /var/www/html/
```

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

=======

# RES HTTP Infra - Step 2 - …

## Creation du Dockerfile

Comme dans le docker file d'avant on va copier le contenu que l'on veut avoir dans l'image docker.

La différence étant que l'on utilise node, donc on doit lancer node grâce à ``` CMD ["node", "/opt/app/index.js"]``` 
Ainsi on indique fait executer au container cette commande pour qu'au démarrage il lance node sur le fichier `index.js`

On crée ensuite un dossier `src` avec `mkdir src`  pour y placer nos fichier sources qui vont être utilisé par `node.js` sur le container (qui je rappelle est blablabla c'est super fun d'écrire un livre pour faire un rapport d'un laboratoire alors qu'on a 8 branches ce semestre..)

>>>>>>> fb-express-dynamic

On crée ensuite dans le dossier `src` l'application `node.js` grâce à `npm init` qui nous permettra de gérer les package etc... (c'est comme ça qu'on fait lol).
Puis l'on selectionne ce que l'on veut comme nom de package etc (on l'entre et ensuite on appuie sur enter quand il le demande).



Ceci va créer un `package.json` qui contient les informations et encore aucune dépendance. 
On va utiliser le package chance, on l'installe avec `npm install --save chance` (`save`pour enregistrer la dépendance.)

Si on revient dans le `package.json` on voit qu'il a ajouté l'entrée chance et la version. WOaaah

L'entrée du programme est index.js on va donc l'éditer.

`var Chance = require('chance') // pour charger la lib en gros `
var chance = new Chance();
console.log("Bonjour " + chance.name());

On va ensuite créer un container ( `.` pour le dossier courant comme contexte, ce qui va faire que quand on copie il trouve les fichiers (pas fou l'ami)).

On peut encore préciser que lorsque un container docker à finis son execution il quitte ! 
