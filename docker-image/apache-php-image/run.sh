# Stop all docker (for no port issue)
docker stop $(docker ps -qa)
# Delete them 
docker rm $(docker ps -qa)
# Build image 
docker build -t res/apache-php .

# Run image 
docker run -p 9090:80 -d res/apache-php

## visit : http://192.168.99.100:9090/