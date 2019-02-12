clear; close all; clc;

I = imread('Noisy.png');
figure;
imshow(I);
title('Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
figure;
imshow(Igray);
title('Step-2: Conversion of input image to greyscale');

% Step-3 Mean(Average) Filtering
PaddedIgray = padarray(Igray, [2,2],0,'both');
%pad the array to 
PaddedIgray = int16(PaddedIgray);
SmoothIgray = int16(zeros(474,756));

for rowCount = 1:size(PaddedIgray, 1)-4
    for columnCount = 1:size(PaddedIgray, 2)-4
        total = 0;
        for filterRows = 1:5
            for filterColumns = 1:5
            total = total + PaddedIgray(rowCount+(filterRows-1),columnCount+(filterColumns-1));
            %add the pixel values together
            end
        end
        average = round(total/25);
        %find the mean
        SmoothIgray(rowCount,columnCount) = average;
    end
end
SmoothIgray = uint8(SmoothIgray);
figure;
imshow(SmoothIgray);
title('Step-3 Mean (Average) Filtering');

%Step 4- Median Filtering

for rowCount = 1:size(PaddedIgray, 1)-4
    for columnCount = 1:size(PaddedIgray, 2)-4
        medianCheck = zeros(1,25);
        medianCounter = 1;
        for filterRows = 1:5
            for filterColumns = 1:5
            medianCheck(1, medianCounter) = PaddedIgray(rowCount+(filterRows-1),columnCount+(filterColumns-1));
            % add the pixel values to the matrix
            medianCounter = medianCounter + 1;
            end
        end
        medianAverage = median(medianCheck);
        %find the median
        SmoothIgray(rowCount,columnCount) = medianAverage; 
        
    end
end
figure;
imshow(SmoothIgray);
title('Step-4 Median Filtering');
