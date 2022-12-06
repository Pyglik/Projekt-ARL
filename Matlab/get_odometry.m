function odometry = get_odometry(odometry_sub)
    odom = receive(odometry_sub, 5); % czas oczekiwania [s]
    % pozycja
    pos = [0 0 0];
    pos(1) = odom.Pose.Pose.Position.X;
    pos(2) = odom.Pose.Pose.Position.Y;
    pos(3) = odom.Pose.Pose.Position.Z;
    % orientacja
    w = odom.Pose.Pose.Orientation.W;
    x = odom.Pose.Pose.Orientation.X;
    y = odom.Pose.Pose.Orientation.Y;
    z = odom.Pose.Pose.Orientation.Z;
    % roll pitch yaw
    rot = quat2eul([w x y z]);
    rot = rot(end:-1:1);
    
    odometry = [pos, rot];
end