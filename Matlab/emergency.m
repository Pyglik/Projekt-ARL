function emergency(emergency_pub)
    msg = rosmessage('std_msgs/Empty');
    send(emergency_pub, msg);
end