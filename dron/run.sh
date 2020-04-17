xhost +local:root


docker run -it\
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --name dron \
  --device=/dev/dri:/dev/dri \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  ros:dron \
  /bin/bash -c "cd Academy/exercises/drone_cat_mouse  && roslaunch ./drone_cat_mouse.launch & gedit /Academy/exercises/drone_cat_mouse/my_solution.py "


xhost -local:root

