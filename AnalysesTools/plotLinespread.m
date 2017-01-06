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
    otherwise
        error('The direction must either by v or h!')
end

% Create figures
handle = figure();
subplot(2,1,2)
plot(picX,img(X,Y));
hold on
plot(picX(1:end-1),diff(img(X,Y)))
axis tight
xlabel('pixels [-]')
ylabel('Intensity [-]')
legend('Intensity','Change in intensity')
grid on

subplot(2,1,1)
imagesc(picX, picY,cutOut);
colormap('gray');
xlabel('Pixels [-]')
ylabel('Pixels [-]')

end

function bool = isRGB(img)
    bool = size(img,3) == 3;
end