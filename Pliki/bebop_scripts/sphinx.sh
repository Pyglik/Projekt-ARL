#!/bin/bash

sudo ip link add wlan0 type dummy
sudo ip link set wlan0 up

sudo systemctl stop firmwared.service
sudo systemctl start firmwared.service
sphinx /opt/parrot-sphinx/usr/share/sphinx/drones/bebop2.drone::with_front_cam=false
