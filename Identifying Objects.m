
clear; close all; clc;

I = imread('Starfish.jpg');
figure;
imshow(I);
title('Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
figure;
imshow(Igray);
title('Step-2: Conversion of input image to greyscale');

%Step-3: Median Filter the image
FilteredIgray = medfilt2(Igray);
figure;
imshow(FilteredIgray);
title('Step-3: Median Filter Application');

%Step-4: Invert and Binarise the image
binaryImage = ~imbinarize(FilteredIgray, 0.89);
figure;
imshow(binaryImage)
title('Step-4: Invert and Binarize the image');

%Step-5: Fill in the small segments in the image
binaryImage = bwareaopen(binaryImage,1000);
figure;
imshow(binaryImage);
title('Step-5: Fill in small segments');

%Step-6: Fill in the large segements in the image and fill in holes so that
%the area can be estimated
binaryImage = binaryImage - bwareaopen(binaryImage, 1500);
binaryImage = imfill(binaryImage,'holes');
figure;
imshow(binaryImage);
title('Step-6: Fill in large segments and holes')

%Step-7: Determine the roundness of the objects and display results
figure;
imshow(binaryImage);
title('Step-7: Show the roundness of the objects')

[B,L] = bwboundaries(binaryImage);

stats = regionprops(L,'Area','Centroid');
% loop over the boundaries
for k = 1:length(B)

  % obtain (X,Y) boundary coordinates corresponding to label 'k'
  boundary = B{k};

  % compute a simple estimate of the object's perimeter
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  
  % obtain the area calculation corresponding to label 'k'
  area = stats(k).Area;
  
  % compute the roundness metric
  metric(k) = 4*pi*area/perimeter^2;
  % display the results
  metric_string = sprintf('%2.2f',metric(k));
  
  text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','r',...
       'FontSize',14,'FontWeight','bold');
  
end
%The above code for step 6 has been taken from the MathWorks website and
%adapted to work in this program, please see reference below.
%(MathWorks, (unknown))

%Step-7: Removal of objects that do not conform to roundness figure

labelledImage = bwlabel(binaryImage);
%labels the objects
measurements = regionprops(labelledImage,'Area','Perimeter');
%finds the measurements of the objects
allAreas = [measurements.Area];
%stores the areas of the objects
allPerimeters = [measurements.Perimeter];
%stores the perimeters of the objects
roundnessScore =  (4*pi*allAreas) ./ allPerimeters.^2;
% computes the circularities using the metric
starFish = roundnessScore < 0.2; 
%declares the starfish as being any object that has a roundness score of
%less than 0.2
foundStarfish = find(starFish);

binaryImage = ismember(labelledImage, foundStarfish);
%finds the starfish in binaryImage
figure;
imshow(binaryImage);
title('Final Image');

%References

%Mathworks (unknown) Identifying Round Objects. MathWorks. Available from https://uk.mathworks.com/help/images/examples/identifying-round-objects.html
%[accessed 11th December 2017].




