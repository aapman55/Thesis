clear all
clc

im=imread('balk.png');
figure(1)
imshow(im)
title('Original image');

F = fft2(double(im));

F = fftshift(F);

S = abs(F);

figure(2)
imshow(S,[]);
title('Fourier image');

I = ifft2(S);

figure(3)
imshow(I)