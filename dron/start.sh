xhost +local:root


docker start -a dron
docker stop dron

xhost -local:root

