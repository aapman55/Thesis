function [ handle ] = plotLinespread( img , direction, pivotLine, range)
%plotLineSpread is a function that takes a target image that has been
%specifically made for the purpose of determining the linespread function.

% Convert the image to grayscale when the image is RGB
if(isRGB(img))
    img = rgb2gray(img);
end

% Parse direction Should be 'v', or 'h' for vertical or horizontal
switch direction
    case 'v'
        X = range;
        Y = pivotLine;
        picX = X;
        picY = Y;
        cutOut = img(picX,picY)';
    case 'h'
        X = pivotLine;
        Y = range;
        picX = X;
        picY = Y;
        cutOut = img(picX,picY);
        error('The direction must either by v or h!')
end

% Create figures
handle = figure();
subplot(2,1,2)
plot(img(X,Y));
hold on
plot(diff(img(X,Y)))
axis tight
xlabel('pixels [-]')
ylabel('Intensity/rate of change of intensity [-]')

subplot(2,1,1)
imagesc(cutOut);
colormap('gray');

end

function bool = isRGB(img)
    bool = size(img,3) == 3;
end