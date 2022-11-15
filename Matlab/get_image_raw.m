function img = get_image_raw(image_raw_sub)
    img_msg = receive(image_raw_sub, 5); % czas oczekiwania [s]
    img = readImage(img_msg);
end