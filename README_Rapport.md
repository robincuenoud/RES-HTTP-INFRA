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

![image-20200601123416612](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/1.1)

On peut aussi vérifier que on y à bien accès avec `telnet 192.168.1.100 9090` ce qui nous renvoie cela :

![image-20200601123822152](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/1.2)

(erreur 403) Ce qui est normal car il y’a rien encore dans notre serveur apache.

Pour explorer l’image on a besoin d’y accéder en mode interactif (obtenir un shell dedans par exemple), 

on peut utiliser la commande `docker exec -it <container_name> /bin/bash` pour obtenir un bash dedans et regarder la configuration qui se trouve dans `/etc/apache2` 

![image-20200601124029756](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/1.31)

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

![image-20200601125053707](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/1.4)



# RES HTTP Infra - Step 2 - Dynamic

## Node 

Selon le site `https://nodejs.org/en/` la dernière version stable est `12.17.0 `

On crée donc le Dockerfile suivant 

```dockerfile
FROM node:12.17.0
COPY src/ /opt/app
CMD ["node", "/opt/app/index.js"] 
```

Comme dans le docker file d'avant on va copier le contenu que l'on veut avoir dans l'image docker.

La différence étant que l'on utilise node, donc on doit lancer node grâce à ``` CMD ["node", "/opt/app/index.js"]``` 
Ainsi on indique au container de exécuter cette commande pour qu'au démarrage il lance node sur le fichier `index.js`

On crée ensuite un dossier `src` avec `mkdir src`  pour y placer nos fichier sources qui vont être utilisé par `node.js` sur le container.

On crée ensuite dans le dossier `src` l'application `node.js` grâce à `npm init` qui nous permettra de gérer les package etc... (c'est comme ça qu'on fait lol).

Ceci va créer un `package.json` qui contient les informations et encore aucune dépendance. 
On va utiliser le package chance, on l'installe avec `npm install --save chance` (`save`pour enregistrer la dépendance.)

Si on revient dans le `package.json` on voit qu'il a ajouté l'entrée chance et la version.

L'entrée du programme est `index.js` on va donc l'éditer.

```js
var Chance = require('chance') // pour charger la lib en gros 
var chance = new Chance();
console.log("Bonjour " + chance.name());
```

On va ensuite build l’image et lancer le container 

`docker build -t res/express_students_node .` 

et la lancer avec `docker run res/express_students_node`

Note : On doit préciser la commande dans le Dockerfile ou bien au lancé du container car lorsqu’un container docker à finis son exécution il quitte. Donc dès que node à fini d’exécuter `index.js`  cela quitte.

Et voila un exemple d’execution on obtient bien le “Bonjour …..”.

![](images/1)

## Express

On doit installer `express`dans le dossier `src/` 

* `npm install --save express`

Modification de `index.js` en 

```javascript
var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();

app.get('/', function(req, res) {
        res.send(generateAnimals());
});


app.listen(3000, function () {
        console.log("Accepting HTTP requests on port 3000");
});

function generateAnimals() {
        var numberOfAnimals = chance.integer({min: 1, max: 10});
        console.log("Generating " + numberOfAnimals + " animals )...");

        var animals = [];

        for(var i = 0; i < numberOfAnimals; ++i) {
                animals.push({
                        name: chance.animal(),
                        country: chance.country({full: true}),
                        age: chance.age({type: 'teen'}),
                        gender: chance.gender(),
                });
        }

        console.log(animals);
        return animals;
}
```

* Build du container avec `docker build -t res/express-students-node .`

* Lancement du container avec le port mapping avec la commande `docker run -p 3000:3000 -d res/express-students-node` 





# RES HTTP Infra - Step 3 - Reverse Proxy with Apache



##### Same origin policy: 

normalement un script excecuté qui vient d'un certain nom de domaine, ne peut faire des requetes que vers ce nom de domaine.

Pour suivre ça, que ce soit static ou dynamic:

* mettre en place un reverse-proxy = point d'entrée unique, donc les choses viendront et iron à cet unique point d'entrée. Bonne solution pour respecter cette règle



### Task:

* start 2 containers (httpd + node)
* grab their IP address
* Create a new docker image for the Reverse-Proxy (RP)
* Configure the RP routing (step 1 hardcode, mauvaise idée parce que docker attribura dynamiquement a chaque fois des nouvelles IP, donc la conf sera a adapter)
* test



