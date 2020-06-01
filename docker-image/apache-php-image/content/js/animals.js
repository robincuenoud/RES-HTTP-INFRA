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