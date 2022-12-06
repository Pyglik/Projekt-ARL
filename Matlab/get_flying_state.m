function flying_state = get_flying_state(flying_state_sub)
    flying_state = receive(flying_state_sub, 5).State; % czas oczekiwania [s]
end

% 0 - Landed
% 1 - Taking off
% 2 - Hovering
% 3 - Flying
% 4 - Landing
% 5 - Emergency
% 6 - User take off
% 7 - Motor ramping
% 8 - Emergency landing