### Marche a suivre

On récupère l'image build a l'étape 1

`docker run -d --name apache_static res/apache-php `

lancement de notre docker express_dynamic (pour build voir étape 2)

`docker run -d --name express_dynamic res/express-student-node`

on cherche k'addresse IP du docker apache:

`docker inspect apache_static | grep -i ipaddress` -> IP (ici 172.17.0.2) pour apache_static

pareil pour express_dynamic

`docker inspect express_dynamic | grep -i ipaddress` -> IP  est 172.17.0.3



Dans les docker-images on crée le dossier `mkdir apache-reverse-proxy, et on y crée le dockerfile`



##### Run le container avec le mode intéractif:

`docker run -p8080:80 -it -d res/apache-php ` (-d lance le bash)

on va dans les config de site `cd /etc/apache2/sites-available`

on copie pour créer un nouvelle config `cp 000-default.conf 001-reverse-proxy.conf`

on a besoin d'installer vim `apt-get update && apt-get install vim`

On peut maintenant edit notre config de reverse-proxy:

```
<VirtualHost *:80>
  ServerName demo.res.ch
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  
  # voir la doc apache.org, proxy-mod
  ProxyPass "/api/animals/" "http://172.17.0.3:3000/"
  ProxyPassReverse "/api/animals/" "http://172.17.0.3:3000/"
  
  ProxyPass "/" "http://172.17.0.2:80/"
    ProxyPassReverse "/" "http://172.17.0.2:80/"
</VirtualHost>
```

On a défini le site avec cette conf, mais on ne l'a pas encore activé, on doit utiliser `a2ensite 001-reverse*`. on nous indique ensuite de faire un `service apache2 reload`

Cependant on a une erreur, il faut encore activer les modules nécessaires (ceux requis par ProxyPass). Donc on utilise a2enmod pour ça: `a2enmod proxy && a2enmod proxy_http`

Puis on peut restart apache `service apache2 reload` -> Tout es okay, on va pouvoir tester la config.



### On rentre ces manips dans le Dockerfile

* on n'poublie pas de crée un dossier conf a coté de Dockerfile

On va créer les conf suivantes avec cette arborescence:

##### conf/sites-available/000-default.conf

Cette conf par défaut est utile si le header HOST n'est pas précidé, alors cette conf sera mis en action pour rendre demo.res.ch accessible. Mais on ne donne pas accès a du contenu.

```
<VirtualHost *:80>
</VirtualHost>
```

##### conf/sites-available/001-reverse-proxy.conf

La meme conf qui plus haut

```
<VirtualHost *:80>
  ServerName demo.res.ch
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
  
  # voir la doc apache.org, proxy-mod
  ProxyPass "/api/animals/" "http://172.17.0.3:3000/"
  ProxyPassReverse "/api/animals/" "http://172.17.0.3:3000/"
  
  ProxyPass "/" "http://172.17.0.2:80/"
    ProxyPassReverse "/" "http://172.17.0.2:80/"
</VirtualHost>
```



* pour le dockerfile:

```
FROM php:7.2-apache
COPY conf/ /etc/apache2

# les commandes pour activer les modes et la conf
RUN a2enmod proxy proxy_http
RUN a2ensite 000-default.conf 001-reverse-proxy.conf

```



* les confs et le dockerfile sont prêts, on peut build:

`docker build -t res/apache-rp . ` 

* Pour run le container:

`docker run res/apache-rp`



### Questions

> You can explain and prove that the static and dynamic servers cannot be reached directly (reverse proxy is a single entry point in the infra).

The static and dynamic servers can't be reached because there is no port-mapping for them to allow connection from the outside.

