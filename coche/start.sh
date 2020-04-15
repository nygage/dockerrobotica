xhost +local:root


docker start -a coche
docker stop coche

xhost -local:root

