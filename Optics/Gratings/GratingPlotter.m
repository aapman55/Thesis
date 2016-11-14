% This script uses the Grating class to make plots
%
clear; close all; clc

% Create a square with a darkened square in the middle
SQ = ones(100,100);
Darkener = zeros(30,60);
SQ(36:65,21:80) = Darkener;

im = Grating.diffractHorizontally(SQ);

% Deconvolve
PSF = fspecial('motion',40,180);
INITPSF = ones(size(PSF));
[J P] = deconvblind(im,INITPSF,30);
figure
imshow(J)
title('Restored Image')
figure
imshow(P,[],'InitialMagnification','fit')
title('Restored PSF')