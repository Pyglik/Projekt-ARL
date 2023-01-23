function velocity = circle_velocity(v, n)
% v - prędkość, n - liczba punktów
    t = 1:n;
    dx = v*cos(t*2*pi/n);
    dy = v*sin(t*2*pi/n);
    dz = zeros([1, n]);
    dth = zeros([1, n]);
    velocity = [dx' dy' dz' dth'];
end