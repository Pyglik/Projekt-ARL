function velocity = square_velocity(v, n)
% v - prędkość, n - liczba punktów na bok
    v0 = zeros(n, 1);
    v1 = v*ones(n, 1);
    velocity = [v1, v0, v0, v0;
                v0, v0, v0, v0;
                v0, v1, v0, v0;
                v0, v0, v0, v0;
               -v1, v0, v0, v0;
                v0, v0, v0, v0;
                v0,-v1, v0, v0];
end