function segmented_image = segmentation(x)
% initialise, get region properties
regioninfo = regionprops(x,'All');
counter = 1;
region_index = zeros();

% get region indexes for areas above 7000
for a = 1:numel(regioninfo)
    if regioninfo(a).Area > 7000
        region_index(1,counter) = a;
        counter = counter + 1;
    end
end

% loop through the indexes for segmentation
for ii = 1:size(region_index,2)
    
    i = region_index(1,ii);
    
    PixelList = [regioninfo(i).PixelList];
    start = PixelList(1,1);
    max_row = max(PixelList(:,2));
    min_row = min(PixelList(:,2));
    max_col = max(PixelList(:,1));
    min_col = min(PixelList(:,1));
    range = 10;
    min_sum = 9999;
    
    center = round((max_col - min_col)/2);
    
    colsum = zeros(1,185);
    counter = 1;
    
    % sum up the total number of bright pixels col by col, put result into colsum
    for i = min_col:max_col
        counter = counter + 1;
        for j = min_row:max_row
            colsum(1,counter) = x(j,i) + colsum(1,counter);
        end
    end
    
    % finds the column number with the lowest number of bright pixels
    % starts the search near the center
    for a = center-range : center+range
        temp = colsum(1,a-1) + colsum(1,a) + colsum(1,a+1);
        if temp < min_sum
            min_sum = temp;
            min_index = a;
        end
    end
    
    % draws the segmentation line
    x(min_row:max_row , min_index-1+start:min_index+1+start) = 0;
    
    segmented_image = x;
end
end