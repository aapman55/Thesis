% Clean up
clear all
close all
clc

% Load image
im=imread('charmander.png');
figure(1)
subplot(1,2,1);
imshow(im)
title('Original image');

% Show the 3 colors
figure(2)
red = im(:,:,1);
green = im(:,:,2);
blue = im(:,:,3);

subplot(3,4,1)
imshow(red,[]);
title('Original image red');

subplot(3,4,5)
imshow(blue,[]);
title('Original image green');

subplot(3,4,9)
imshow(green,[]);
title('Original image blue');

% Fourier transform
fred = fft2((red));
fgreen = fft2((green));
fblue = fft2((blue));

% Recenter fft
Fred = fftshift(fred);
Fgreen = fftshift(fgreen);
Fblue = fftshift(fblue);

% Take absolute value
Sred = abs(Fred);
Sgreen = abs(Fgreen);
Sblue = abs(Fblue);

% Show Fourier image
subplot(3,4,2)
imshow(log(1+Sred),[]);
title('Fourier image red');

subplot(3,4,6)
imshow(log(1+Sblue),[]);
title('Fourier image green');

subplot(3,4,10)
imshow(log(1+Sgreen),[]);
title('Fourier image blue');

% Cut out part of frequency
lowPass = 1;

top = 7/16;
bottom = 9/16;
left = 3/8;
right = 5/8;

if (lowPass)
    %Red
    Fred(1:floor(end*top),1:end) = zeros(size(Fred(1:floor(end*top),1:end)));
    Fred(floor(end*bottom):end,1:end) = zeros(size(Fred(floor(end*bottom):end,1:end)));
    Fred(1:end,1:floor(end*left)) = zeros(size(Fred(1:end,1:floor(end*left))));
    Fred(1:end, floor(end*right):end) = zeros(size(Fred(1:end, floor(end*right):end)));
    
    %Green
    Fgreen(1:floor(end*top),1:end) = zeros(size(Fgreen(1:floor(end*top),1:end)));
    Fgreen(floor(end*bottom):end,1:end) = zeros(size(Fgreen(floor(end*bottom):end,1:end)));
    Fgreen(1:end,1:floor(end*left)) = zeros(size(Fgreen(1:end,1:floor(end*left))));
    Fgreen(1:end, floor(end*right):end) = zeros(size(Fgreen(1:end, floor(end*right):end)));
    
    %Blue
    Fblue(1:floor(end*top),1:end) = zeros(size(Fblue(1:floor(end*top),1:end)));
    Fblue(floor(end*bottom):end,1:end) = zeros(size(Fblue(floor(end*bottom):end,1:end)));
    Fblue(1:end,1:floor(end*left)) = zeros(size(Fblue(1:end,1:floor(end*left))));
    Fblue(1:end, floor(end*right):end) = zeros(size(Fblue(1:end, floor(end*right):end)));
else
    %red
    Fred(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right)) = zeros(size(Fred(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right))));
    %green
    Fgreen(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right)) = zeros(size(Fgreen(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right))));
    %blue
    Fblue(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right)) = zeros(size(Fblue(floor(end*top):floor(end*bottom),floor(end*left):floor(end*right))));
end

% Take absolute value
Sred = abs(Fred);
Sgreen = abs(Fgreen);
Sblue = abs(Fblue);

% Show Fourier image
subplot(3,4,3)
imshow(log(1+Sred),[]);
title('Fourier image red band pass');

subplot(3,4,7)
imshow(log(1+Sblue),[]);
title('Fourier image green band pass');

subplot(3,4,11)
imshow(log(1+Sgreen),[]);
title('Fourier image blue band pass');

% Inverse fourier transform
Ired = ifftshift(Fred);
Igreen = ifftshift(Fgreen);
Iblue = ifftshift(Fblue);

IFred = ifft2(Ired);
IFgreen = ifft2(Igreen);
IFblue = ifft2(Iblue);

subplot(3,4,4)
imshow(abs(IFred),[]);
title('Inverse Fourier image red');

subplot(3,4,8)
imshow(abs(IFgreen),[]);
title('Inverse Fourier image green');

subplot(3,4,12)
imshow(abs(IFblue),[]);
title('Inverse Fourier image blue');

colored(:,:,1) = IFred;
colored(:,:,2) = IFgreen;
colored(:,:,3) = IFblue;

figure(1)
subplot(1,2,2)
imshow(abs(colored));
title('Band passed of original')

