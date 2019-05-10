function cropped_char = crop(image)

binary_image = im2bw(image,0.01);               %#ok<IM2BW>
boundingbox = regionprops(binary_image,'boundingbox');

bound = boundingbox(1);
x = bound.BoundingBox;
xmin = x(1,1);
ymin = x(1,2);
width = x(1,3);
init_height = x(1,4);
rect = [xmin ymin width init_height];

combinedimage = imcrop(image, rect);

for index = 2:numel(boundingbox)
    bound = boundingbox(index);
    x = bound.BoundingBox;
    xmin = x(1,1);
    ymin = x(1,2);
    width = x(1,3);
    height = x(1,4);
    
    new_height = size(combinedimage,1);
    
    if new_height >= height
        difference = init_height - height;
        height = height + difference;
        rect = [xmin ymin width height];
        cropped_char = imcrop(image, rect);
    end
    if new_height < height
        rect = [xmin ymin width height];
        cropped_char = imcrop(image, rect);
        difference = height - init_height;
        z = uint8(zeros(difference,size(combinedimage,2),3));
        combinedimage = cat(1, z, combinedimage);
    end
    combinedimage  = cat(2,combinedimage, cropped_char);
    cropped_char = combinedimage;
end
end