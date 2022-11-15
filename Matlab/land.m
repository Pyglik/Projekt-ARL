function land(land_pub)
    msg = rosmessage('std_msgs/Empty');
    send(land_pub, msg);
end