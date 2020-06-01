# Stop all docker (for no port issue)
docker stop $(docker ps -qa)
# Delete them 
docker rm $(docker ps -qa)

# Build the images
## php static
docker build -t res/apache-php ../apache-php-image/
## expres dynamic
docker build -t res/express-student-node ../express-image/node_with_express/
## RP
docker build -t res/apache-rp .


# Run images. ordre important pour IPs 
## PHP static
docker run --name apache_static -d res/apache-php
## express dynamic
docker run -d --name express_dynamic res/express-student-node         

## reverse-proxy
docker run -p 8080:80 -e STATIC_APP=undefined -e DYNAMIC_APP=undefined --name reverse_proxy -d res/apache-rp              

# on peut maintenant acceder a demo.res.ch pour le bootstrap 
# et a demo.res.ch/api/animals/ pour recevoir la liste danimo

