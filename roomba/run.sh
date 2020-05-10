xhost +local:root


docker run -it\
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --name roomba \
  --device=/dev/dri:/dev/dri \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  ros:roomba \
  /bin/bash -c "cd Academy/exercises/vacuum_cleaner && roslaunch ./vacuum_cleaner.launch & gedit /Academy/exercises/vacuum_cleaner/MyAlgorithm.py & \
		sleep 5 && cd Academy/exercises/vacuum_cleaner && python2 ./vacuumCleaner.py vacuumCleaner_conf.yml & cd Academy/exercises/vacuum_cleaner && python2 ./referee.py referee.yml"


xhost -local:root

