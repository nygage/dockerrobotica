#This is a Dockerfile for jderobot-coche
FROM osrf/ros:melodic-desktop-full

RUN echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc

#Add intel display drivers

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*
RUN gzserver --verbose --iters 1 /opt/ros/${ROS_DISTRO}/share/turtlebot_gazebo/worlds/playground.world


#Install Jderobot
RUN  sudo sh -c 'echo "deb [arch=amd64] http://wiki.jderobot.org/apt `lsb_release -cs` main" > /etc/apt/sources.list.d/jderobot.list'
RUN  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 24E521A4
RUN  apt-get update && apt-get install -y jderobot
RUN  sudo apt install -y ros-melodic-desktop-full


#Install Jderobot Assets

RUN  apt-get install -y jderobot-assets
RUN  apt-get install -y ros-melodic-jderobot-assets

RUN echo 'source /opt/jderobot/share/jderobot/gazebo/gazebo-setup.sh' >> ~/.bashrc
RUN echo 'source /opt/jderobot/share/jderobot/gazebo/assets-setup.sh' >> ~/.bashrc


#Install OpenCV

RUN  apt install -y python-pip
RUN  pip install opencv-python
RUN  pip install packaging


#Install MavROS

RUN  apt install -y ros-melodic-mavros ros-melodic-mavros-extras

#Install PX4

RUN  wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
RUN  chmod +X install_geographiclib_datasets.sh
RUN  sudo sh install_geographiclib_datasets.sh
RUN  sudo apt remove -y modemmanager
RUN  sudo apt update -y
RUN  sudo apt install git zip qtcreator cmake \
     build-essential genromfs ninja-build exiftool -y

RUN  which xxd || sudo apt install xxd -y || sudo apt install vim-common --no-install-recommends -y

RUN  sudo apt install python-argparse \
     python-empy python-toml python-numpy python-yaml \
     python-dev python-pip -y
RUN  sudo -H pip install --upgrade pip
RUN  sudo -H pip install pandas jinja2 pyserial cerberus
RUN  sudo -H pip install pyulog
RUN  sudo apt install -y ninja-build
RUN  wget https://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-rtps/eprosima-fast-rtps-1-7-1/eprosima_fastrtps-1-7-1-linux-tar-gz -O eprosima_fastrtps-1-7-1-linux.tar.gz
RUN  tar -xzf eprosima_fastrtps-1-7-1-linux.tar.gz eProsima_FastRTPS-1.7.1-Linux/
RUN  tar -xzf eprosima_fastrtps-1-7-1-linux.tar.gz requiredcomponents
RUN  tar -xzf requiredcomponents/eProsima_FastCDR-1.0.8-Linux.tar.gz
RUN  (cd eProsima_FastCDR-1.0.8-Linux && ./configure --libdir=/usr/lib && make -j2 && sudo make install)
RUN  (cd eProsima_FastRTPS-1.7.1-Linux && ./configure --libdir=/usr/lib && make -j2 && sudo make install)
RUN  rm -rf requiredcomponents eprosima_fastrtps-1-7-1-linux.tar.gz
RUN  sudo apt install -y python-catkin-tools
RUN  mkdir -p catkin_ws/src
RUN  cd catkin_ws/src && \
     git clone https://github.com/PX4/Firmware.git && cd Firmware && \
     git submodule update --init --recursive && \
     cd .. && ln -s Firmware/Tools/sitl_gazebo mavlink_sitl_gazebo
RUN  sudo apt-get update
RUN  cd catkin_ws && \
     rosdep update
RUN  cd catkin_ws && \
     rosdep check --from-paths . --ignore-src --rosdistro melodic --as-root=apt:false || \
     rosdep install -y --from-paths . --ignore-src --rosdistro melodic --as-root=apt:false

RUN  cd catkin_ws && echo 'source '$PWD'/devel/setup.bash' >> ~/.bashrc
RUN  echo 'export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/usr/share/gazebo-9' >> ~/.bashrc
RUN  echo 'export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/opt/ros/melodic/share/jderobot_assets/models' >> ~/.bashrc
RUN  cd catkin_ws && catkin config \
      --extend /opt/ros/$ROS_DISTRO && \
    catkin build \
    && catkin build


RUN  cd / &&  git clone https://github.com/JdeRobot/Academy.git

COPY coche-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["coche-entrypoint.sh"]
RUN chmod +x /usr/local/bin/coche-entrypoint.sh


