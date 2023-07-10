clear all; close all; clc;
% function generateSuperpixels(imagePath, numSuperpixels)
    % Read the image
    image = imread("res1.jpg");
    numSuperpixels = 500;
    m = 80; % This value can be in the range [1,20]
    % Convert the image to the Lab color space
    labImage = rgb2lab(image);

    % Get the image dimensions
    [height, width, ~] = size(image);

    % Initialize variables
    step = floor(sqrt((width * height) / numSuperpixels));
    gridSpacingX = round(width / step);
    gridSpacingY = round(height / step);
    labels = zeros(height, width);
    label_distances = ones(height, width)*width*height;

    % Initialize cluster centers
    centersX = round(step/2):step:width;
    centersY = round(step/2):step:height;
    [gridY, gridX] = meshgrid(centersY, centersX);
    centers = [gridY(:), gridX(:)];

    %gradient calculation
    gradient_pixels = find_gradient(image);

    % Iterate for convergence
    numIterations = 12;  % Adjust the number of iterations as needed

    % all_dist = zeros(height,width,numIterations,length(centers(:,1)),1);
    for iteration = 1:numIterations
        % Assign labels to pixels
        for centerIdx = 1:size(centers, 1)
            % Corrected widht/height boundary condition check
            cx = min(round(centers(centerIdx, 2)), width);
            cy = min(round(centers(centerIdx, 1)), height);
            xMin = max(round(cx - step), 1);
            xMax = min(round(cx + step), width);
            yMin = max(round(cy - step), 1);
            yMax = min(round(cy + step), height);
            for y = yMin:yMax
                for x = xMin:xMax
                    colorDist = sqrt(double((labImage(y,x,1)-labImage(cy,cx,1))^2+(labImage(y,x,2)-labImage(cy,cx,2))^2+(labImage(y,x,3)-labImage(cy,cx,3))^2));
                    spatialDist = sqrt(double((x-cx)^2+(y-cy)^2));
                    dist = colorDist+(m/step)*spatialDist;
                    if dist < label_distances(y, x) || labels(y, x) == 0
                        labels(y, x) = centerIdx;
                        label_distances(y, x) = dist;
                    end
                end
            end
        end

        % Update cluster centers
        centersNew = zeros(size(centers));
        counts = zeros(size(centers, 1), 1);
        unique_values = unique(labels);

        for ii =1:length(unique_values)
            labeleq = find(labels==unique_values(ii));
        end
        for center_idx = 1:length(centers)
            [rowIndices, colIndices] = find(labels == center_idx);
            x_summed = sum(rowIndices);
            y_summed = sum(colIndices);
            centersNew(center_idx, 2) = round(x_summed/length(rowIndices));
            centersNew(center_idx, 1) = round(y_summed/length(rowIndices));
        end
        centersNew = centerInLabels(centersNew,labels);
        centers = centersNew;
    end

    connected_labels = zeros(size(labels));
    checked_pixels = connected_labels;
    controlled_pixels = connected_labels;

    for centerIdx = 1:size(centers, 1)
        connected_labels(centers(centerIdx,1),centers(centerIdx,2))=labels(centers(centerIdx,1),centers(centerIdx,2));
    end

    for centerIdx = 1:size(centers, 1)
        connected_pixels=ones(4,2);
        while(~isempty(connected_pixels))
            connected_pixels=[];
            checked_pixels=connected_labels-controlled_pixels;
            [rowIndices, colIndices] = find(checked_pixels == centerIdx);
            pixel_index = [rowIndices, colIndices];
            for ii=1:length(pixel_index(:,1))
                connected_pixels = check4Connectivity(labels, pixel_index(ii,:));
                for connected_pixels_index = 1:length(connected_pixels(:,1))
                    connected_labels(connected_pixels(connected_pixels_index,1),connected_pixels(connected_pixels_index,2))=centerIdx;
                end
                controlled_pixels(pixel_index(ii,1), pixel_index(ii,2))=1;
            end
        end
    end

    [rowIndices, colIndices] = find(connected_labels == 0);
    pixel_value_zero_index = [rowIndices, colIndices];

    for label_index_x = 1:size(connected_labels, 1)
        for label_index_y = 1:size(connected_labels, 2)
            if connected_labels(label_index_x, label_index_y)==0
                min_dist = 0;
                for center_index = 1:length(centersNew)
                    dist_x = centersNew(center_index, 1)-label_index_x;
                    dist_y = centersNew(center_index, 2)-label_index_y;
                    distance = (dist_x*dist_x)+(dist_y*dist_y);
                    if min_dist==0 || distance<min_dist
                        connected_labels(label_index_x, label_index_y)=labels(centersNew(center_index, 1), centersNew(center_index, 2));
                        min_dist = distance;
                    end
                end
            end
        end
    end

    % Create a mask for superpixel visualization
    mask = zeros(size(image));
    unique_values = unique(labels);

    % Draw boundaries and assign random colors to each superpixel
    % contourColor = [255, 0, 0];  % Red color for boundaries
    for centerIdx = 1:length(unique_values)
        [rowIndices, colIndices] = find(labels == unique_values(centerIdx));
        % rand_colour = randi([0, 255], [1, 3]);
        color = [0,0,0];
        for label_idx = 1:length(rowIndices)
            pixel_color = double(image(rowIndices(label_idx), colIndices(label_idx), :))/255;
            color(1) = color(1)+pixel_color(1);
            color(2) = color(2)+pixel_color(2);
            color(3) = color(3)+pixel_color(3);    
        end
        color = color/length(rowIndices)*100;
        mask(rowIndices,colIndices, 1) = color(1);
        mask(rowIndices,colIndices, 2) = color(2);
        mask(rowIndices,colIndices, 3) = color(3);
    end
    %mask = uint8(mask);
    BW = boundarymask(connected_labels);
    figure
    imshow(imoverlay(image,BW,'cyan'),'InitialMagnification',67)
%     mask = lab2rgb(mask);
%     mask = uint8(mask);
%     % Display the superpixel mask
%     figure
%     imshow(mask);
% end