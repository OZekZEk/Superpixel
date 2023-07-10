function closestLabel = findClosestLabel(labels, pixel, centers)
    minDistance = Inf;
    closestLabel = 0;
    

    for ii = 1:size(centers, 1)
        center = centers(ii, :);
        distance = norm(pixel - center);
        if distance < minDistance
            minDistance = distance;
            closestLabel = labels(center(ii,1), center(ii,2));
        end
    end
end