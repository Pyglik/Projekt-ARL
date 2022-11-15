function battery_state = get_battery_state(battery_state_sub)
    battery_state = receive(battery_state_sub, 5).percent; % czas oczekiwania [s]
end

% procent naładowania baterii