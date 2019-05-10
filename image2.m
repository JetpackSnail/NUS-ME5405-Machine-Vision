%% Stage 0 - Setup

clear;
clc;
close all;
tic;

%% Stage 1 - Pre-Processing

image = imread('./charact2.bmp');
imshow(image);
title('Original image');

%% Stage 2 - Thresholding Image

% separate the image to rgb channels
red = image(:,:,1);
green = image(:,:,2);
blue = image(:,:,3);

% threshold image as binary
red_threshold = 106;
green_threshold = 107;
blue_threshold = 107;

binary_image = red>red_threshold & green>green_threshold & blue>blue_threshold;

%image cleaning
binary_image = bwareaopen(binary_image,1800);
binary_image = bwmorph(binary_image,'thin',1);
binary_image = bwmorph(binary_image,'majority', 20);
binary_image = bwareaopen(binary_image,180);
binary_image = bwmorph(binary_image,'thicken', 2);
binary_image = bwmorph(binary_image,'close', 2);
binary_image = bwareaopen(binary_image,80);

figure;
imshow(binary_image);
title('Binary image');

%% Stage 3 - Outline Determination of Object

outline_image = bwmorph(binary_image,'remove', 1);
figure;
imshow(outline_image);
title('Outline of image');

%% Stage 4 - Image Segmentation

% segmentation function
segmented_binary_image = segmentation(binary_image);
figure;
imshow(segmented_binary_image);
title('Binary segmented image');

% colour the different characters in a random colour
labeled = labelmatrix(bwconncomp(segmented_binary_image,8));
segmented_regioninfo = regionprops(labeled,'All');
segmented_image = label2rgb(labeled, 'parula', 'k', 'shuffle');
figure;
imshow(segmented_image);
title('Segmented image');

% plot centroid on same image
%  	hold on;
%   	centroid = regionprops(segmented_binary_image2, 'Centroid');
% 	for i = 1: numel(centroid)
%         plot(centroid(i).Centroid(1),centroid(i).Centroid(2),'rp');
% 	end
% 	hold off;

%% Stage 5 - Rotation of Objects

rotated_image90 = rotate(-90, segmented_image);
rotated_image30 = rotate(30, segmented_image);

figure;
imshow(rotated_image90);
title('Rotated image 90 degrees clockwise');

figure;
imshow(rotated_image30);
title('Rotated image 30 degrees anticlockwise');

%% Stage 6 - Thinning of Characters

thin_image = bwmorph(segmented_binary_image,'skel', 'Inf');
thin_image = bwmorph(thin_image, 'spur',9);
figure;
imshow(thin_image);
title('Image of 1-pixel thin characters');

%% Stage 7 - Scaling and Display

% get limits of top row and bottom row for cropping
[row1, row2] = getrowlimits(segmented_binary_image);

% crop the image into 2 rows and resize (row1 = top row, row2 = bottom row)
scale = 0.75;
row1_image = imgscalecrop(scale, row1, segmented_image);
row2_image = imgscalecrop(scale, row2, segmented_image);

%figure; imshow(row1_image);
%figure; imshow(row2_image);

% resize the images to concat
if size(row1_image,1) > size(row2_image,1)
    row2_image = imresize(row2_image, [size(row1_image,1) size(row2_image,2)]);
end

if size(row1_image,1) < size(row2_image,1)
    row1_image = imresize(row1_image, [size(row2_image,1) size(row1_image,2)]);
end

scaled_image = cat(2, row1_image, row2_image);


% resize the entire image to fit dimensions of original image
if size(scaled_image, 1) < size(image, 1)
    diff = floor((size(image,1) - size(scaled_image,1)) / 2) ;
    scaled_image = padarray(scaled_image, diff);
end

if size(scaled_image, 2) < size(image, 2)
    diff = floor((size(image,2) - size(scaled_image,2)) / 2) ;
    scaled_image = cat(2, zeros(size(scaled_image,1),diff,3), scaled_image, zeros(size(scaled_image,1),diff,3));
end

figure;
imshow(scaled_image);
title('Scaled Image');

toc;

