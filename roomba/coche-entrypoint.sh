#!/bin/bash
set -e

source /opt/ros/melodic/setup.bash
source /opt/jderobot/setup.bash
source /opt/ros/melodic/setup.bash
source /opt/jderobot/share/jderobot/gazebo/gazebo-setup.sh
source /opt/jderobot/share/jderobot/gazebo/assets-setup.sh
source /catkin_ws/devel/setup.bash
export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/usr/share/gazebo-9
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/opt/ros/melodic/share/jderobot_assets/models

exec "$@"

