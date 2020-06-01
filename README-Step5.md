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

On va pas plus se compliquer la vie on va mettre les commandes directement dans le Dockerfile 