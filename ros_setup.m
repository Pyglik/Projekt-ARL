rosinit('http://192.168.0.58:11311/');

takeoff_pub = rospublisher('/bebop/takeoff', 'std_msgs/Empty');
land_pub = rospublisher('/bebop/land', 'std_msgs/Empty');
emergency_pub = rospublisher('/bebop/emergency', 'std_msgs/Empty');
cmd_vel_pub = rospublisher('bebop/cmd_vel', 'geometry_msgs/Twist');

odometry_sub = rossubscriber('/bebop/odom', 'nav_msgs/Odometry');
image_raw_sub = rossubscriber('/bebop/image_raw', 'sensor_msgs/Image');
battery_state_sub = rossubscriber('/bebop/states/common/CommonState/BatteryStateChanged', 'bebop_msgs/CommonCommonStateBatteryStateChanged');
wifi_state_sub = rossubscriber('/bebop/states/common/CommonState/WifiSignalChanged', 'bebop_msgs/CommonCommonStateWifiSignalChanged');
flying_state_sub = rossubscriber('/bebop/states/ardrone3/PilotingState/FlyingStateChanged', 'bebop_msgs/Ardrone3PilotingStateFlyingStateChanged');