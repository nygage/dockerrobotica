xhost +local:root

docker run -it\
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --device=/dev/dri:/dev/dri \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  ros:coche \
  /bin/bash -c "source /root/.bashrc && cd Academy/exercises/follow_line && roslaunch ./launch/simple_line_follower_ros.launch"

xhost -local:root

