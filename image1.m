%% Stage 0 - Setup

clear;
clc;
close all;
tic;

%% Stage 1 - Pre-Processing

% charact1 is a 64 x 64 image
A = fscanf(fopen('charact1.txt'), [char(13) newline '%c'],[64,64]);

% fscanf returns column vectors, transpose will show the correct image
A = A';

% offset from '0' as the intensity value
img = zeros((size(A,1)), (size(A,2)));
for i = 1:size(img,1)
    for j = 1:size(img,2)
        if A(i,j) > '0'
            img(i, j) = A(i,j)- '0';
        end
    end
end

Gray = mat2gray(img,[min(img(:)) max(img(:))]);
imshow(Gray);
title('Original grayscale image');

%% Stage 2 - Thresholding Image

% threshold image as binary
threshold = 0;
BW = Gray > threshold;
figure;
imshow(BW);
title('Binary image');

%% Stage 3 - Outline Determination of Object

% create an outline image
outline_image = bwmorph(BW,'remove', 1);
figure;
imshow(outline_image);
title('Outline of image');

%% Stage 4 - Image Segmentation

% colour the different characters in a random colour
labeled = labelmatrix(bwconncomp(BW,8));
RGB_label = label2rgb(labeled,'jet','k','shuffle');
figure;
imshow(RGB_label);
title('Segmented image');

%% Stage 5 - Rotation of Objects

rot30 = rotate_img1(30,RGB_label);
rot90 = rotate_img1(-90,RGB_label);
figure;
imshow(rot90);
title('Rotated image 90 degrees clockwise');

figure;
imshow(rot30);
title('Rotated image 30 degrees anticlockwise');


%% Stage 6 - Thinning of Characters

%display image with one pixel thick objects
Timg = bwmorph(BW,'thin',inf);
figure;
imshow(Timg);
title('Image of 1-pixel thin characters');



%% Stage 7 - Scaling and Display

%scale and display image in one line

combined_image = crop(RGB_label);
combined_image = padarray(combined_image, [10,3],0,'both');
figure;
imshow(combined_image);
title('Scaled Image');

toc;
