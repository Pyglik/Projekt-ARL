function trajectory3d(positions)
% lista x, y, x, roll, pitch, yaw
    x = positions(:, 1);
    y = positions(:, 2);
    z = positions(:, 3);
    plot3(x, y, z);
    axis equal

    figure
    hold on
    plot(x)
    plot(y)
    plot(z)
    hold off
    legend('x', 'y', 'z')
end