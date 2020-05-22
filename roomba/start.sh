xhost +local:root


docker start -a roomba
docker stop roomba

xhost -local:root

