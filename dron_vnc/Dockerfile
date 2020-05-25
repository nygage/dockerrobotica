
#This is a Dockerfile for jderobot-coche
FROM osrf/ros:melodic-desktop-full

RUN echo 'source /opt/ros/melodic/setup.bash' >> /root/.bashrc
USER 0
LABEL io.k8s.description="Headless VNC Container with Xfce window manager, firefox and chromium" \
      io.k8s.display-name="Headless VNC Container based on Ubuntu" \
      io.openshift.expose-services="6901:http,5901:xvnc" \
      io.openshift.tags="vnc, ubuntu, xfce" \
      io.openshift.non-scalable=true

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901
EXPOSE $VNC_PORT $NO_VNC_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    NO_VNC_HOME=/headless/noVNC \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME


## Install Supervisor for multiple entrypoint
##RUN sudo apt-get update && apt-get install -y supervisor

### Add all install scripts for further steps
ADD ./src/common/install/ $INST_SCRIPTS/
ADD ./src/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firefox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/common/xfce/ $HOME/

### configure startup
RUN sudo $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/common/scripts $STARTUPDIR
RUN sudo $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

##ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]


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
RUN  apt-get install -y ros-melodic-drone-wrapper ros-melodic-rqt-drone-teleop ros-melodic-jderobot-assets
RUN  apt-get install -y xmlstarlet


#Install Jderobot Assets

RUN  apt-get install -y jderobot-assets
RUN  apt-get install -y ros-melodic-jderobot-assets
RUN echo 'source /opt/jderobot/share/jderobot/gazebo/gazebo-setup.sh' >> ~/.bashrc
RUN echo 'source /opt/jderobot/share/jderobot/gazebo/assets-setup.sh' >> ~/.bashrc


#Install OpenCV

RUN  apt install -y python-pip
RUN  apt install -y libopencv-dev python-opencv
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
RUN  cd catkin_ws/src && git clone https://github.com/JdeRobot/drones.git

RUN  cd catkin_ws && echo 'source '$PWD'/devel/setup.bash' >> ~/.bashrc
RUN  echo 'export GAZEBO_RESOURCE_PATH=${GAZEBO_RESOURCE_PATH}:/usr/share/gazebo-9' >> ~/.bashrc
RUN  echo 'export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/opt/ros/melodic/share/jderobot_assets/models' >> ~/.bashrc
RUN  cd catkin_ws && catkin config \
      --extend /opt/ros/$ROS_DISTRO && \
    catkin build \
    && catkin build

RUN sudo apt-get install gedit -y

RUN  cd / &&  git clone https://github.com/JdeRobot/Academy.git

COPY coche-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/coche-entrypoint.sh

COPY cat.sh ./
RUN chmod +x ./cat.sh


##ENTRYPOINT ["coche-entrypoint.sh"]
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]


