% This script tests the idea of convoluting a 1D shape into 1 line
clear; close all; clc;
%% Start program (input)
% Amount of colors (amount of columns) [50]
amountOfColors = 1000;

% Amount of elements in the height direction (Amount of row entries) [100]
amountOfElementsInHeight = amountOfColors;

% Dictates the percentage of the center part blocked by the filter [50]
percentageBlocked = 50; 

% Specify the portion you select from the generated spectrum (in
% percentage) [45,70]
beginSpectrum = 40;
endSpectrum = 70;

% Specify the speed of the diffraction grating (not in real /mm but just a
% number) [3]
speedGrating = 2;

% Magnifying factor to put more brightness in the image; [2]
brightnessFactor = 1;

%% Initialisation
% Get colors
colors = hsv(amountOfColors)';

% Initialise image (white)
base = ones(amountOfElementsInHeight,amountOfColors,3);

% Assign colors to image
base(:,:,1) = repmat(colors(1,:),amountOfElementsInHeight,1);
base(:,:,2) = repmat(colors(2,:),amountOfElementsInHeight,1);
base(:,:,3) = repmat(colors(3,:),amountOfElementsInHeight,1);

% Put colors through slit to gather desired colors
truncatedColors = base(:,floor(beginSpectrum/100*amountOfColors):floor(endSpectrum*amountOfColors/100),:);

%Show image
image(truncatedColors)

% Block part of the spectrum
blockedElements = floor(size(truncatedColors,1)*percentageBlocked/100);
% Create blocking filter
blockingFilter = zeros(blockedElements,size(truncatedColors,2),3);

% Calculate index start
indexStart = floor((size(truncatedColors,1) - blockedElements)/2);
% Apply filter
truncatedColors(indexStart:indexStart+blockedElements-1,:,:) = blockingFilter;

image(truncatedColors);

newAmtColors = size(truncatedColors,2);
% Create bigger zero matrix to be used for shifting the colors
bigMatrix = zeros(speedGrating*newAmtColors+amountOfElementsInHeight,newAmtColors,3);

% Now for each column in the truncated Colors put them in the corresponding
% row in the bigMatrix but shift every column 2 down with respect to the
% previous column

for i=0:size(truncatedColors, 2)-1
    firstIndex = i*speedGrating+1;
    lastIndex = firstIndex + size(truncatedColors, 1)-1;
    bigMatrix(firstIndex:lastIndex,i+1,:) = truncatedColors(:,i+1,:);
end

figure()
image(bigMatrix)

minimumBrightness = min(min(min(bigMatrix)));
maximumBrightness = max(max(max(bigMatrix)));
factor = 1/(maximumBrightness-minimumBrightness)*3;

% squeeze them to one color
squeezed = brightnessFactor*factor*sum(bigMatrix,2)/size(bigMatrix,2);
figure();
image(squeezed);