* On voit qu’on peut accéder a notre bootstrap à cette adresse : 

  ![image-20200601191629311](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/demo0)

  Mais que si on veut directement acceder à un docker sans passer par le proxy on ne peut pas car il n’y  a simplement pas de port mapping vers l’extérieur dans le lancement de nos docker.

  Et si on ne précise pas host on a alors : 

  ![image-20200601191932870](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/demo1)

  Ceci vient du fait que dans notre fichier de configuration par défaut il n’y a rien. (`000-default.conf`)

  >You are able to explain why the static configuration is fragile and needs to be improved.

  With the static configuration, we hardcoded the IPs of the containers. So if we restart them not in the same order, or with other containers running, the IP won't be the same and the conf won't work. So it's very error-prone, and because of that, the reverse proxy may not work sometimes when we reload all.

  

  ### Démo 

  On a notre script pour la démonstration dans `docker-images/apache-reverse-proxy/run.sh`

  ![image-20200601191546165](C:/Users/FlorianMülhauser/Documents/HEIG-VD/BA4/RES/Labos/Labo-HTTPInfra/RES-HTTP-INFRA/images/demo)

# RES HTTP Infra - Step 4 - AJAX request with Jquery



On veut changer nos containers pour ajouter vim, il faut donc les arrêter:

* On commence par arrêter les containers avec `docker kill xxxx`

* on les removes ensuite avec `docker rm $(docker ps -qa)`.

### On revient sur les Dockerfile des 3 containers précédents pour ajouter VIM



##### modif apache-php

On ajoute la ligne `RUN apt-get update && apt-get install -y vim`

On a donc le Dockerfile suivant

```
FROM php:7.2-apache

RUN apt-get update && apt-get install -y vim

COPY content/ /var/www/html
```

Il faut maintenant rebuild l'image

`docker build -t res/apache-php .`



##### modif apache-reverse-proxy

on ajoute la même ligne que précédemment, on obtient donc le Dockerfile suivant:

```
FROM php:7.2-apache

RUN apt-get update && apt-get install -y vim

COPY conf/ /etc/apache2

# les commandes pour activer les modes et la conf
RUN a2enmod proxy proxy_http
RUN a2ensite 000-default.conf 001-reverse-proxy.conf

```

ensuite on build a nouveau:`docker build -t res/apache-rp .`

##### modif pour les express

Les deux Dockerfile auront donc cette confguration:

````
FROM node:12.17.0
RUN apt-get update && apt-get install -y vim
COPY src /opt/app
CMD ["node", "/opt/app/index.js"]

````

on rebuild les deux images: 

* `docker build -t res/express-student-node .`
* `docker build -t res/express-student .`



### On peut à présent run les containers modifiés

Il faut les lancer dans le bon ordre pour que les ip soient justes (apache, express puis rp)

* `docker run -d --name apache-static res/apache-php`
* `docker run -d --name express-dynamic res/express-student`
* `docker run -d --name reverse-proxy -p 8080:80 res/apache-rp`

Une erreur pouvant arrivé, si le container express ne tourne pas, c'est qu'il faut refaire un `npm install` là où le fichier `package.json` est présent. Il faudra rebuild ensuite l'image.

tout fonctionne a présent.

### On se log sur notre appache-static

`docker exec -it apache-static /bin/bash`

* on sauvegarde une version d'index.html: `cp index.html index.html.orig`
* Puis on modifie ce fichier, à la fin on append un script :

```
<!-- on remplace le texte de la balise h2 qu'il y'a juste après le titre principal on ajoute l'attribut id que pour que le script modifie cela-->
<h2 id="AnimalsToUpdate" class="text-white-50 mx-auto mt-2 mb-5"></h2>

<!--animals script en bas de page par exemple (après body)-->
<script src="js/animals.js"></script>


```

Avec ça on appelle notre script, mais il n'existe pas encore...

dans js/ on crée le fichier `animaux.js` et on met:

```
$(function() { //mets à jour periodiquement les animaux avec AJAX

        console.log("Loading animals"); //lors du chargement on l'indique dans les logs

        function loadAnimals() { //la fonction qui charge les animaux
                $.getJSON("api/animals/", function(animals) {
                
                        console.log(animals);
                        var message = "Nobody is here";
                        if(animals.length > 0){
                        	message = animals[0].name + " from "+ animals[0].country
                        }
                        $("#AnimalsToUpdate").text(message); //changer la valeur de cet ID par le nouveau message.
                });
        };
        
        loadAnimals();
        // ici on peut regler le taux de rafraichissement
        setInterval(loadAnimals, 2000);    //toutes les 2s on re execute
});
```

Avec le screenshot suivant, nous pouvons voir que les requêtes AJAX sont bien effectuées.  

![image-20200601202203061](images/proof_ajax)





