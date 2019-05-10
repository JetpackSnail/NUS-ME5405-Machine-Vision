function [row1, row2] = getrowlimits(segmented_binary_image)

boundingbox = regionprops(segmented_binary_image,'boundingbox');
height_threshold = 150;
min_topleft_1(1,1:2) = 99999;
max_btmright_1(1,1:2) = 0;
min_topleft_2(1,1:2) = 99999;
max_btmright_2(1,1:2) = 0;
coordinates(13,4) = 0;

% find the boundingbox for toprow and bottomrow
for i = 1:numel(boundingbox)
    coordinates(i,1) = boundingbox(i).BoundingBox(1);   	%topleft x-coordinate
    coordinates(i,2) = boundingbox(i).BoundingBox(2);   	%topleft y-coordinate
    length = boundingbox(i).BoundingBox(3);
    height = boundingbox(i).BoundingBox(4);
    coordinates(i,3) = coordinates(i,1) + length;       	%btmright x-coordinate
    coordinates(i,4) = coordinates(i,2) + height;       	%btmright y-coordinate
    
    if coordinates(i,2) < height_threshold
        if coordinates(i,1) < min_topleft_1(1,1)
            min_topleft_1(1,1) = coordinates(i,1);
        end
        if coordinates(i,2) < min_topleft_1(1,2)
            min_topleft_1(1,2) = coordinates(i,2);
        end
        if coordinates(i,3) > max_btmright_1(1,2)
            max_btmright_1(1,1) = coordinates(i,3);
        end
        if coordinates(i,4) > max_btmright_1(1,2)
            max_btmright_1(1,2) = coordinates(i,4);
        end
        
    else
        if coordinates(i,1) < min_topleft_2(1,1)
            min_topleft_2(1,1) = coordinates(i,1);
        end
        if coordinates(i,2) < min_topleft_2(1,2)
            min_topleft_2(1,2) = coordinates(i,2);
        end
        if coordinates(i,3) > max_btmright_2(1,2)
            max_btmright_2(1,1) = coordinates(i,3);
        end
        if coordinates(i,4) > max_btmright_2(1,2)
            max_btmright_2(1,2) = coordinates(i,4);
        end
    end
end

row1 = [min_topleft_1(1,1), min_topleft_1(1,2), max_btmright_1(1,1), max_btmright_1(1,2)];
row2 = [min_topleft_2(1,1), min_topleft_2(1,2), max_btmright_2(1,1), max_btmright_2(1,2)];

end