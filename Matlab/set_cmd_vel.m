function set_cmd_vel(cmd_vel_pub, cmd_vel)
    x = cmd_vel(1);
    y = cmd_vel(2);
    z = cmd_vel(3);
    omega = cmd_vel(4);
    msg = rosmessage('geometry_msgs/Twist');
    msg.Linear.X = x; % do przodu
    msg.Linear.Y = y; % w lewo
    msg.Linear.Z = z; % w górę
    msg.Angular.Z = omega; % obrót w lewo
    send(cmd_vel_pub, msg)
end