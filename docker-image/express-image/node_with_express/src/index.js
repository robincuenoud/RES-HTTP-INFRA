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