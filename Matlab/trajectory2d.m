function trajectory2d(positions)
% lista x, y, x, roll, pitch, yaw
    x = positions(:, 1);
    y = positions(:, 2);
    plot(x, y);
    axis equal

    figure
    hold on
    plot(x)
    plot(y)
    hold off
    legend('x', 'y')
end