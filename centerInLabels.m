function centersNewNew = centerInLabels(centersNew,labels)
centersNewNew = centersNew;
    for centernew_index = 1:size(centersNew,1)
        if labels(centersNew(centernew_index,1),centersNew(centernew_index,2))==centernew_index
            continue;
        else
            [rowIndices, colIndices] = find(labels==centernew_index);
            label_coor=[rowIndices, colIndices];
            min_dist=0;
            for label_coor_index = 1:size(label_coor,1)
                dist = (centersNew(centernew_index,1)-label_coor(label_coor_index,1))^2+(centersNew(centernew_index,2)-label_coor(label_coor_index,2))^2;
                if min_dist==0 || dist<min_dist
                    min_dist=dist;
                    centersNewNew(centernew_index,1)=label_coor(label_coor_index,1);
                    centersNewNew(centernew_index,2)=label_coor(label_coor_index,2);
                end
            end
        end
    end
end