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
docker build -t res/apache-RP


# Run images. ordre important pour IPs 
## PHP static
docker run --name apache_static -d res/apache-php
## express dynamic
docker run -d --name express_dynamic res/express-student-node         

## reverse-proxy
docker run -p 9090:80 --name reverse_proxy -d res/apache-RP              

## visit : http://192.168.99.100:9090/