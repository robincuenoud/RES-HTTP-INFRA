# RES-Static-HTTP-server-with-apache-httpd




## Step 3: Reverse proxy with apache (static configuration)

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

`docker inspect express_dynamic | grep -i ipaddress`



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
  ProxyPass "/api/companies/" "http://172.17.0.3:3000/"
  ProxyPassReverse "/api/companies/" "http://172.17.0.3:3000/"
  
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
  ProxyPass "/api/companies/" "http://172.17.0.3:3000/"
  ProxyPassReverse "/api/companies/" "http://172.17.0.3:3000/"
  
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

`docker build -t res/apache-RP . ` 

* Pour run le container:

`docker run res/apache-RP`