function ros_connect(ip, port)
    Master_URI = strcat('http://', ip, ':', int2str(port), '/');
    rosinit(Master_URI);
end