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

On crée ensuite dans le dossier `src` l'application `node.js` grâce à `npm init` qui nous permettra de gérer les package etc...
Puis l'on selectionne ce que l'on veut comme nom de package. 

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

![image-20200601132433697](image-20200601132433697.png)

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