function [ output_args ] = autoMatchPhotoSpectrum( spectrumData, img, characteristicPeakWavelengths, photoScanheightLocation )
%matchPhotoSpectrum This function tries to match the spectrum (swan band)
%with the hyperspectral image as close as possible.

%% ========================
% Spectrum pre-processing
% =========================

% Get the wavelengths
spectrumRange = spectrumData(:,1);

% Find two characteristic peaks in the spectrum
smoothedSpectrum = curveSmoother(spectrumData(:,2),2);

%% ========================
% Image pre-processing
% =========================

% The img has the longest wavelength on the right. To be consistent with
% the spectral data the image is flipped.
img = fliplr(img);

% Merge the rgb colors of the img by summing them, this will result in a
% clearer border of the flames
summedImage = sum(img(photoScanheightLocation,:,:),3);
smoothedImage = curveSmoother(summedImage, 2);

% Get the width of the original flame, it is assumed that due to assition
% of the colors and that the dispersed spectrum is far less bright. That
% the original flame is the brightest. So the 2 highest peaks should
% correspond to the the borders of the flame.
[peakValue, peakIndex] = findpeaks(smoothedImage);
[value, index] = sort(peakValue,'descend');

% Show that the peaks are found
figure()
plot(smoothedImage)
hold on
scatter(peakIndex(index([1,2])), value([1,2]))

% Show that the peaks are found
figure()
plot(summedImage)
hold on
scatter(peakIndex(index([1,2])), summedImage(peakIndex(index([1,2]))))

% Find the same 2 peaks in the picture
%% ========================
% Stitching
% =========================


% Scale the spectrum to match the picture (or axis scaling)

% Shift the spectrum to match the image (or axis shifting)
end

