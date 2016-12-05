function [ output_args ] = manualMatchPhotoSpectrum( img, spectrumData, twoImagePoints, twoSpectrumWaveLengths, verticalScanLocation )
%manualMatchPhotoSpectrum matches the spectrum with the dispersed image

%% Preprocess image data
imgLineData = img(verticalScanLocation,:,:);
% Compress all colors
summedImgLineData = sum(imgLineData,3);

%% Preprocessing spectrumData
spectrumRange = spectrumData(:,1);
spectrumValue = spectrumData(:,2);

%% Get shifts and resizes

% Resize
lengthImage = length(summedImgLineData);
flameFrontOffset = twoImagePoints(2)-twoImagePoints(1);

lengthSpectrum = spectrumRange(end) - spectrumRange(1);
spectrumOffset = twoSpectrumWaveLengths(2) - twoSpectrumWaveLengths(1);

scale = (spectrumOffset/lengthSpectrum)/(flameFrontOffset/lengthImage);

newSpectrumLength = scale*lengthSpectrum;

% Shift
imgPercentageLeftOffSet = (twoImagePoints(1)/lengthImage);
spectrumPercentageLeftOffSet = (twoSpectrumWaveLengths(1) - spectrumRange(1))/newSpectrumLength;

shift = (imgPercentageLeftOffSet - spectrumPercentageLeftOffSet)*newSpectrumLength;
%% Plot
figure()
subplot(2,1,1)
image(img(1000:2000,:,:))
grid minor

subplot(2,1,2)
hold on
plot(spectrumRange, spectrumValue)
axis([spectrumRange(1)-shift, spectrumRange(1)+newSpectrumLength-shift, 0, max(spectrumValue)])

% Together plot
x = linspace(spectrumRange(1)-shift, spectrumRange(1)+newSpectrumLength-shift, size(img,2));
y = linspace(0, max(spectrumValue), size(img,1));
[X,Y] = meshgrid(x,y);

figure()
image(X(:),Y(:),flipud(img(:,:,:)))
hold on
plot(spectrumRange, spectrumValue,'color',[1,1,1])
axis([spectrumRange(1)-shift, spectrumRange(1)+newSpectrumLength-shift, 0, max(spectrumValue)])
axis xy
end

