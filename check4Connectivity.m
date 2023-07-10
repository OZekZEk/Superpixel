function connected_pixels = check4Connectivity(label, pixel_index)

    connected_pixels=zeros(4,2);

    % Check if the pixel and the center have the same value and share an edge
    if (pixel_index(2)-1>0)&&(label(pixel_index(1),pixel_index(2)) == label(pixel_index(1),pixel_index(2)-1))
        connected_pixels(1,1) = pixel_index(1);
        connected_pixels(1,2) = pixel_index(2)-1;

    end 
    if (pixel_index(2)+1)<length(label(1,:,1))&&(label(pixel_index(1),pixel_index(2)) == label(pixel_index(1),pixel_index(2)+1))
        connected_pixels(2,1) = pixel_index(1);
        connected_pixels(2,2) = pixel_index(2)+1;
    end
    if (pixel_index(1)+1)<length(label(:,1,1))&&(label(pixel_index(1),pixel_index(2)) == label(pixel_index(1)+1,pixel_index(2)))
        connected_pixels(3,1) = pixel_index(1)+1;
        connected_pixels(3,2) = pixel_index(2);
    end
    if (pixel_index(1)-1>0)&&(label(pixel_index(1),pixel_index(2)) == label(pixel_index(1)-1,pixel_index(2)))
        connected_pixels(4,1) = pixel_index(1)-1;
        connected_pixels(4,2) = pixel_index(2);
    end
    connected_pixels = connected_pixels(any(connected_pixels,2),:);
end