* Une fois ces modifications faites, il faudra faire ces mêmes modif précédentes dans notre l'image docker de apache-php, puis build et run. [donc dans docker-images/apache-php-image/content index.html et /js/animals.js]



> You are able to explain why your demo would not work without a reverse proxy (because of a security restriction).

La policy `Same Origin` , décrite dans le rapport step3, nous dit que: 

>  "Under the policy, a web browser permits scripts contained in a first web page to access data in a second web page, but only if both web pages have the same origin."

or ici les requêtes viennent de deux serveurs séparés, ça ne devrait pas fonctionner tout seul. A moins qu'on ait, comme là, un reverse proxy qui va donner juste un seul point d'entrée. Ainsi d'un point de vue extérieur de web browser, les requêtes ont la même origine et respectent donc la règle. Notre démo ne fonctionnerait donc pas sans proxy.



# RES HTTP Infra - Step 5 - Dynamic reverse proxy configuration

#### Test de variables d’environnement aux containers

* grâce au flag `-e` on peut passer des variables d’environnement ,essai avec `docker run -e CHEVAL=cheval -e ANE=ANE -it res/apache-rp /bin/bash` (on le lance avec un bash pour pouvoir vérifier directement). On voit ci dessous que le docker possède bien les variable d’environnements. 

  ![image-20200601212717695](images/verif_dynamic_0)

  

* Récupération du fichier `apache2-foreground` sur https://github.com/docker-library/php/blob/master/apache2-foreground  

  On le modifie en ajoutant cela pour afficher nos variables d’environnement : 

  ```bash
  # Setup for RES lab
  echo "Setup for RES lab..."
  echo 'static app IP  : $STATIC_APP'
  echo 'dynamic app IP : $DYNAMIC_APP'
  
  ```

  On le rend ensuite exécutable avec `chmod +x apache2-foreground` 

* Modification de notre Dockerfile pour remplacer le apache2-foreground fourni avec l’image.

  On peut voir dans la doc qu’il est contenu à `/usr/local/bin/`dans le container on va donc rajouter ` COPY apache2-foreground /usr/local/bin`  pour le copier au bon endroit. On trouve cette information dans la deuxième partie de leur Dockerfile sur ce lien : https://github.com/docker-library/php/blob/master/apache-Dockerfile-block-2

  Le reste du Dockerfile reste identique.

Maintenant on test si on voit bien les echo dans le script executé :

`/usr/local/bin/docker-php-entrypoint: 9: exec: apache2-foreground: not found` 

On va regarder dans le container si le fichier a mal été copié :![image-20200601220722707](images/error_step5)

Avec un `cat` on voit qu’il a bien le contenu de notre nouveau fichier. Le problème n’est pas là. Il a bien le flag executable (`ls -l` nous montre cela par exemple).

On run ensuite manuellement le script `docker-php-entrypoint` avec la commande 

` ./docker-php-entrypoint -f` (a besoin d’un flag `-f`  pour passer dans la vérification du fichier) et effectivement ici le script ne trouve pas le fichier on obtient de nouveau `./docker-php-entrypoint: 9: exec: apache2-foreground: not found` 

Après quelques heures d’analyse en plus (heureusement qu’on a seulement 9 branches ce semestre d’ailleurs) on trouve un indice ! En exécutant manuellement le script `docker-php-entrypoint` dans un shell `bash` cela fonctionne très bien (il trouve le fichier) mais dans un script `sh` cela ne fonctionne pas. On va simplement remplacer le `docker-php-entrypoint` avec le notre qui comportera `#!bin/bash` en haut au lieu de `!#bin/sh`  et on le copie a la bonne place en espérant que le script qui l’appelle n’est pas exécuté en `sh` …… 

Et ben non erreur ! 

`standard_init_linux.go:211: exec user process caused "no such file or directory"`

Ce serait bien trop simple, le script de booting linux ne trouve pas le fichier que j’ai mis maintenant, j’ai pas pire envie de réecrire Linux pour un labo d’un cours à 4 crédit donc je vais faire autrement (surtout pour avoir au max 4.5 :) ).

On annule l’idée d’utiliser `bash` c’était pas brillant on imagine..  

De toute manière si c’est juste pour `echo` des variables d’environnement pas besoin de perdre 4 heures. 