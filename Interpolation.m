clear; close all; clc;

% Step-1: Load input image
I = imread('Zebra.jpg');
figure;
imshow(I);
title('Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
figure;
imshow(Igray);
title('Step-2: Conversion of input image to greyscale');

% Step-3: Nearest Neighbour Interpolation 

originalSize = size(Igray);                   
enlargedSize = 3*size(Igray);  
rowIndices = min(round(((1:enlargedSize(1))-0.5)./3 +0.5),originalSize(1));
colIndices = min(round(((1:enlargedSize(2))-0.5)./3 +0.5),originalSize(2));
% creates a new set of indices for the new image 
NearestNeighbourImage = Igray(rowIndices,colIndices,:);
% creates the new image by indexing the old image
figure;
imshow(NearestNeighbourImage);
title('Step-3: Nearest Neighbour Interpolation');

% Step-4: Bilinear Interpolation

scale = 1/3; %original scale divided by new scale
[columnFraction, rowFraction] = meshgrid(1 : enlargedSize(2), 1 : enlargedSize(1));
%creates a grid of coordinates for the enlarged image
rowFraction = rowFraction * scale;
columnFraction = columnFraction * scale;
%computes the fractional location of each new image pixel in the old image
rowInteger = floor(rowFraction);
columnInteger = floor(columnFraction);
%finds the integer part of the fractions.
rowInteger(rowInteger < 1) = 1;
columnInteger(columnInteger < 1) = 1;
%the pixel we want to get cannot be less than one, therefore anything less
%than one must be rounded up
rowInteger(rowInteger > originalSize(1) - 1) = originalSize(1) - 1;
columnInteger(columnInteger > originalSize(2) - 1) = originalSize(2) - 1;
%the pixel we want to get cannot be more than the size of the original
%image(-1), therefore anything higher must be rounded down.
deltaRows = rowFraction - rowInteger;
deltaColumns = columnFraction - columnInteger;
%find the fractional parts of the row and column locations
currentPixelIndices = sub2ind([originalSize(1), originalSize(2)], rowInteger, columnInteger);
rowPlusOneIndices = sub2ind([originalSize(1), originalSize(2)], rowInteger+1,columnInteger);
columnPlusOneIndices = sub2ind([originalSize(1), originalSize(2)], rowInteger, columnInteger+1);
columnAndRowPlusOneIndices = sub2ind([originalSize(1), originalSize(2)], rowInteger+1, columnInteger+1);       
%output the desired pixel locations into a linear index for easier access
bilinearImage = zeros(enlargedSize(1), enlargedSize(2));
bilinearImage = cast(bilinearImage, class(Igray));
%declare output image
for count = 1 : size(Igray, 3)
    Igray2 = double(Igray(:,:,count)); 
    J = Igray2(currentPixelIndices).*(1 - deltaRows).*(1 - deltaColumns) + ...
                   Igray2(rowPlusOneIndices).*(deltaRows).*(1 - deltaColumns) + ...
                   Igray2(columnPlusOneIndices).*(1 - deltaRows).*(deltaColumns) + ...
                   Igray2(columnAndRowPlusOneIndices).*(deltaRows).*(deltaColumns);
    bilinearImage(:,:,count) = cast(J, class(Igray));
end
%for loop populates the output image by performing the bilinear
%calculations (see report for further info).
figure;
imshow(bilinearImage);
title('Step-4: Bilinear Interpolation');
    



