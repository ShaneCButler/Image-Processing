clear; close all; clc;

I = imread('SC.png');
figure;
imshow(I);
title('Step-1: Load input image');

for count1 = 1:size(I, 1)
    %loop through the rows
    for count2 = 1:size(I,2)
        %loop throug the columns
        if (I(count1,count2) > 79) && (I(count1,count2) < 101)
            I(count1,count2) = 220;
            %change the value of the pixel to 220 if it meets the criteria
        end
    end

end
figure;
imshow(I);
title('Step-2: Piecewise-Linear Transformation');
