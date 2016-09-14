% This script tests the idea of convoluting a 1D shape into 1 line
clear; close all; clc;
%% Start program (input)
% Amount of colors (amount of columns)
amountOfColors = 100;

% Amount of elements in the height direction (Amount of row entries)
amountOfElementsInHeight = 100;

% Dictates the percentage of the center part blocked by the filter
percentageBlocked = 0;

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
truncatedColors = base(:,45:70,:);

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

% Create bigger zero matrix to be used for shifting the colors
bigMatrix = repmat(zeros(size(truncatedColors)),2,1);

% Now for each column in the truncated Colors put them in the corresponding
% row in the bigMatrix but shift every column 2 down with respect to the
% previous column

for i=0:size(truncatedColors, 2)-1
    firstIndex = i*2+1;
    lastIndex = firstIndex + size(truncatedColors, 1)-1;
    bigMatrix(firstIndex:lastIndex,i+1,:) = truncatedColors(:,i+1,:);
end

% squeeze them to one color
squeezed = 5*sum(bigMatrix,2)/size(bigMatrix,2);

image(squeezed);
