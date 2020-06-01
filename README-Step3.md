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

`docker inspect apache_static | grep -i ipaddress` -> IP