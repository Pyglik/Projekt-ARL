function trajectory = circle_trajectory(r, h, n)
% r - promień, h - wysokość, n - liczba punktów
    t = 1:n;
    x = r*cos(t*2*pi/n);
    y = r*sin(t*2*pi/n);
    z = h*ones([1, n]);
    th = zeros([1, n]);
    trajectory = [x' y' z' th'];
end