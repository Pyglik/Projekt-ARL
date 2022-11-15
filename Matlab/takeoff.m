function takeoff(takeoff_pub)
    msg = rosmessage('std_msgs/Empty');
    send(takeoff_pub, msg);
end