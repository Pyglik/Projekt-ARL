function wifi_state = get_wifi_state(wifi_state_sub)
    wifi_state = receive(wifi_state_sub, 5).Rssi; % czas oczekiwania [s]
end

% siła sygnału Wi-Fi w dB