## Step 5 Dynamic reverse proxy configuration

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

