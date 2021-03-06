xhost +local:root


docker run -it\
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --name coche \
  --device=/dev/dri:/dev/dri \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  ros:coche \
  /bin/bash -c "cd Academy/exercises/obstacle_avoidance && roslaunch ./launch/obstacle_avoidance_f1.launch & gedit /Academy/exercises/obstacle_avoidance/MyAlgorithm_f1.py & sleep 5 && cd Academy/exercises/obstacle_avoidance && python ./obstacle_avoidance_f1.py obstacle_avoidance_conf_f1.yml"


xhost -local:root

