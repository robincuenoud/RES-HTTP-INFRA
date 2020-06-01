# Step 4: AJAX requests with JQuery

### 

On veut changer nos containers pour ajouter vim, il faut donc les arreter:

* On commence par arreter les containers avec `docker kill xxxx`

* on les removes ensuites avec `docker rm $(docker ps -qa)`.

### On revient sur les Dockerfile des 3 containers précedents pour ajouter VIM



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

on ajoute la meme ligne que précedement, on obtient donc le Dockerfile suivant:

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



### On peut a présent run les containers modifiés



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
#debut d'append ====
<p id="AnimalsToUpdate"> Lorem ipsum dolor sit amet, consectetur adipiscing elit. </p>

[...]

<!--Custom script to load animaux-->
<script src="js/animals.js"></script>


# fin d'append ===
</body>
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
                        	message = animals[0].animal()
                        }
                        $("#AnimalsToUpdate").text(message); //changer la valeur de cet ID par le nouveau message.
                });
        };
        
        loadAnimals();
        // ici on peut regler le taux de rafraichissement
        setInterval(loadAnimals, 2000);    //toutes les 2s on re execute
});
```



* Une fois ces modifications faites, il faudra faire ces modif précedentes dans notre l'image docker de apache-php, puis build et run. [donc dans docker-images/apache-php-image/content index.html et /js/animals.js]

