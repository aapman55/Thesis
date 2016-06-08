% Clean up
clear all
clc

% Load image
im=imread('girl8.bmp');
figure(1)
subplot(1,4,1);
imshow(im)
title('Original image');

% Fourier transform
f = fft2(double(im));

% Recenter fft
F = fftshift(f);

% Take absolute value
S = abs(F);

% Show Fourier image
subplot(1,4,2)
imshow(log(1+S),[]);
title('Fourier image');

% Cut out part of frequency
lowPass = 0;

top = 7/16;
bottom = 9/16;
left = 3/8;
right = 5/8;

if (lowPass)
    F(1:floor(end*top),1:end) = zeros(size(F(1:floor(end*top),1:end)));
    F(floor(end*bottom):end,1:end) = zeros(size(F(floor(end*bottom):end,1:end)));
    F(1:end,1:floor(end*left)) = zeros(size(F(1:end,1:floor(end*left))));
    F(1:end, floor(end*right):end) = zeros(size(F(1:end, floor(end*right):end)));
else
    F(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right)) = zeros(size(F(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right))));
end

% Take absolute value
S = abs(F);

% Show Fourier image
subplot(1,4,3)
imshow(log(1+S),[]);
title('Fourier image band passed');

% Inverse fourier transform
I = ifftshift(F);
IF = ifft2(I);

subplot(1,4,4)
imshow(abs(IF),[]);
title('Inverse Fourier image');

