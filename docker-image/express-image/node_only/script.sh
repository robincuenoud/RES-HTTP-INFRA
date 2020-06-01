# stop and kill container (as before)
docker stop $(docker ps -qa)
docker rm $(docker ps -qa)

# build de l'image du dockerfile 
docker build -t res/express-students-node .

# run 
docker run -p 3000:3000 -d res/express-students-node