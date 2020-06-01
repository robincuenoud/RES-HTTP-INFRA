# RES HTTP Infra - Step 2 - …
## Creation du Dockerfile

Comme dans le docker file d'avant on va copier le contenu que l'on veut avoir dans l'image docker.

La différence étant que l'on utilise node, donc on doit lancer node grâce à ``` CMD ["node", "/opt/app/index.js"]``` 
Ainsi on indique fait executer au container cette commande pour qu'au démarrage il lance node sur le fichier `index.js`

On crée ensuite un dossier `src` avec `mkdir src`  pour y placer nos fichier sources qui vont être utilisé par `node.js` sur le container (qui je rappelle est blablabla c'est super fun d'écrire un livre pour faire un rapport d'un laboratoire alors qu'on a 8 branches ce semestre..)

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
##