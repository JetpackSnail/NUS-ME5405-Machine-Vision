function scaledcroppedimage = imgscalecrop(scale, row, image)
cropped_image = imcrop(image, [round(row(1,1)) round(row(1,2)) row(1,3)-row(1,1) row(1,4)-row(1,2)]);
scaledcroppedimage = imresize(cropped_image, scale);
end