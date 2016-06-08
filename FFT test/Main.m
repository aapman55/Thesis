im = imread('charmander.png');

imshow(im);

FFTres = abs(fft2(im));

FFTres = fftshift(FFTres);


IFFTres = ifft2(ifftshift(FFTres));

imshow(uint8(abs(IFFTres)))

