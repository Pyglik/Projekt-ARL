# Ubuntu 16.04
FROM ubuntu:16.04
SHELL ["/bin/bash", "-c"]

# ROS kinetic
RUN apt-get update && apt-get install -y lsb-core
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full
RUN source /opt/ros/kinetic/setup.bash

# gnome-terminal
RUN apt-get update && apt-get install -y gnome-terminal

# bebop_autonomy, g2rr, sphinx
WORKDIR /home/bebop2
COPY ./bebop2 .
COPY ./opt /opt/
RUN ln -s /opt/parrot-sphinx/usr/bin/parrot-sphinx-launcher.sh /bin/sphinx
RUN source /home/bebop2/bebop_ws/devel/setup.bash
RUN source /home/bebop2/catkin_ws/devel/setup.bash

CMD bash run_bebop
