#WARNING! THIS LINE WILL DELETE ALL YOUR DOCKER IMAGES AND VOLUMES
docker rm -vf $(docker ps -a -q)
docker rmi $(docker images -a -q)

